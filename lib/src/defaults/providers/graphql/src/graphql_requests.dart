import 'package:clean_framework/src/providers/gateway.dart';

abstract class GraphQLRequest extends Request {
  String get document;
  Map<String, dynamic>? get variables => null;
}

abstract class QueryGraphQLRequest extends GraphQLRequest {}

abstract class MutationGraphQLRequest extends GraphQLRequest {}
