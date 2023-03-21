import 'package:clean_framework/clean_framework.dart' hide Response;
import 'package:clean_framework_http/src/http_header_delegate.dart';
import 'package:clean_framework_http/src/http_options.dart';
import 'package:clean_framework_http/src/requests.dart';
import 'package:clean_framework_http/src/responses.dart';
import 'package:dio/dio.dart';

typedef HttpCancelToken = CancelToken;

class HttpExternalInterface
    extends ExternalInterface<HttpRequest, HttpSuccessResponse> {
  HttpExternalInterface({
    HttpOptions options = const HttpOptions(),
    this.headerDelegate,
    Dio? dio,
  })  : _httpOptions = options,
        _dio = dio ?? Dio();

  final HttpOptions _httpOptions;
  final HttpHeaderDelegate? headerDelegate;
  final Dio _dio;

  @override
  void handleRequest() {
    headerDelegate?.attachTo(this);
    _dio.options = BaseOptions(
      baseUrl: _httpOptions.baseUrl,
      connectTimeout: _httpOptions.connectTimeout,
      receiveTimeout: _httpOptions.receiveTimeout,
      sendTimeout: _httpOptions.sendTimeout,
      validateStatus: _httpOptions.validateStatus,
      responseType: _httpOptions.responseType._original,
    );

    on<HttpRequest>(
      (request, send) async {
        final options = Options(
          headers: await headerDelegate?.build(),
          responseType: request.responseType?._original,
          contentType: request.contentType,
        );

        final response = await _dio.request<Object>(
          request.path,
          data: request.data,
          queryParameters: request.queryParameters,
          options: DioMixin.checkOptions(request.method.name, options),
        );

        final responseType = response.requestOptions.responseType;

        final data = response.data;
        final statusCode = response.statusCode;

        if (data == null) {
          send(PlainHttpSuccessResponse('', statusCode));
          return;
        }

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
        case DioErrorType.connectionError:
          return UnknownFailureResponse(error.error);
        case DioErrorType.cancel:
          return CancelledFailureResponse(
            message: error.message ?? '',
            path: error.requestOptions.path,
          );
        case DioErrorType.unknown:
          break;
      }
    }

    return UnknownFailureResponse(error);
  }
}

/// The transformation to be applied to the response data.
enum HttpResponseType {
  /// Transform the response data to JSON object only when the
  /// content-type of response is "application/json" .
  json(ResponseType.json),

  /// Transform the response data to a String encoded with UTF8.
  plain(ResponseType.plain),

  /// Get the response stream without any transformation. The
  /// Response data will be a [ResponseBody] instance.
  stream(ResponseType.stream),

  /// Get original bytes, the type of [Response.data] will be List<int>.
  bytes(ResponseType.bytes);

  const HttpResponseType(this._original);

  final ResponseType _original;
}