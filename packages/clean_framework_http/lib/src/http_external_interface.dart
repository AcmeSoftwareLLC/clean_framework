import 'dart:async';

import 'package:clean_framework/clean_framework.dart' hide Response;
import 'package:clean_framework_http/src/http_external_interface_delegate.dart';
import 'package:clean_framework_http/src/http_options.dart';
import 'package:clean_framework_http/src/requests.dart';
import 'package:clean_framework_http/src/responses.dart';
import 'package:dio/dio.dart';

typedef HttpCancelToken = CancelToken;

class HttpExternalInterface
    extends ExternalInterface<HttpRequest, HttpSuccessResponse> {
  HttpExternalInterface({
    HttpExternalInterfaceDelegate? delegate,
  }) : super(delegate: delegate ?? _DefaultHttpExternalInterfaceDelegate());

  final Completer<Dio> _dioCompleter = Completer();

  @override
  HttpExternalInterfaceDelegate get delegate {
    return super.delegate! as HttpExternalInterfaceDelegate;
  }

  @override
  void handleRequest() {
    _dioCompleter.complete(_buildDio());

    on<HttpRequest>(
      (request, send) async {
        final dio = await _dioCompleter.future;

        final options = Options(
          headers: await delegate.buildHeaders(),
          responseType: request.responseType?.original,
          contentType: request.contentType,
        );

        final response = await dio.request<dynamic>(
          request.path,
          data: request.data,
          queryParameters: request.queryParameters,

          // ignore: invalid_use_of_internal_member
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
            stackTrace: error.stackTrace,
          );
        case DioErrorType.connectionTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
        case DioErrorType.badCertificate:
        case DioErrorType.connectionError:
          return ConnectionHttpFailureResponse(
            type: HttpErrorType.values.byName(error.type.name),
            message: error.message ?? '',
            path: error.requestOptions.path,
            error: error.error,
            stackTrace: error.stackTrace,
          );
        case DioErrorType.cancel:
          return CancelledHttpFailureResponse(
            message: error.message ?? '',
            path: error.requestOptions.path,
          );
        case DioErrorType.unknown:
          break;
      }
    }

    return UnknownFailureResponse(error);
  }

  Future<Dio> _buildDio() async {
    final options = await delegate.buildOptions();

    final baseOptions = BaseOptions(
      baseUrl: options.baseUrl,
      connectTimeout: options.connectTimeout,
      receiveTimeout: options.receiveTimeout,
      sendTimeout: options.sendTimeout,
      validateStatus: options.validateStatus,
      responseType: options.responseType.original,
    );

    return delegate.buildDio(baseOptions);
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

  const HttpResponseType(this.original);

  final ResponseType original;
}

class _DefaultHttpExternalInterfaceDelegate
    extends HttpExternalInterfaceDelegate {
  @override
  Map<String, String>? buildHeaders() => null;

  @override
  HttpOptions buildOptions() => const HttpOptions();
}
