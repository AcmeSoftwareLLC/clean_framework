import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework_graphql/src/graphql_service.dart';

class GraphQLSuccessResponse extends SuccessResponse {
  const GraphQLSuccessResponse({
    required this.data,
    this.errors = const [],
  });

  final Map<String, dynamic> data;
  final Iterable<GraphQLOperationError> errors;
}

class GraphQLFailureResponse extends TypedFailureResponse<GraphQLFailureType> {
  const GraphQLFailureResponse({
    required super.type,
    super.message,
    super.errorData,
  });
}

enum GraphQLFailureType { operation, network, server, timeout }
