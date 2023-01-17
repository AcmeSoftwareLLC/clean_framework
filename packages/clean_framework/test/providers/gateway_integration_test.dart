import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:flutter_test/flutter_test.dart';

final context = ProvidersContext();

void main() {
  test('Gateway transport direct request with success', () async {
    final provider = UseCaseProvider<TestEntity, TestUseCase>(
      (_) => TestUseCase(const TestEntity(foo: 'bar')),
    );
    TestDirectGateway(provider).transport = (request) async {
      return const Either.right(TestResponse('success'));
    };

    final useCase = provider.getUseCaseFromContext(context);

    await useCase.fetchDataImmediately();

    final output = useCase.getOutput<TestOutput>();
    expect(output, const TestOutput('success'));
  });

  test('Gateway transport direct request with failure', () async {
    final provider = UseCaseProvider<TestEntity, TestUseCase>(
      (_) => TestUseCase(const TestEntity(foo: 'bar')),
    );
    TestDirectGateway(provider).transport = (request) async {
      return Either.left(UnknownFailureResponse());
    };

    final useCase = provider.getUseCaseFromContext(context);

    await useCase.fetchDataImmediately();

    final output = useCase.getOutput<TestOutput>();
    expect(output, const TestOutput('failure'));
  });

  test('Gateway transport delayed request with a yielded success', () async {
    final provider = UseCaseProvider<TestEntity, TestUseCase>(
      (_) => TestUseCase(const TestEntity(foo: 'bar')),
    );
    final gateway = TestYieldGateway(provider)
      ..transport = (request) async {
        return const Either.right(TestResponse('success'));
      };

    final useCase = provider.getUseCaseFromContext(context);

    await useCase.fetchDataEventually();

    final output = useCase.getOutput<TestOutput>();
    expect(output, const TestOutput('bar'));

    gateway.yieldResponse(const TestResponse('with yield'));

    final output2 = useCase.getOutput<TestOutput>();
    expect(output2, const TestOutput('with yield'));
  });

  test('BridgeGateway transfer of data', () async {
    final useCase1 = TestUseCase(const TestEntity(foo: 'bar'));
    final useCase2 = TestUseCase(const TestEntity(foo: 'to be replaced'));

    TestBridgeGateway(subscriberUseCase: useCase2, publisherUseCase: useCase1);

    await useCase2.fetchStateFromOtherUseCase();
    final output = useCase2.getOutput<TestOutput>();

    expect(output, const TestOutput('bar'));
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
    return const FailureInput(message: 'backend error');
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
    return const FailureInput(message: 'backend error');
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
              (entity, input) => entity.copyWith(foo: input.foo),
            ),
          ],
        );

  Future<void> fetchDataImmediately() async {
    await request<TestDirectOutput, TestSuccessInput>(
      const TestDirectOutput('123'),
      onFailure: (_) => entity.copyWith(foo: 'failure'),
      onSuccess: (success) => entity.copyWith(foo: success.foo),
    );
  }

  Future<void> fetchDataEventually() async {
    await request<TestSubscriptionOutput, SuccessInput>(
      const TestSubscriptionOutput('123'),
      onFailure: (_) => entity.copyWith(foo: 'failure'),
      onSuccess: (_) => entity, // no changes on the entity are needed,
      // the changes should happen on the inputFilter.
    );
  }

  Future<void> fetchStateFromOtherUseCase() async {
    await request<TestDirectOutput, TestSuccessInput>(
      const TestDirectOutput(''),
      onFailure: (_) => entity,
      onSuccess: (input) {
        return entity.copyWith(foo: input.foo);
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
  const TestSuccessInput(this.foo);
  final String foo;
}

class TestDirectOutput extends Output {
  const TestDirectOutput(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class TestSubscriptionOutput extends Output {
  const TestSubscriptionOutput(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class TestEntity extends Entity {
  const TestEntity({required this.foo});
  final String foo;

  @override
  List<Object?> get props => [foo];

  @override
  TestEntity copyWith({String? foo}) => TestEntity(foo: foo ?? this.foo);
}

class TestOutput extends Output {
  const TestOutput(this.foo);
  final String foo;

  @override
  List<Object?> get props => [foo];
}
