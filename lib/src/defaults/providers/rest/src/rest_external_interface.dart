import 'dart:io';

import 'package:clean_framework/src/defaults/providers/rest/src/rest_requests.dart';
import 'package:clean_framework/src/defaults/providers/rest/src/rest_responses.dart';
import 'package:clean_framework/src/defaults/providers/rest/src/rest_service.dart';
import 'package:clean_framework/src/providers/external_interface.dart';
import 'package:clean_framework/src/providers/gateway.dart';

class RestExternalInterface
    extends ExternalInterface<RestRequest, RestSuccessResponse> {
  final RestService _restService;

  RestExternalInterface({
    required List<GatewayConnection<Gateway>> gatewayConnections,
    required String baseUrl,
    Map<String, String> headers = const {},
    RestService? restService,
  })  : _restService = restService ??
            RestService(
              baseUrl: baseUrl,
              headers: headers,
            ),
        super(gatewayConnections);

  @override
  void handleRequest() {
    on<JsonRestRequest>(
      (request, send) async {
        final data = await _restService.request(
          method: request.method,
          path: request.path,
          data: request.data,
          headers: request.headers,
        );
        send(RestSuccessResponse(data: data));
      },
    );
    on<BinaryDataRestRequest>(
      (request, send) async {
        final binaryData = File(request.src).readAsBytesSync();
        final data = await _restService.binaryRequest(
          method: request.method,
          path: request.path,
          data: binaryData,
          headers: request.headers,
        );
        send(RestSuccessResponse(data: data));
      },
    );
  }

  @override
  FailureResponse onError(Object error) {
    if (error is InvalidResponseRestServiceFailure)
      return HttpFailureResponse(
        path: error.path,
        statusCode: error.statusCode,
        error: error.error,
      );
    if (error is RestServiceFailure)
      return UnknownFailureResponse(error.message);
    return UnknownFailureResponse();
  }
}

class HttpFailureResponse extends FailureResponse {
  final String path;
  final int statusCode;
  final Map<String, dynamic> error;

  HttpFailureResponse({
    required this.path,
    required this.error,
    required this.statusCode,
  });
}
