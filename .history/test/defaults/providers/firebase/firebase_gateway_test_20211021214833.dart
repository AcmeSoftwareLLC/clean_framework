import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework/src/app_providers_container.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  final context = ProvidersContext();
  test('FirebaseGateway transport', () async {

 final useCase = UseCaseFake();
    final provider = UseCaseProvider((_) => useCase);
    var gateway = TestGateway(context, provider);

    gateway.transport = (request) async{ return  Right(FirebaseSuccessResponse({'content': 'success'})); }

    await useCase.doFakeRequest(TestOutput('123'));

    expect(useCase.entity, EntityFake(value: 'success'));
  });
}

class TestGateway extends FirebaseGateway<TestOutput, FirebaseReadIdRequest, TestSuccessInput> {
  TestGateway(ProvidersContext context, UseCaseProvider provider)
      : super(provider: provider, context: context);

  @override
  FirebaseReadIdRequest buildRequest(TestOutput output) => FirebaseReadIdRequest(path: 'fake path', id: output.id,);

  @override
  TestSuccessInput onSuccess(FirebaseSuccessResponse response) {
    return TestSuccessInput(response.json['content']);
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
