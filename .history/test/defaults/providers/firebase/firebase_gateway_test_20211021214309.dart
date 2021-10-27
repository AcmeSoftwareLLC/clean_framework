import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FirebaseGateway transport', () {

 final useCase = UseCaseFake();
    final provider = UseCaseProvider((_) => useCase);
    var gateway = TestDirectGateway(provider);

    gateway.transport = (request) async => Right(TestResponse('success'));

    await useCase.doFakeRequest(TestDirectOutput('123'));

    expect(useCase.entity, EntityFake(value: 'success'));
  });
}

class TestGateway extends FirebaseGateway<TestOutput, FirebaseRequest, FirebaseSuccessResponse> {
  TestGateway(UseCaseProvider provider)
      : super(provider: provider, context: context);

  @override
  TestRequest buildRequest(TestDirectOutput output) => TestRequest(output.id);

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: 'backend error');
  }

  @override
  TestSuccessInput onSuccess(TestResponse response) {
    return TestSuccessInput(response.foo);
  }
}

class TestOutput extends Output {
  final String id;

  TestOutput(this.id);

  @override
  List<Object?> get props => [id];
}
