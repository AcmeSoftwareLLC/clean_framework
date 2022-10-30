import 'package:clean_framework/src/providers/gateway.dart';

import 'graphql_error_policy.dart';
import 'graphql_fetch_policy.dart';

abstract class GraphQLRequest extends Request {
  String get document;

  Map<String, dynamic>? get variables => null;

  Duration? get timeout => null;

  GraphQLFetchPolicy? get fetchPolicy => null;

  GraphQLErrorPolicy? get errorPolicy => null;
}

abstract class QueryGraphQLRequest extends GraphQLRequest {}

abstract class MutationGraphQLRequest extends GraphQLRequest {}
