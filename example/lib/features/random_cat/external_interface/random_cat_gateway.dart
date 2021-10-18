import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework_example/features/random_cat/domain/random_cat_use_case.dart';
import 'package:clean_framework_example/providers.dart';

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
    return RandomCatSuccessInput.fromJson(response.data);
  }
}

class RandomCatRequest extends GetRestRequest {
  @override
  String get path => '/catapi/rest/';

  @override
  List<Object?> get props => [];
}
