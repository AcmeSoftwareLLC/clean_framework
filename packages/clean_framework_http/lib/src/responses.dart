import 'package:clean_framework/clean_framework.dart';

typedef Json = Map<String, dynamic>;

abstract class const HttpSuccessResponse<T extends Object>(
  final T data,
  final int? statusCode,
) extends SuccessResponse;

class const PlainHttpSuccessResponse(super.data, super.statusCode)
    extends HttpSuccessResponse<String>;

class const JsonHttpSuccessResponse(super.data, super.statusCode)
    extends HttpSuccessResponse<Json>;

class const JsonArrayHttpSuccessResponse(super.data, super.statusCode)
    extends HttpSuccessResponse<List<dynamic>>;

class const BytesHttpSuccessResponse(super.data, super.statusCode)
    extends HttpSuccessResponse<List<int>>;

class const HttpFailureResponse({
  required final String path,
  required final int statusCode,
  required super.message,
  required final Object? error,
  required final StackTrace? stackTrace,
}) extends FailureResponse;

class const CancelledHttpFailureResponse({
  required super.message,
  required final String path,
}) extends FailureResponse;

class const ConnectionHttpFailureResponse({
  required super.type,
  required super.message,
  required final String path,
  required final Object? error,
  required final StackTrace? stackTrace,
}) extends TypedFailureResponse<HttpErrorType>;

enum HttpErrorType {
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  badCertificate,
  connectionError,
}
