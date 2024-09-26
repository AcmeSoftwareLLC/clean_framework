import 'dart:async';

import 'package:clean_framework/clean_framework.dart' hide Response;
import 'package:clean_framework_http/src/http_external_interface_delegate.dart';
import 'package:clean_framework_http/src/http_options.dart';
import 'package:clean_framework_http/src/requests.dart';
import 'package:clean_framework_http/src/responses.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

typedef HttpCancelToken = CancelToken;

class HttpExternalInterface
    extends ExternalInterface<HttpRequest, HttpSuccessResponse> {
  HttpExternalInterface({
    HttpExternalInterfaceDelegate? delegate,
  }) : super(delegate: delegate ?? _DefaultHttpExternalInterfaceDelegate());

  final Completer<(Dio, HttpCacheOptions?)> _dioCompleter = Completer();

  @override
  HttpExternalInterfaceDelegate get delegate {
    return super.delegate! as HttpExternalInterfaceDelegate;
  }

  @override
  void handleRequest() {
    _dioCompleter.complete(_buildDio());

    on<HttpRequest>(
      (request, send) async {
        final (dio, cacheOptions) = await _dioCompleter.future;

        final rootHeaders = await delegate.buildHeaders();
        final headers = {
          ...request.headers,
          if (rootHeaders != null) ...rootHeaders,
        };

        var options = Options(
          headers: headers,
          method: request.method.name,
          responseType: request.responseType?.original,
          contentType: request.contentType,
        );

        if (cacheOptions != null) {
          options = cacheOptions
              .copyWith(
                policy: request.cachePolicy?.value,
                maxStale: Nullable(request.maxStale ?? cacheOptions.maxStale),
              )
              .toOptions();
        }

        final response = await dio.request<dynamic>(
          request.path,
          data: request.data,
          queryParameters: request.queryParameters,
          options: options,
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
          case ResponseType.plain:
            send(PlainHttpSuccessResponse(data.toString(), statusCode));
          case ResponseType.bytes:
            final bytes = List<int>.from(data as List);
            send(BytesHttpSuccessResponse(bytes, statusCode));
        }
      },
    );
  }

  @override
  FailureResponse onError(Object error) {
    if (error is DioException) {
      return switch (error.type) {
        DioExceptionType.badResponse => HttpFailureResponse(
            message: error.message ?? '',
            path: error.requestOptions.path,
            statusCode: error.response?.statusCode ?? 0,
            error: error.response?.data,
            stackTrace: error.stackTrace,
          ),
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.badCertificate ||
        DioExceptionType.connectionError =>
          ConnectionHttpFailureResponse(
            type: HttpErrorType.values.byName(error.type.name),
            message: error.message ?? '',
            path: error.requestOptions.path,
            error: error.error,
            stackTrace: error.stackTrace,
          ),
        DioExceptionType.cancel => CancelledHttpFailureResponse(
            message: error.message ?? '',
            path: error.requestOptions.path,
          ),
        _ => UnknownFailureResponse(error),
      };
    }

    return UnknownFailureResponse(error);
  }

  Future<(Dio, HttpCacheOptions?)> _buildDio() async {
    final options = await delegate.buildOptions();

    final baseOptions = BaseOptions(
      baseUrl: options.baseUrl,
      connectTimeout: options.connectTimeout,
      receiveTimeout: options.receiveTimeout,
      sendTimeout: options.sendTimeout,
      validateStatus: options.validateStatus,
      responseType: options.responseType.original,
    );

    final dio = await delegate.buildDio(baseOptions);
    final cacheOptions = await delegate.buildCacheOptions();

    if (cacheOptions != null) {
      dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    }

    return (dio, cacheOptions);
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
