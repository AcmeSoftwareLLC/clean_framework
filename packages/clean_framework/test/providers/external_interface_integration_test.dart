import 'dart:async';

import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:clean_framework_test/clean_framework_test_legacy.dart';
import 'package:flutter_test/flutter_test.dart';

final context = ProvidersContext();
late UseCaseProvider<TestEntity, TestUseCase> provider;

void main() {
  useCaseTest<TestUseCase, TestOutput>(
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
      final output = useCase.getOutput<TestOutput>();
      expect(output, const TestOutput('success'));
    },
  );

  useCaseTest<TestUseCase, TestOutput>(
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
      final output = useCase.getOutput<TestOutput>();
      expect(output, const TestOutput('failure'));
    },
  );

  useCaseTest<TestUseCase, TestOutput>(
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
      final output = useCase.getOutput<TestOutput>();
      expect(output, const TestOutput('failure'));
    },
  );

  useCaseTest<TestUseCase, TestOutput>(
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
      const TestOutput('0'),
      const TestOutput('1'),
      const TestOutput('2'),
      const TestOutput('3'),
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

class TestDirectGateway extends Gateway<TestDirectOutput, TestRequest,
    TestResponse, TestSuccessInput> {
  TestDirectGateway(UseCaseProvider provider)
      : super(provider: provider, context: context);

  @override
  TestRequest buildRequest(TestDirectOutput output) =>
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

class TestGatewayWithFailure extends Gateway<TestDirectOutput, FailedRequest,
    TestResponse, TestSuccessInput> {
  TestGatewayWithFailure(UseCaseProvider provider)
      : super(provider: provider, context: context);

  @override
  FailedRequest buildRequest(TestDirectOutput output) {
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

class TestWatcherGatewayWithFailure extends WatcherGateway<TestDirectOutput,
    FailedRequest, TestResponse, TestSuccessInput> {
  TestWatcherGatewayWithFailure(UseCaseProvider provider)
      : super(provider: provider, context: context);

  @override
  FailedRequest buildRequest(TestDirectOutput output) =>
      FailedRequest(output.id);

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
      StreamTestRequest(output.id);

  @override
  TestSuccessInput onSuccess(TestResponse response) {
    return TestSuccessInput(response.foo);
  }
}

class TestUseCase extends UseCase<TestEntity> {
  TestUseCase(TestEntity entity)
      : super(
          useCaseState: entity,
          transformers: [
            OutputTransformer.from((entity) => TestOutput(entity.foo)),
            DomainInputTransformer<TestEntity, TestSuccessInput>.from(
              (entity, input) => entity.copyWith(foo: input.foo),
            ),
          ],
        );

  Future<void> fetchDataImmediately() async {
    await request<TestSuccessInput>(
      const TestDirectOutput('123'),
      onFailure: (_) => useCaseState.copyWith(foo: 'failure'),
      onSuccess: (success) => useCaseState.copyWith(foo: success.foo),
    );
  }

  Future<void> fetchDataImmediatelyWithFailure() async {
    await request<TestSuccessInput>(
      const TestDirectOutput('123'),
      onFailure: (_) => useCaseState.copyWith(foo: 'failure'),
      onSuccess: (success) => useCaseState.copyWith(foo: success.foo),
    );
  }

  Future<void> fetchDataEventually() async {
    await request<SuccessDomainInput>(
      const TestSubscriptionOutput('123'),
      onFailure: (_) => useCaseState.copyWith(foo: 'failure'),
      onSuccess: (_) => useCaseState, // no changes on the entity are needed,
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

class TestDirectOutput extends DomainOutput {
  const TestDirectOutput(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class TestSubscriptionOutput extends DomainOutput {
  const TestSubscriptionOutput(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class TestEntity extends UseCaseState {
  const TestEntity({required this.foo});
  final String foo;

  @override
  List<Object?> get props => [foo];

  @override
  TestEntity copyWith({String? foo}) => TestEntity(foo: foo ?? this.foo);
}

class TestOutput extends DomainOutput {
  const TestOutput(this.foo);
  final String foo;

  @override
  List<Object?> get props => [foo];
}
