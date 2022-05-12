import 'dart:async';

import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/src/defaults/network_service.dart';
import 'package:clean_framework/src/defaults/providers/graphql/graphql_logger.dart';
import 'package:graphql/client.dart';

class GraphQLService extends NetworkService {
  GraphQLService({
    required String endpoint,
    GraphQLToken? token,
    Map<String, String> headers = const {},
    GraphQLCache? cache,
    DefaultPolicies? defaultPolicies,
    this.timeout,
  }) : super(baseUrl: endpoint, headers: headers) {
    final link = _createLink(token: token);

    _client = GraphQLClient(
      link: link,
      defaultPolicies: defaultPolicies,
      cache: cache ?? GraphQLCache(),
    );
  }

  late final GraphQLClient _client;
  final Duration? timeout;

  GraphQLService.withClient({
    required GraphQLClient client,
    this.timeout,
  })  : _client = client,
        super(baseUrl: '', headers: const {});

  Future<Map<String, dynamic>> request({
    required GraphQLMethod method,
    required String document,
    Map<String, dynamic>? variables,
    Duration? timeout,
    FetchPolicy? fetchPolicy,
  }) async {
    final _timeout = timeout ?? this.timeout;

    try {
      switch (method) {
        case GraphQLMethod.query:
          return _handleExceptions(
            await _query(document, variables, _timeout, fetchPolicy),
          );
        case GraphQLMethod.mutation:
          return _handleExceptions(
            await _mutate(document, variables, _timeout, fetchPolicy),
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
          return {
            if (token != null) token.key: await token.builder() ?? '',
            ..._headers,
          };
        },
      );

      _link = loggerLink.concat(_link);

      return true;
    }());

    return _link;
  }

  Map<String, dynamic> _handleExceptions(QueryResult result) {
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

      throw GraphQLOperationException(
        errors: operationException.graphqlErrors.map(
          (e) => GraphQLOperationError.from(e),
        ),
      );
    }

    return result.data!;
  }

  Future<QueryResult> _query(
    String doc,
    Map<String, dynamic>? variables,
    Duration? timeout,
    FetchPolicy? fetchPolicy,
  ) {
    final options = QueryOptions(
      document: gql(doc),
      variables: variables ?? {},
      fetchPolicy: fetchPolicy,
    );

    return _timedOut(_client.query(options), timeout);
  }

  Future<QueryResult> _mutate(
    String doc,
    Map<String, dynamic>? variables,
    Duration? timeout,
    FetchPolicy? fetchPolicy,
  ) {
    final options = MutationOptions(
      document: gql(doc),
      variables: variables ?? {},
      fetchPolicy: fetchPolicy,
    );

    return _timedOut(_client.mutate(options), timeout);
  }

  Future<QueryResult> _timedOut<T>(
    Future<QueryResult> request,
    Duration? timeout,
  ) async {
    if (timeout == null) return request;

    return request.timeout(timeout);
  }
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
