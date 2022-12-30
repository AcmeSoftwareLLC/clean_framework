import 'package:clean_framework/clean_framework_providers.dart';
import 'package:example/features/random_cat/domain/random_cat_use_case.dart';
import 'package:example/providers.dart';
import 'package:clean_framework_rest/clean_framework_rest.dart';

class RandomCatGateway extends RestGateway<RandomCatGatewayOutput,
    RandomCatRequest, RandomCatSuccessInput> {
  RandomCatGateway()
      : super(
          context: providersContext,
          provider: randomCatUseCaseProvider,
        );

  @override
  RandomCatRequest buildRequest(RandomCatGatewayOutput output) {
    return RandomCatRequest();
  }

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: 'test');
  }

  @override
  RandomCatSuccessInput onSuccess(RestSuccessResponse response) {
    return RandomCatSuccessInput.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}

class RandomCatRequest extends GetRestRequest {
  @override
  String get path => 'catapi/rest/';
}
