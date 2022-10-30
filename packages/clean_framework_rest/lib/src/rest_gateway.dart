import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/src/app_providers_container.dart';

import 'rest_requests.dart';
import 'rest_responses.dart';

abstract class RestGateway<O extends Output, R extends RestRequest,
    S extends SuccessInput> extends Gateway<O, R, RestSuccessResponse, S> {
  RestGateway({
    ProvidersContext? context,
    UseCaseProvider? provider,
    UseCase? useCase,
  }) : super(context: context, provider: provider, useCase: useCase);

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput();
  }
}
