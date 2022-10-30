import 'dart:typed_data';

import 'package:clean_framework/src/providers/external_interface.dart';
import 'package:clean_framework/src/providers/gateway.dart';
import 'package:cross_file/cross_file.dart';

import 'rest_requests.dart';
import 'rest_responses.dart';
import 'rest_service.dart';

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
        final data = await _restService.request<Map<String, dynamic>>(
          method: request.method,
          path: request.path,
          data: request.data,
          headers: request.headers,
        );
        send(JsonRestSuccessResponse(data: data));
      },
    );
    on<MultiPartRestRequest>(
      (request, send) async {
        final data = await _restService.multipartRequest(
          method: request.method,
          path: request.path,
          data: request.data,
          headers: request.headers,
        );
        send(JsonRestSuccessResponse(data: data));
      },
    );
    on<BytesRestRequest>(
      (request, send) async {
        final data = await _restService.request<Uint8List>(
          method: request.method,
          path: request.path,
          data: request.data,
          headers: request.headers,
        );
        send(BytesRestSuccessResponse(data: data));
      },
    );
    on<BinaryDataSrcRestRequest>(
      (request, send) async {
        final binaryData = await XFile(request.src).readAsBytes();
        final data = await _restService.binaryRequest(
          method: request.method,
          path: request.path,
          data: binaryData,
          headers: request.headers,
        );
        send(JsonRestSuccessResponse(data: data));
      },
    );
    on<BinaryDataRestRequest>(
      (request, send) async {
        final data = await _restService.binaryRequest(
          method: request.method,
          path: request.path,
          data: request.binaryData,
          headers: request.headers,
        );
        send(JsonRestSuccessResponse(data: data));
      },
    );
  }

  @override
  FailureResponse onError(Object error) {
    if (error is InvalidResponseRestServiceFailure) {
      return HttpFailureResponse(
        path: error.path,
        statusCode: error.statusCode,
        error: error.error,
      );
    }
    if (error is RestServiceFailure) {
      return UnknownFailureResponse(error.message);
    }
    return UnknownFailureResponse(error.toString());
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
