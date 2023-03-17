import 'package:clean_framework/clean_framework.dart' hide Response;
import 'package:clean_framework_http/src/http_header_delegate.dart';
import 'package:clean_framework_http/src/http_options.dart';
import 'package:clean_framework_http/src/requests.dart';
import 'package:clean_framework_http/src/responses.dart';
import 'package:dio/dio.dart';

final httpDependencyProvider = DependencyProvider((ref) => Dio());

class HttpExternalInterface
    extends ExternalInterface<HttpRequest, HttpSuccessResponse> {
  HttpExternalInterface({
    HttpOptions options = const HttpOptions(),
    this.headerDelegate,
  }) : _httpOptions = options;

  final HttpOptions _httpOptions;
  final HttpHeaderDelegate? headerDelegate;

  @override
  void handleRequest() {
    final dio = locate(httpDependencyProvider)
      ..options = BaseOptions(baseUrl: _httpOptions.baseUrl);

    on<HttpRequest>(
      (request, send) async {
        final options = Options(
          headers: await headerDelegate?.build(),
        );

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
        case DioErrorType.badResponse:
          return HttpFailureResponse(
            message: error.message ?? '',
            path: error.requestOptions.path,
            statusCode: error.response?.statusCode ?? 0,
            error: error.response?.data,
          );
        case DioErrorType.connectionTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
        case DioErrorType.badCertificate:
        case DioErrorType.cancel:
        case DioErrorType.connectionError:
          return UnknownFailureResponse(error.error);
        case DioErrorType.unknown:
          break;
      }
    }

    return UnknownFailureResponse(error);
  }
}
