import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework/src/app_providers_container.dart';
import 'package:flutter_test/flutter_test.dart';

final context = ProvidersContext();
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

class TestGateway extends FirebaseGateway<TestOutput, FirebaseReadIdRequest, TestSuccessInput> {
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

class TestSuccessInput extends SuccessInput {
  final String foo;

  TestSuccessInput(this.foo);

  @override
  List<Object?> get props => [foo];
}
