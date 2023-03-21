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
  });

  final String path;
  final int statusCode;
  final Object? error;
}

class CancelledFailureResponse extends FailureResponse {
  const CancelledFailureResponse({required super.message, required this.path});

  final String path;
}