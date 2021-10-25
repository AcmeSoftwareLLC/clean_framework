import 'package:clean_framework/src/defaults/providers/rest/src/rest_requests.dart';
import 'package:clean_framework/src/defaults/providers/rest/src/rest_responses.dart';
import 'package:clean_framework/src/defaults/providers/rest/src/rest_service.dart';
import 'package:clean_framework/src/providers/external_interface.dart';
import 'package:clean_framework/src/providers/gateway.dart';
import 'package:either_dart/src/either.dart';

class RestExternalInterface
    extends DirectExternalInterface<RestRequest, RestSuccessResponse> {
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
  Future<Either<FailureResponse, SuccessResponse>> onTransport(
    RestRequest request,
  ) async {
    final data = await _restService.request(
      method: request.method,
      path: request.path,
      data: request.data,
    );

    return Right(RestSuccessResponse(data: data));
  }
}
