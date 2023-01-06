import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';

final context = ProvidersContext();

void main() {
  test('Gateway unit test for success on direct output', () async {
    final useCase = UseCaseFake();
    final provider = UseCaseProvider((_) => useCase);
    TestDirectGateway(provider).transport = (request) async {
      return const Either.right(TestResponse('success'));
    };

    await useCase.doFakeRequest(TestDirectOutput('123'));

    expect(useCase.entity, EntityFake(value: 'success'));
  });

  test('Gateway unit test for failure on direct output', () async {
    final useCase = UseCaseFake();
    final provider = UseCaseProvider((_) => useCase);
    TestDirectGateway(provider).transport = (request) async {
      return Either.left(UnknownFailureResponse());
    };

    await useCase.doFakeRequest(TestDirectOutput('123'));

    expect(useCase.entity, EntityFake(value: 'failure'));
  });

  test('Gateway unit test for success on yield output', () async {
    final useCase = UseCaseFake();
    final provider = UseCaseProvider((_) => useCase);
    final gateway = TestYieldGateway(provider)
      ..transport = (request) async {
        return const Either.right(TestResponse('success'));
      };

    await useCase.doFakeRequest(TestSubscriptionOutput('123'));

    expect(useCase.entity, EntityFake(value: 'success'));

    gateway.yieldResponse(const TestResponse('with yield'));

    expect(useCase.entity, EntityFake(value: 'success with input'));
  });

  test('Gateway unit test for failure on yield output', () async {
    final useCase = UseCaseFake();
    final provider = UseCaseProvider((_) => useCase);
    TestYieldGateway(provider).transport = (request) async {
      return Either.left(UnknownFailureResponse());
    };

    await useCase.doFakeRequest(TestSubscriptionOutput('123'));

    expect(useCase.entity, EntityFake(value: 'failure'));
  });

  test('props', () {
    const response = SuccessResponse();
    expect(response, const SuccessResponse());
    // If we log the responses and compare the output, that could replace this
    expect(response.stringify, isTrue);
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
  const TestRequest(this.id);
  final String id;
}

class TestResponse extends SuccessResponse {
  const TestResponse(this.foo);
  final String foo;

  @override
  List<Object?> get props => [foo];
}

class TestSuccessInput extends SuccessInput {
  TestSuccessInput(this.foo);
  final String foo;
}

class TestDirectOutput extends Output {
  TestDirectOutput(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class TestSubscriptionOutput extends Output {
  TestSubscriptionOutput(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}
