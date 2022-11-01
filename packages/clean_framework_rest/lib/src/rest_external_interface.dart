import 'dart:typed_data';

import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework_rest/src/rest_requests.dart';
import 'package:clean_framework_rest/src/rest_responses.dart';
import 'package:clean_framework_rest/src/rest_service.dart';
import 'package:cross_file/cross_file.dart';

class RestExternalInterface
    extends ExternalInterface<RestRequest, RestSuccessResponse> {
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
  final RestService _restService;

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
  const HttpFailureResponse({
    required this.path,
    required this.error,
    required this.statusCode,
  });
  final String path;
  final int statusCode;
  final Map<String, dynamic> error;
}
