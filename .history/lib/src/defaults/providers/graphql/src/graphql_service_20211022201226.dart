import 'package:clean_framework/src/defaults/network_service.dart';
import 'package:graphql/client.dart';

class GraphQLService extends NetworkService {
  late final GraphQLClient _client;

  GraphQLService({required String link, Map<String, String>? headers})
      : super(baseUrl: link, headers: headers) {
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
      // TODO: handle this properly.
      throw result.exception!;
    }

    final resultData = result.data;
    if (resultData == null) {
      // TODO: handle this properly.
      throw NullDataGraphQLServiceException();
    }

    return resultData;
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

class NullDataGraphQLServiceException implements Exception {
  @override
  String toString() => 'NullDataGraphQLServiceException';
}

class ExternalGraphQLServiceException implements Exception {
  final String message;
  ExternalGraphQLServiceException(this.message);

  @override
  String toString() => 'ExternalGraphQLServiceException: ' + message;
}
