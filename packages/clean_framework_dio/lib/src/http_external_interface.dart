import 'package:clean_framework/clean_framework.dart' hide Response;
import 'package:clean_framework_http/src/requests.dart';
import 'package:clean_framework_http/src/responses.dart';
import 'package:dio/dio.dart';

final httpDependencyProvider = DependencyProvider((ref) => Dio());

class HttpExternalInterface
    extends ExternalInterface<HttpRequest, HttpSuccessResponse> {
  @override
  void handleRequest() {
    final dio = locate(httpDependencyProvider)..options = BaseOptions(
      baseUrl:
    );

    on<HttpRequest>(
      (request, send) async {
        final options = Options();

        final response = await dio.request<Object>(
          request.path,
          data: request.data,
          queryParameters: request.queryParameters,
          options: DioMixin.checkOptions(request.method.name, options),
        );

        final responseType = response.requestOptions.responseType;

        final data = response.data;
        final statusCode = response.statusCode;

        if (data == null) throw Exception('Data is null');

        switch (responseType) {
          case ResponseType.json:
          case ResponseType.stream:
            if (data is List) {
              send(JsonArrayHttpSuccessResponse(data, statusCode));
            } else if (data is Map) {
              send(JsonHttpSuccessResponse(Map.from(data), statusCode));
            } else {
              throw Exception('Invalid data type: ${data.runtimeType}');
            }
            break;
          case ResponseType.plain:
            send(PlainHttpSuccessResponse(data.toString(), statusCode));
            break;
          case ResponseType.bytes:
            final bytes = List<int>.from(data as List);
            send(BytesHttpSuccessResponse(bytes, statusCode));
            break;
        }
      },
    );
  }

  @override
  FailureResponse onError(Object error) {
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.connectionTimeout:
          // TODO: Handle this case.
          break;
        case DioErrorType.sendTimeout:
          // TODO: Handle this case.
          break;
        case DioErrorType.receiveTimeout:
          // TODO: Handle this case.
          break;
        case DioErrorType.badCertificate:
          // TODO: Handle this case.
          break;
        case DioErrorType.badResponse:
          // TODO: Handle this case.
          break;
        case DioErrorType.cancel:
          // TODO: Handle this case.
          break;
        case DioErrorType.connectionError:
          // TODO: Handle this case.
          break;
        case DioErrorType.unknown:
          // TODO: Handle this case.
          break;
      }
    }

    return UnknownFailureResponse(error);
  }
}
