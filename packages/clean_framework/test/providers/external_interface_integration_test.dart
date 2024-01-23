import 'dart:async';

import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:clean_framework_test/clean_framework_test_legacy.dart';
import 'package:flutter_test/flutter_test.dart';

final context = ProvidersContext();
late UseCaseProvider<TestEntity, TestUseCase> provider;

void main() {
  useCaseTest<TestUseCase, TestDomainModel>(
    'Interface using direct gateway',
    context: context,
    build: (_) => TestUseCase(const TestEntity(foo: 'bar')),
    setup: (provider) {
      final gatewayProvider = GatewayProvider(
        (_) => TestDirectGateway(provider),
      );
      TestInterface(gatewayProvider);
    },
    execute: (useCase) => useCase.fetchDataImmediately(),
    verify: (useCase) {
      final output = useCase.getOutput<TestDomainModel>();
      expect(output, const TestDomainModel('success'));
    },
  );

  useCaseTest<TestUseCase, TestDomainModel>(
    'Watcher Interface with failure',
    context: context,
    build: (_) => TestUseCase(const TestEntity(foo: 'bar')),
    setup: (provider) {
      final gatewayProvider = GatewayProvider(
        (_) => TestWatcherGatewayWithFailure(provider),
      );
      TestInterface(gatewayProvider);
    },
    execute: (useCase) => useCase.fetchDataImmediately(),
    verify: (useCase) {
      final output = useCase.getOutput<TestDomainModel>();
      expect(output, const TestDomainModel('failure'));
    },
  );

  useCaseTest<TestUseCase, TestDomainModel>(
    'Interface with failure',
    context: context,
    build: (_) => TestUseCase(const TestEntity(foo: 'bar')),
    setup: (provider) {
      final gatewayProvider = GatewayProvider(
        (_) => TestGatewayWithFailure(provider),
      );
      TestInterface(gatewayProvider);
    },
    execute: (useCase) => useCase.fetchDataImmediately(),
    verify: (useCase) {
      final output = useCase.getOutput<TestDomainModel>();
      expect(output, const TestDomainModel('failure'));
    },
  );

  useCaseTest<TestUseCase, TestDomainModel>(
    'Interface using watcher gateway',
    context: context,
    build: (_) => TestUseCase(const TestEntity(foo: 'bar')),
    setup: (provider) {
      final gatewayProvider = GatewayProvider<WatcherGateway>(
        (_) => TestYieldGateway(provider),
      );
      TestInterface(gatewayProvider);
    },
    execute: (useCase) => useCase.fetchDataEventually(),
    expect: () => [
      const TestDomainModel('0'),
      const TestDomainModel('1'),
      const TestDomainModel('2'),
      const TestDomainModel('3'),
    ],
  );
}

class TestInterface extends ExternalInterface<TestRequest, TestResponse> {
  TestInterface(GatewayProvider provider)
      : super([() => provider.getGateway(context)]);

  @override
  void handleRequest() {
    on<FutureTestRequest>(
      (request, send) async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        send(const TestResponse('success'));
      },
    );
    on<FailedRequest>(
      (request, send) async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        sendError(const TypedFailureResponse(type: 'test'));
      },
    );
    on<StreamTestRequest>(
      (request, send) async {
        final stream = Stream.periodic(
          const Duration(milliseconds: 100),
          (count) => count,
        );

        final subscription = stream.listen(
          (count) => send(TestResponse(count.toString())),
        );

        await Future<void>.delayed(const Duration(milliseconds: 500));
        await subscription.cancel();
      },
    );
  }

  @override
  FailureResponse onError(Object error) {
    return UnknownFailureResponse(error);
  }
}

class TestDirectGateway extends Gateway<TestDirectDomainModel, TestRequest,
    TestResponse, TestSuccessInput> {
  TestDirectGateway(UseCaseProvider provider)
      : super(provider: provider, context: context);

  @override
  TestRequest buildRequest(TestDirectDomainModel output) =>
      FutureTestRequest(output.id);

  @override
  FailureDomainInput onFailure(FailureResponse failureResponse) {
    return const FailureDomainInput(message: 'backend error');
  }

  @override
  TestSuccessInput onSuccess(TestResponse response) {
    return TestSuccessInput(response.foo);
  }
}

class TestGatewayWithFailure extends Gateway<TestDirectDomainModel,
    FailedRequest, TestResponse, TestSuccessInput> {
  TestGatewayWithFailure(UseCaseProvider provider)
      : super(provider: provider, context: context);

  @override
  FailedRequest buildRequest(TestDirectDomainModel output) {
    return FailedRequest(output.id);
  }

  @override
  TestSuccessInput onSuccess(TestResponse response) {
    return TestSuccessInput(response.foo);
  }

  @override
  FailureDomainInput onFailure(FailureResponse failureResponse) {
    return FailureDomainInput(message: failureResponse.message);
  }
}

class TestWatcherGatewayWithFailure extends WatcherGateway<
    TestDirectDomainModel, FailedRequest, TestResponse, TestSuccessInput> {
  TestWatcherGatewayWithFailure(UseCaseProvider provider)
      : super(provider: provider, context: context);

  @override
  FailedRequest buildRequest(TestDirectDomainModel output) =>
      FailedRequest(output.id);

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
      StreamTestRequest(output.id);

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
              (entity) => TestDomainModel(entity.foo),
            ),
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

  Future<void> fetchDataImmediatelyWithFailure() async {
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
}

abstract class TestRequest extends Request {
  const TestRequest(this.id);
  final String id;
}

class FutureTestRequest extends TestRequest {
  const FutureTestRequest(super.id);
}

class FailedRequest extends TestRequest {
  const FailedRequest(super.id);
}

class StreamTestRequest extends TestRequest {
  const StreamTestRequest(super.id);
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
