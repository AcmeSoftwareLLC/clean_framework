import 'dart:typed_data';

import 'package:clean_framework/clean_framework_providers.dart';

class RestSuccessResponse<T extends Object> extends SuccessResponse {
  const RestSuccessResponse({required this.data});
  final T data;
}

class BytesRestSuccessResponse extends RestSuccessResponse<Uint8List> {
  const BytesRestSuccessResponse({required super.data});
}

class JsonRestSuccessResponse
    extends RestSuccessResponse<Map<String, dynamic>> {
  const JsonRestSuccessResponse({required super.data});
}
