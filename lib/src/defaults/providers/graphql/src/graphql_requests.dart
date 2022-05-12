import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/src/providers/gateway.dart';

abstract class GraphQLRequest extends Request {
  String get document;

  Map<String, dynamic>? get variables => null;

  Duration? get timeout => null;

  GraphQLFetchPolicy? get fetchPolicy => null;
}

abstract class QueryGraphQLRequest extends GraphQLRequest {}

abstract class MutationGraphQLRequest extends GraphQLRequest {}
