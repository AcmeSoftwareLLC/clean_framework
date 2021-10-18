import 'package:clean_framework/src/providers/gateway.dart';

class RestSuccessResponse extends SuccessResponse {
  final Map<String, dynamic> data;

  RestSuccessResponse({required this.data});
}
