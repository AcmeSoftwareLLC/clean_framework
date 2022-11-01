import 'package:clean_framework/clean_framework_providers.dart';

import 'package:clean_framework_graphql/src/graphql_requests.dart';
import 'package:clean_framework_graphql/src/graphql_responses.dart';

abstract class GraphQLGateway<O extends Output, R extends GraphQLRequest,
    S extends SuccessInput> extends Gateway<O, R, GraphQLSuccessResponse, S> {
  GraphQLGateway({
    super.context,
    super.provider,
    super.useCase,
  });

  @override
  FailureInput onFailure(GraphQLFailureResponse failureResponse) {
    return FailureInput(message: failureResponse.message);
  }
}
