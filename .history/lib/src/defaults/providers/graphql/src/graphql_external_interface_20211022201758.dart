import 'package:clean_framework/src/defaults/network_service.dart';
import 'package:clean_framework/src/defaults/providers/graphql/src/graphql_requests.dart';
import 'package:clean_framework/src/defaults/providers/graphql/src/graphql_responses.dart';
import 'package:clean_framework/src/defaults/providers/graphql/src/graphql_service.dart';
import 'package:clean_framework/src/providers/external_interface.dart';
import 'package:clean_framework/src/providers/gateway.dart';
import 'package:either_dart/either.dart';

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
        Map<String, dynamic> data;
        try {
          data = await _graphQLService.request(
            method: GraphQLMethod.query,
            document: request.document,
            variables: request.variables,
          );
          send(Right(GraphQLSuccessResponse(data: data)));
        } catch (e) {
          // log the details on the exception here
          send(Left(FailureResponse()));
        }
      },
    );
    on<MutationGraphQLRequest>(
      (request, send) async {
        Map<String, dynamic> data;
        try {
          final data = await _graphQLService.request(
            method: GraphQLMethod.mutation,
            document: request.document,
            variables: request.variables,
          );

          send(Right(GraphQLSuccessResponse(data: data)));
        } catch (e) {
          // log the details on the exception here
          send(Left(FailureResponse()));
        }
      },
    );
  }
}
