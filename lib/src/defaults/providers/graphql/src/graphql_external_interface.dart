import 'package:clean_framework/src/defaults/network_service.dart';
import 'package:clean_framework/src/defaults/providers/graphql/src/graphql_requests.dart';
import 'package:clean_framework/src/defaults/providers/graphql/src/graphql_responses.dart';
import 'package:clean_framework/src/defaults/providers/graphql/src/graphql_service.dart';
import 'package:clean_framework/src/providers/external_interface.dart';
import 'package:clean_framework/src/providers/gateway.dart';

class GraphQLExternalInterface
    extends ExternalInterface<GraphQLRequest, GraphQLSuccessResponse> {
  GraphQLExternalInterface({
    required String link,
    required List<GatewayConnection<Gateway>> gatewayConnections,
    GraphQLToken? token,
    GraphQLPersistence persistence = const GraphQLPersistence(),
    Map<String, String> headers = const {},
    Duration? timeout,
  })  : service = GraphQLService(
          endpoint: link,
          token: token,
          persistence: persistence,
          headers: headers,
          timeout: timeout,
        ),
        super(gatewayConnections);

  final GraphQLService service;

  GraphQLExternalInterface.withService({
    required List<GatewayConnection<Gateway>> gatewayConnections,
    required this.service,
  }) : super(gatewayConnections);

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
      return GraphQLFailureResponse(type: GraphQLFailureType.operation);
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
      return GraphQLFailureResponse(
        type: GraphQLFailureType.timeout,
        message: 'Connection Timeout',
      );
    }

    print('Stitching: $error');

    return UnknownFailureResponse(error);
  }
}
