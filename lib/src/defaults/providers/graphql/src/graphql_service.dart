import 'dart:async';

import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/src/clean_framework_observer.dart';
import 'package:clean_framework/src/defaults/network_service.dart';
import 'package:clean_framework/src/defaults/providers/graphql/graphql_logger.dart';
import 'package:graphql/client.dart';

typedef GraphQLTokenBuilder = FutureOr<String?> Function();

class GraphQLService extends NetworkService {
  GraphQLService({
    required String endpoint,
    GraphQLTokenBuilder? tokenBuilder,
    String? authHeaderKey,
    Map<String, String> headers = const {},
    GraphQLClient? client,
    this.timeout,
  }) : super(baseUrl: endpoint, headers: headers) {
    if (client == null) {
      final link = _createLink(
        authHeaderKey: authHeaderKey,
        tokenBuilder: tokenBuilder,
      );

      _client = GraphQLClient(link: link, cache: GraphQLCache());
    } else {
      _client = client;
    }
  }

  late final GraphQLClient _client;
  final Duration? timeout;

  Future<Map<String, dynamic>> request({
    required GraphQLMethod method,
    required String document,
    Map<String, dynamic>? variables,
    Duration? timeout,
  }) async {
    final _timeout = timeout ?? this.timeout;

    try {
      switch (method) {
        case GraphQLMethod.query:
          return _handleExceptions(
            await _query(document, variables, _timeout),
          );
        case GraphQLMethod.mutation:
          return _handleExceptions(
            await _mutate(document, variables, _timeout),
          );
      }
    } on TimeoutException {
      throw GraphQLTimeoutException();
    }
  }

  Link _createLink({
    required String? authHeaderKey,
    required GraphQLTokenBuilder? tokenBuilder,
  }) {
    final _headers = headers ?? {};
    final httpLink = HttpLink(baseUrl, defaultHeaders: _headers);
    final headerKey = authHeaderKey ?? 'Authorization';

    Link _link;
    if (tokenBuilder == null) {
      _link = httpLink;
    } else {
      final authLink = AuthLink(
        getToken: tokenBuilder,
        headerKey: headerKey,
      );
      _link = authLink.concat(httpLink);
    }

    // Attach GraphQL Logger only in debug mode
    assert(() {
      if (CleanFrameworkObserver.instance.enableNetworkLogs) {
        final loggerLink = GraphQLLoggerLink(
          endpoint: baseUrl,
          getHeaders: () async {
            final token = await tokenBuilder?.call();
            return {
              if (token != null) headerKey: token,
              ..._headers,
            };
          },
        );

        _link = loggerLink.concat(_link);
      }

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
  ) {
    final options = QueryOptions(
      document: gql(doc),
      variables: variables ?? {},
    );

    return _timedOut(_client.query(options), timeout);
  }

  Future<QueryResult> _mutate(
    String doc,
    Map<String, dynamic>? variables,
    Duration? timeout,
  ) {
    final options = MutationOptions(
      document: gql(doc),
      variables: variables ?? {},
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
