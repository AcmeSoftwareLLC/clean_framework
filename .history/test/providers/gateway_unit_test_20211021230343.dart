import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/src/app_providers_container.dart';
import 'package:clean_framework/src/providers/gateway.dart';
import 'package:clean_framework/src/tests/use_case_fake.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';

final context = ProvidersContext();

void main() {
  test('Gateway unit test for success on direct output', () async {
    final useCase = UseCaseFake();
    final provider = UseCaseProvider((_) => useCase);
    var gateway = TestDirectGateway(provider);

    gateway.transport = (request) async => Right(TestResponse('success'));

    await useCase.doFakeRequest(TestDirectOutput('123'));

    expect(useCase.entity, EntityFake(value: 'success'));
  });

  test('Gateway unit test for failure on direct output', () async {
    final useCase = UseCaseFake();
    final provider = UseCaseProvider((_) => useCase);
    var gateway = TestDirectGateway(provider);

    gateway.transport = (request) async => Left(FailureResponse());

    await useCase.doFakeRequest(TestDirectOutput('123'));

    expect(useCase.entity, EntityFake(value: 'failure'));
  });

  test('Gateway unit test for success on yield output', () async {
    final useCase = UseCaseFake();
    final provider = UseCaseProvider((_) => useCase);
    var gateway = TestYieldGateway(provider);

    gateway.transport = (request) async => Right(TestResponse('success'));

    await useCase.doFakeRequest(TestSubscriptionOutput('123'));

    expect(useCase.entity, EntityFake(value: 'success'));

    gateway.yieldResponse(TestResponse('with yield'));

    expect(useCase.entity, EntityFake(value: 'success with input'));
  });

  test('Gateway unit test for failure on yield output', () async {
    final useCase = UseCaseFake();
    final provider = UseCaseProvider((_) => useCase);
    var gateway = TestYieldGateway(provider);

    gateway.transport = (request) async => Left(FailureResponse());

    await useCase.doFakeRequest(TestSubscriptionOutput('123'));

    expect(useCase.entity, EntityFake(value: 'failure'));
  });

  test('props', () {
    final response = SuccessResponse();
    expect(response, SuccessResponse());
    // If we log the responses and compare the output, that could replace this
    expect(response.stringify, isTrue);

    final request = TestRequest('123');
    expect(request.stringify, isTrue);
  });
}

class TestDirectGateway extends Gateway<TestDirectOutput, TestRequest,
    TestResponse, TestSuccessInput> {
  TestDirectGateway(UseCaseProvider provider)
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

class TestYieldGateway extends WatcherGateway<TestSubscriptionOutput,
    TestRequest, TestResponse, TestSuccessInput> {
  TestYieldGateway(UseCaseProvider provider)
      : super(provider: provider, context: context);

  @override
  TestRequest buildRequest(TestSubscriptionOutput output) =>
      TestRequest(output.id);

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: 'backend error');
  }

  @override
  TestSuccessInput onSuccess(TestResponse response) {
    return TestSuccessInput(response.foo);
  }
}

class TestRequest extends Request {
  final String id;

  TestRequest(this.id);

  @override
  List<Object?> get props => [id];
}

class TestResponse extends SuccessResponse {
  final String foo;

  TestResponse(this.foo);

  @override
  List<Object?> get props => [foo];
}

class TestSuccessInput extends SuccessInput {
  final String foo;

  TestSuccessInput(this.foo);
}

class TestDirectOutput extends Output {
  final String id;

  TestDirectOutput(this.id);

  @override
  List<Object?> get props => [id];
}

class TestSubscriptionOutput extends Output {
  final String id;

  TestSubscriptionOutput(this.id);

  @override
  List<Object?> get props => [id];
}
