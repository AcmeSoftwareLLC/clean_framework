import 'dart:typed_data';
import 'package:clean_framework/src/providers/gateway.dart';

class RestSuccessResponse<T> extends SuccessResponse {
  final T data;
  RestSuccessResponse({required this.data});
}

class BytesRestSuccessResponse extends RestSuccessResponse<Uint8List> {
  BytesRestSuccessResponse({required super.data});
}

class JsonRestSuccessResponse
    extends RestSuccessResponse<Map<String, dynamic>> {
  JsonRestSuccessResponse({required super.data});
}
