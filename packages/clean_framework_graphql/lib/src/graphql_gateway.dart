import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/src/app_providers_container.dart';

import 'graphql_requests.dart';
import 'graphql_responses.dart';

abstract class GraphQLGateway<O extends Output, R extends GraphQLRequest,
    S extends SuccessInput> extends Gateway<O, R, GraphQLSuccessResponse, S> {
  GraphQLGateway({
    ProvidersContext? context,
    UseCaseProvider? provider,
    UseCase? useCase,
  }) : super(context: context, provider: provider, useCase: useCase);

  @override
  FailureInput onFailure(GraphQLFailureResponse failureResponse) {
    return FailureInput(message: failureResponse.message);
  }
}
