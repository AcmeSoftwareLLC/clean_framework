import 'package:clean_framework/src/defaults/providers/graphql/src/graphql_service.dart';
import 'package:clean_framework/src/providers/gateway.dart';

class GraphQLSuccessResponse extends SuccessResponse {
  GraphQLSuccessResponse({
    required this.data,
    this.errors = const [],
  });

  final Map<String, dynamic> data;
  final Iterable<GraphQLOperationError> errors;
}

class GraphQLFailureResponse extends TypedFailureResponse<GraphQLFailureType> {
  GraphQLFailureResponse({
    required GraphQLFailureType type,
    String message = '',
    Map<String, Object?> errorData = const {},
  }) : super(type: type, message: message, errorData: errorData);
}

enum GraphQLFailureType { operation, network, server, timeout }
