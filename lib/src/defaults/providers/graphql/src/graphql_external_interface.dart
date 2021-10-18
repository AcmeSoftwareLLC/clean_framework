import 'package:clean_framework/src/defaults/providers/graphql/src/graphql_requests.dart';
import 'package:clean_framework/src/defaults/providers/graphql/src/graphql_responses.dart';
import 'package:clean_framework/src/defaults/providers/graphql/src/graphql_service.dart';
import 'package:clean_framework/src/providers/external_interface.dart';
import 'package:clean_framework/src/providers/gateway.dart';
import 'package:clean_framework/src/defaults/network_service.dart';
import 'package:either_dart/either.dart';

class GraphQLExternalInterface
    extends DirectExternalInterface<GraphQLRequest, GraphQLSuccessResponse> {
  final GraphQLService _graphQLService;

  GraphQLExternalInterface({
    required String link,
    required List<GatewayConnection<Gateway>> gatewayConnections,
    GraphQLService? graphQLService,
  })  : _graphQLService = graphQLService ?? GraphQLService(link: link),
        super(gatewayConnections);

  @override
  Future<Either<FailureResponse, SuccessResponse>> onTransport(
    GraphQLRequest request,
  ) async {
    final data = await _graphQLService.request(
      method: _requestToMethod(request),
      document: request.document,
      variables: request.variables,
    );

    return Right(GraphQLSuccessResponse(data: data));
  }

  GraphQLMethod _requestToMethod(GraphQLRequest request) {
    if (request is QueryGraphQLRequest) return GraphQLMethod.query;
    if (request is MutationGraphQLRequest) return GraphQLMethod.mutation;
    throw UnsupportedError('${request.runtimeType} is not supported.');
  }
}
