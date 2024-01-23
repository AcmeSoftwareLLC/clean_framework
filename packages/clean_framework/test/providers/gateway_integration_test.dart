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

    final output = useCase.getOutput<TestDomainModel>();
    expect(output, const TestDomainModel('success'));
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

    final output = useCase.getOutput<TestDomainModel>();
    expect(output, const TestDomainModel('failure'));
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

    final output = useCase.getOutput<TestDomainModel>();
    expect(output, const TestDomainModel('bar'));

    gateway.yieldResponse(const TestResponse('with yield'));

    final output2 = useCase.getOutput<TestDomainModel>();
    expect(output2, const TestDomainModel('with yield'));
  });

  test('BridgeGateway transfer of data', () async {
    final useCase1 = TestUseCase(const TestEntity(foo: 'bar'));
    final useCase2 = TestUseCase(const TestEntity(foo: 'to be replaced'));

    TestBridgeGateway(subscriberUseCase: useCase2, publisherUseCase: useCase1);

    await useCase2.fetchStateFromOtherUseCase();
    final output = useCase2.getOutput<TestDomainModel>();

    expect(output, const TestDomainModel('bar'));
  });
}

class TestBridgeGateway extends BridgeGateway<TestDirectDomainModel,
    TestDomainModel, TestSuccessInput> {
  TestBridgeGateway({
    required super.subscriberUseCase,
    required super.publisherUseCase,
  });
  @override
  TestSuccessInput onResponse(TestDomainModel output) =>
      TestSuccessInput(output.foo);
}

class TestDirectGateway extends Gateway<TestDirectDomainModel, TestRequest,
    TestResponse, TestSuccessInput> {
  TestDirectGateway(UseCaseProvider provider)
      : super(provider: provider, context: context);

  @override
  TestRequest buildRequest(TestDirectDomainModel output) =>
      TestRequest(output.id);

  @override
  FailureDomainInput onFailure(FailureResponse failureResponse) {
    return const FailureDomainInput(message: 'backend error');
  }

  @override
  TestSuccessInput onSuccess(TestResponse response) {
    return TestSuccessInput(response.foo);
  }
}

class TestYieldGateway extends WatcherGateway<TestSubscriptionDomainModel,
    TestRequest, TestResponse, TestSuccessInput> {
  TestYieldGateway(UseCaseProvider provider)
      : super(provider: provider, context: context);

  @override
  TestRequest buildRequest(TestSubscriptionDomainModel output) =>
      TestRequest(output.id);

  @override
  FailureDomainInput onFailure(FailureResponse failureResponse) {
    return const FailureDomainInput(message: 'backend error');
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
            DomainModelTransformer.from(
                (entity) => TestDomainModel(entity.foo)),
            DomainInputTransformer<TestEntity, TestSuccessInput>.from(
              (entity, input) => entity.copyWith(foo: input.foo),
            ),
          ],
        );

  Future<void> fetchDataImmediately() async {
    await request<TestSuccessInput>(
      const TestDirectDomainModel('123'),
      onFailure: (_) => entity.copyWith(foo: 'failure'),
      onSuccess: (success) => entity.copyWith(foo: success.foo),
    );
  }

  Future<void> fetchDataEventually() async {
    await request<SuccessDomainInput>(
      const TestSubscriptionDomainModel('123'),
      onFailure: (_) => entity.copyWith(foo: 'failure'),
      onSuccess: (_) => entity, // no changes on the entity are needed,
      // the changes should happen on the inputFilter.
    );
  }

  Future<void> fetchStateFromOtherUseCase() async {
    await request<TestSuccessInput>(
      const TestDirectDomainModel(''),
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

class TestSuccessInput extends SuccessDomainInput {
  const TestSuccessInput(this.foo);
  final String foo;
}

class TestDirectDomainModel extends DomainModel {
  const TestDirectDomainModel(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class TestSubscriptionDomainModel extends DomainModel {
  const TestSubscriptionDomainModel(this.id);
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

class TestDomainModel extends DomainModel {
  const TestDomainModel(this.foo);
  final String foo;

  @override
  List<Object?> get props => [foo];
}
