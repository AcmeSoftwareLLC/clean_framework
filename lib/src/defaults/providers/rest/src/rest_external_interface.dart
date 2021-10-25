import 'package:clean_framework/src/defaults/providers/rest/src/rest_requests.dart';
import 'package:clean_framework/src/defaults/providers/rest/src/rest_responses.dart';
import 'package:clean_framework/src/defaults/providers/rest/src/rest_service.dart';
import 'package:clean_framework/src/providers/external_interface.dart';
import 'package:clean_framework/src/providers/gateway.dart';
import 'package:either_dart/either.dart';

class RestExternalInterface
    extends ExternalInterface<RestRequest, RestSuccessResponse> {
  final RestService _restService;

  RestExternalInterface({
    required List<GatewayConnection<Gateway>> gatewayConnections,
    required String baseUrl,
    Map<String, String>? headers,
    RestService? restService,
  })  : _restService = restService ??
            RestService(
              baseUrl: baseUrl,
              headers: headers,
            ),
        super(gatewayConnections);

  @override
  void handleRequest() {
    on<RestRequest>(
      (request, send) async {
        final data = await _restService.request(
          method: request.method,
          path: request.path,
          data: request.data,
        );

        send(Right(RestSuccessResponse(data: data)));
      },
    );
  }
}
