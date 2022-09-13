import 'dart:async';

import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/src/defaults/providers/graphql/graphql_logger.dart';
import 'package:gql/ast.dart';
import 'package:graphql/client.dart';

class GraphQLService extends NetworkService {
  GraphQLService({
    required String endpoint,
    GraphQLToken? token,
    Map<String, String> headers = const {},
    GraphQLPersistence persistence = const GraphQLPersistence(),
    DefaultPolicies? defaultPolicies,
    this.timeout,
  }) : super(baseUrl: endpoint, headers: headers) {
    final link = _createLink(token: token);

    _createClient(
      link: link,
      persistence: persistence,
      defaultPolicies: defaultPolicies,
    );
  }

  final Completer<GraphQLClient> _clientCompleter = Completer();
  final Duration? timeout;
  GraphQLClient? _graphQLClient;

  GraphQLService.withClient({
    required GraphQLClient client,
    this.timeout,
  })  : _graphQLClient = client,
        super(baseUrl: '', headers: const {});

  Future<GraphQLClient> get _client async {
    if (_graphQLClient == null) {
      return _clientCompleter.future;
    }

    return _graphQLClient!;
  }

  Future<void> _createClient({
    required Link link,
    required GraphQLPersistence persistence,
    required DefaultPolicies? defaultPolicies,
  }) async {
    final cache = await persistence.setup();
    final client = GraphQLClient(
      link: link,
      defaultPolicies: defaultPolicies,
      cache: cache,
    );

    _clientCompleter.complete(client);
  }

  Future<GraphQLServiceResponse> request({
    required GraphQLMethod method,
    required String document,
    Map<String, dynamic>? variables,
    Duration? timeout,
    GraphQLFetchPolicy? fetchPolicy,
  }) async {
    final _timeout = timeout ?? this.timeout;
    final policy =
        fetchPolicy == null ? null : FetchPolicy.values[fetchPolicy.index];

    final doc = gql(document);
    final hasStitching = _hasStitching(doc);

    try {
      switch (method) {
        case GraphQLMethod.query:
          return _handleExceptions(
            await _query(doc, variables, _timeout, policy),
            hasStitching: hasStitching,
          );
        case GraphQLMethod.mutation:
          return _handleExceptions(
            await _mutate(doc, variables, _timeout, policy),
            hasStitching: hasStitching,
          );
      }
    } on TimeoutException {
      throw GraphQLTimeoutException();
    }
  }

  Link _createLink({required GraphQLToken? token}) {
    final _headers = headers ?? {};
    final httpLink = HttpLink(baseUrl, defaultHeaders: _headers);

    Link _link;
    if (token == null) {
      _link = httpLink;
    } else {
      final authLink = AuthLink(
        getToken: token.builder,
        headerKey: token.key,
      );
      _link = authLink.concat(httpLink);
    }

    // Attach GraphQL Logger only in debug mode
    assert(() {
      final loggerLink = GraphQLLoggerLink(
        endpoint: baseUrl,
        getHeaders: () async {
          // coverage:ignore-start
          return {
            if (token != null) token.key: await token.builder() ?? '',
            ..._headers,
          };
          // coverage:ignore-end
        },
      );

      _link = loggerLink.concat(_link);

      return true;
    }());

    return _link;
  }

  GraphQLServiceResponse _handleExceptions(
    QueryResult result, {
    required bool hasStitching,
  }) {
    Iterable<GraphQLOperationError> errors = [];

    if (result.hasException) {
      final operationException = result.exception!;
      final linkException = operationException.linkException;

      if (linkException is NetworkException) {
        throw GraphQLNetworkException(
          message: linkException.message,
          uri: linkException.uri,
        );
      } else if (linkException is ServerException) {
        throw GraphQLServerException(
          originalException: linkException.originalException,
          errorData: linkException.parsedResponse?.data,
        );
      }

      errors = operationException.graphqlErrors.map(GraphQLOperationError.from);

      if (result.data == null || !hasStitching) {
        throw GraphQLOperationException(errors: errors);
      }
    }

    return GraphQLServiceResponse(data: result.data!, errors: errors);
  }

  Future<QueryResult> _query(
    DocumentNode document,
    Map<String, dynamic>? variables,
    Duration? timeout,
    FetchPolicy? fetchPolicy,
  ) async {
    final options = QueryOptions(
      document: document,
      variables: variables ?? {},
      fetchPolicy: fetchPolicy,
    );

    return _timedOut((await _client).query(options), timeout);
  }

  Future<QueryResult> _mutate(
    DocumentNode document,
    Map<String, dynamic>? variables,
    Duration? timeout,
    FetchPolicy? fetchPolicy,
  ) async {
    final options = MutationOptions(
      document: document,
      variables: variables ?? {},
      fetchPolicy: fetchPolicy,
    );

    return _timedOut((await _client).mutate(options), timeout);
  }

  Future<QueryResult> _timedOut<T>(
    Future<QueryResult> request,
    Duration? timeout,
  ) async {
    if (timeout == null) return request;

    return request.timeout(timeout);
  }

  bool _hasStitching(DocumentNode document) {
    for (final definition in document.definitions) {
      if (definition is OperationDefinitionNode &&
          definition.selectionSet.selections.length > 2) {
        return true;
      }
    }

    return false;
  }
}

class GraphQLServiceResponse {
  GraphQLServiceResponse({
    required this.data,
    this.errors = const [],
  });

  final Map<String, dynamic> data;
  final Iterable<GraphQLOperationError> errors;
}

class GraphQLOperationError {
  GraphQLOperationError._({
    required this.message,
    required this.locations,
    required this.path,
    required this.extensions,
  });

  factory GraphQLOperationError.from(GraphQLError error) {
    return GraphQLOperationError._(
      message: error.message,
      locations: error.locations,
      path: error.path,
      extensions: error.extensions,
    );
  }

  /// Error message
  final String message;

  /// Locations of the nodes in document which caused the error
  final List<ErrorLocation>? locations;

  /// Path of the error node in the query
  final List<dynamic /* String | int */ >? path;

  /// Implementation-specific extensions to this error
  final Map<String, dynamic>? extensions;
}

abstract class GraphQLServiceException {}

class GraphQLOperationException implements GraphQLServiceException {
  GraphQLOperationException({required this.errors});

  final Iterable<GraphQLOperationError> errors;

  GraphQLOperationError? get error => errors.isEmpty ? null : errors.first;
}

class GraphQLNetworkException implements GraphQLServiceException {
  GraphQLNetworkException({
    required this.message,
    required this.uri,
  });

  final String? message;
  final Uri? uri;

  @override
  String toString() {
    return 'GraphQlNetworkException: $message; uri = $uri';
  }
}

class GraphQLServerException implements GraphQLServiceException {
  GraphQLServerException({
    required this.originalException,
    required this.errorData,
  });

  final Object? originalException;
  final Map<String, dynamic>? errorData;

  @override
  String toString() {
    return 'GraphQLServerException{originalException: $originalException, errorData: $errorData}';
  }
}

class GraphQLTimeoutException implements GraphQLServiceException {}

class GraphQLToken {
  GraphQLToken({required this.builder, this.key = 'Authorization'});

  final FutureOr<String?> Function() builder;
  final String key;
}

class GraphQLPersistence {
  const GraphQLPersistence();

  FutureOr<GraphQLCache> setup() => GraphQLCache();
}
