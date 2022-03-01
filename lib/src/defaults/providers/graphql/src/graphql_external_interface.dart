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
    GraphQLTokenBuilder? tokenBuilder,
    String? authHeaderKey,
    Map<String, String> headers = const {},
    GraphQLService? graphQLService,
    Duration? timeout,
  })  : _graphQLService = graphQLService ??
            GraphQLService(
              link: link,
              tokenBuilder: tokenBuilder,
              authHeaderKey: authHeaderKey,
              headers: headers,
              timeout: timeout,
            ),
        super(gatewayConnections);

  @override
  void handleRequest() {
    on<QueryGraphQLRequest>(
      (request, send) async {
        final data = await _graphQLService.request(
          method: GraphQLMethod.query,
          document: request.document,
          variables: request.variables,
          timeout: request.timeout,
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
          timeout: request.timeout,
        );

        send(GraphQLSuccessResponse(data: data));
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
      return GraphQLFailureResponse(type: GraphQLFailureType.timeout);
    }

    return UnknownFailureResponse(error);
  }
}
