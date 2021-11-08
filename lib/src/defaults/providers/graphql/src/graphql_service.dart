import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/src/defaults/network_service.dart';
import 'package:graphql/client.dart';

class GraphQLService extends NetworkService {
  late final GraphQLClient _client;

  GraphQLService(
      {required String link,
      Map<String, String>? headers,
      GraphQLClient? client})
      : super(baseUrl: link, headers: headers) {
    if (client != null) {
      _client = client;
      return;
    }

    final httpLink = HttpLink(link);
    Link _link;

    if (headers != null && headers.containsKey('Authorization')) {
      final authLink = AuthLink(getToken: () => headers['Authorization']);
      _link = authLink.concat(httpLink);
    } else {
      _link = httpLink;
    }

    _client = GraphQLClient(link: _link, cache: GraphQLCache());
  }

  Future<Map<String, dynamic>> request({
    required GraphQLMethod method,
    required String document,
    Map<String, dynamic>? variables,
  }) async {
    switch (method) {
      case GraphQLMethod.query:
        return _handleExceptions(await _query(document, variables));
      case GraphQLMethod.mutation:
        return _handleExceptions(await _mutate(document, variables));
    }
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
  ) {
    final options = QueryOptions(
      document: gql(doc),
      variables: variables ?? {},
    );
    return _client.query(options);
  }

  Future<QueryResult> _mutate(
    String doc,
    Map<String, dynamic>? variables,
  ) {
    final options = MutationOptions(
      document: gql(doc),
      variables: variables ?? {},
    );
    return _client.mutate(options);
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

class GraphQLOperationException {
  GraphQLOperationException({required this.errors});

  final Iterable<GraphQLOperationError> errors;

  GraphQLOperationError? get error => errors.isEmpty ? null : errors.first;
}

class GraphQLNetworkException {
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

class GraphQLServerException {
  GraphQLServerException({
    required this.originalException,
    required this.errorData,
  });

  final Object? originalException;
  final Map<String, dynamic>? errorData;
}
