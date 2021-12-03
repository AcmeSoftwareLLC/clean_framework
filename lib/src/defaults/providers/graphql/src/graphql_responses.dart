import 'package:clean_framework/src/providers/gateway.dart';

class GraphQLSuccessResponse extends SuccessResponse {
  final Map<String, dynamic> data;

  GraphQLSuccessResponse({required this.data});
}

class GraphQLFailureResponse extends TypedFailureResponse<GraphQLFailureType> {
  GraphQLFailureResponse({
    required GraphQLFailureType type,
    String message = '',
    Map<String, Object?> errorData = const {},
  }) : super(type: type, message: message, errorData: errorData);
}

enum GraphQLFailureType { operation, network, server }
