import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_graphql/src/graphql_method.dart';
import 'package:clean_framework_graphql/src/graphql_requests.dart';
import 'package:clean_framework_graphql/src/graphql_responses.dart';
import 'package:clean_framework_graphql/src/graphql_service.dart';

class GraphQLExternalInterface
    extends ExternalInterface<GraphQLRequest, GraphQLSuccessResponse> {
  GraphQLExternalInterface({
    required String link,
    GraphQLToken? token,
    GraphQLPersistence persistence = const GraphQLPersistence(),
    Map<String, String> headers = const {},
    Duration? timeout,
  }) : service = GraphQLService(
          endpoint: link,
          token: token,
          persistence: persistence,
          headers: headers,
          timeout: timeout,
        );

  GraphQLExternalInterface.withService({
    required this.service,
  });

  final GraphQLService service;

  @override
  void handleRequest() {
    on<QueryGraphQLRequest>(
      (request, send) async {
        final response = await service.request(
          method: GraphQLMethod.query,
          document: request.document,
          variables: request.variables,
          timeout: request.timeout,
          fetchPolicy: request.fetchPolicy,
          errorPolicy: request.errorPolicy,
        );

        send(
          GraphQLSuccessResponse(data: response.data, errors: response.errors),
        );
      },
    );

    on<MutationGraphQLRequest>(
      (request, send) async {
        final response = await service.request(
          method: GraphQLMethod.mutation,
          document: request.document,
          variables: request.variables,
          timeout: request.timeout,
          fetchPolicy: request.fetchPolicy,
          errorPolicy: request.errorPolicy,
        );

        send(
          GraphQLSuccessResponse(data: response.data, errors: response.errors),
        );
      },
    );
  }

  @override
  FailureResponse onError(Object error) {
    if (error is GraphQLOperationException) {
      return const GraphQLFailureResponse(type: GraphQLFailureType.operation);
    } else if (error is GraphQLNetworkException) {
      return GraphQLFailureResponse(
        type: GraphQLFailureType.network,
        message: error.message ?? '',
        errorData: {'url': error.uri.toString()},
      );
    } else if (error is GraphQLServerException) {
      return GraphQLFailureResponse(
        type: GraphQLFailureType.server,
        message: error.originalException.toString(),
        errorData: error.errorData ?? {},
      );
    } else if (error is GraphQLTimeoutException) {
      return const GraphQLFailureResponse(
        type: GraphQLFailureType.timeout,
        message: 'Connection Timeout',
      );
    }

    return UnknownFailureResponse(error);
  }
}
