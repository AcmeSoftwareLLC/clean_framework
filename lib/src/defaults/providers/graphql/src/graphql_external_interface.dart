import 'package:clean_framework/src/defaults/network_service.dart';
import 'package:clean_framework/src/defaults/providers/graphql/src/graphql_requests.dart';
import 'package:clean_framework/src/defaults/providers/graphql/src/graphql_responses.dart';
import 'package:clean_framework/src/defaults/providers/graphql/src/graphql_service.dart';
import 'package:clean_framework/src/providers/external_interface.dart';
import 'package:clean_framework/src/providers/gateway.dart';

class GraphQLExternalInterface
    extends ExternalInterface<GraphQLRequest, GraphQLSuccessResponse> {
  final GraphQLService _graphQLService;

  GraphQLExternalInterface({
    required String link,
    required List<GatewayConnection<Gateway>> gatewayConnections,
    GraphQLService? graphQLService,
  })  : _graphQLService = graphQLService ?? GraphQLService(link: link),
        super(gatewayConnections);

  @override
  void handleRequest() {
    on<QueryGraphQLRequest>(
      (request, send) async {
        final data = await _graphQLService.request(
          method: GraphQLMethod.query,
          document: request.document,
          variables: request.variables,
        );

        send(GraphQLSuccessResponse(data: data));
      },
    );
    on<MutationGraphQLRequest>(
      (request, send) async {
        final data = await _graphQLService.request(
          method: GraphQLMethod.mutation,
          document: request.document,
          variables: request.variables,
        );

        send(GraphQLSuccessResponse(data: data));
      },
    );
  }

  @override
  FailureResponse onError(Object error) {
    if (error is GraphQLOperationException) {
      return FailureResponse(/*Operational Error Type*/);
    } else if (error is GraphQLNetworkException) {
      return FailureResponse(/*Network Error Type*/);
    } else if (error is GraphQLServerException) {
      return FailureResponse(/*Server Error Type*/);
    }
    return FailureResponse();
  }
}
