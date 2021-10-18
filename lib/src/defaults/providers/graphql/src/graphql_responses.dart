import 'package:clean_framework/src/providers/gateway.dart';

class GraphQLSuccessResponse extends SuccessResponse {
  final Map<String, dynamic> data;

  GraphQLSuccessResponse({required this.data});
}
