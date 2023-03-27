import 'package:clean_framework/clean_framework.dart';

typedef Json = Map<String, dynamic>;

abstract class HttpSuccessResponse<T extends Object> extends SuccessResponse {
  const HttpSuccessResponse(this.data, this.statusCode);

  final T data;
  final int? statusCode;
}

class PlainHttpSuccessResponse extends HttpSuccessResponse<String> {
  const PlainHttpSuccessResponse(super.data, super.statusCode);
}

class JsonHttpSuccessResponse extends HttpSuccessResponse<Json> {
  const JsonHttpSuccessResponse(super.data, super.statusCode);
}

class JsonArrayHttpSuccessResponse extends HttpSuccessResponse<List<dynamic>> {
  const JsonArrayHttpSuccessResponse(super.data, super.statusCode);
}

class BytesHttpSuccessResponse extends HttpSuccessResponse<List<int>> {
  const BytesHttpSuccessResponse(super.data, super.statusCode);
}

class HttpFailureResponse extends FailureResponse {
  const HttpFailureResponse({
    required this.path,
    required this.statusCode,
    required super.message,
    required this.error,
    required this.stackTrace,
  });

  final String path;
  final int statusCode;
  final Object? error;
  final StackTrace? stackTrace;
}

class CancelledHttpFailureResponse extends FailureResponse {
  const CancelledHttpFailureResponse({
    required super.message,
    required this.path,
  });

  final String path;
}

class ConnectionHttpFailureResponse
    extends TypedFailureResponse<HttpErrorType> {
  const ConnectionHttpFailureResponse({
    required super.type,
    required super.message,
    required this.path,
    required this.error,
    required this.stackTrace,
  });

  final String path;
  final Object? error;
  final StackTrace? stackTrace;
}

enum HttpErrorType {
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  badCertificate,
  connectionError,
}
