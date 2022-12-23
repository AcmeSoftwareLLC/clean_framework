import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/src/app_providers_container.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';

final context = ProvidersContext();

void main() {
  test('Gateway transport direct request with success', () async {
    final provider = UseCaseProvider<TestEntity, TestUseCase>(
      (_) => TestUseCase(TestEntity(foo: 'bar')),
    );
    TestDirectGateway(provider).transport = (request) async {
      return const Right<FailureResponse, TestResponse>(
        TestResponse('success'),
      );
    };

    final useCase = provider.getUseCaseFromContext(context);

    await useCase.fetchDataImmediately();

    final output = useCase.getOutput<TestOutput>();
    expect(output, TestOutput('success'));
  });

  test('Gateway transport direct request with failure', () async {
    final provider = UseCaseProvider<TestEntity, TestUseCase>(
      (_) => TestUseCase(TestEntity(foo: 'bar')),
    );
    TestDirectGateway(provider).transport = (request) async {
      return Left<FailureResponse, TestResponse>(UnknownFailureResponse());
    };

    final useCase = provider.getUseCaseFromContext(context);

    await useCase.fetchDataImmediately();

    final output = useCase.getOutput<TestOutput>();
    expect(output, TestOutput('failure'));
  });

  test('Gateway transport delayed request with a yielded success', () async {
    final provider = UseCaseProvider<TestEntity, TestUseCase>(
      (_) => TestUseCase(TestEntity(foo: 'bar')),
    );
    final gateway = TestYieldGateway(provider)
      ..transport = (request) async {
        return const Right<FailureResponse, TestResponse>(
          TestResponse('success'),
        );
      };

    final useCase = provider.getUseCaseFromContext(context);

    await useCase.fetchDataEventually();

    final output = useCase.getOutput<TestOutput>();
    expect(output, TestOutput('bar'));

    gateway.yieldResponse(const TestResponse('with yield'));

    final output2 = useCase.getOutput<TestOutput>();
    expect(output2, TestOutput('with yield'));
  });

  test('BridgeGateway transfer of data', () async {
    final useCase1 = TestUseCase(TestEntity(foo: 'bar'));
    final useCase2 = TestUseCase(TestEntity(foo: 'to be replaced'));

    TestBridgeGateway(subscriberUseCase: useCase2, publisherUseCase: useCase1);

    await useCase2.fetchStateFromOtherUseCase();
    final output = useCase2.getOutput<TestOutput>();

    expect(output, TestOutput('bar'));
  });
}

class TestBridgeGateway
    extends BridgeGateway<TestDirectOutput, TestOutput, TestSuccessInput> {
  TestBridgeGateway({
    required super.subscriberUseCase,
    required super.publisherUseCase,
  });
  @override
  TestSuccessInput onResponse(TestOutput output) =>
      TestSuccessInput(output.foo);
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

class TestUseCase extends UseCase<TestEntity> {
  TestUseCase(TestEntity entity)
      : super(
          entity: entity,
          transformers: [
            OutputTransformer.from((entity) => TestOutput(entity.foo)),
            InputTransformer<TestEntity, TestSuccessInput>.from(
              (entity, input) => entity.merge(foo: input.foo),
            ),
          ],
        );

  Future<void> fetchDataImmediately() async {
    await request<TestDirectOutput, TestSuccessInput>(
      TestDirectOutput('123'),
      onFailure: (_) => entity.merge(foo: 'failure'),
      onSuccess: (success) => entity.merge(foo: success.foo),
    );
  }

  Future<void> fetchDataEventually() async {
    await request<TestSubscriptionOutput, SuccessInput>(
      TestSubscriptionOutput('123'),
      onFailure: (_) => entity.merge(foo: 'failure'),
      onSuccess: (_) => entity, // no changes on the entity are needed,
      // the changes should happen on the inputFilter.
    );
  }

  Future<void> fetchStateFromOtherUseCase() async {
    await request<TestDirectOutput, TestSuccessInput>(
      TestDirectOutput(''),
      onFailure: (_) => entity,
      onSuccess: (input) {
        return entity.merge(foo: input.foo);
      },
    );
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

class TestEntity extends Entity {
  TestEntity({required this.foo});
  final String foo;

  @override
  List<Object?> get props => [foo];

  TestEntity merge({String? foo}) => TestEntity(foo: foo ?? this.foo);
}

class TestOutput extends Output {
  TestOutput(this.foo);
  final String foo;

  @override
  List<Object?> get props => [foo];
}
