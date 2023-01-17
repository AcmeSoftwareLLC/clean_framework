import 'dart:async';

import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
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
    'Interface with failure',
    context: context,
    build: (_) => TestUseCase(const TestEntity(foo: 'bar')),
    setup: (provider) {
      final gatewayProvider = GatewayProvider(
        (_) => TestWatcherGatewayWitFailure(provider),
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
  FailureInput onFailure(FailureResponse failureResponse) {
    return const FailureInput(message: 'backend error');
  }

  @override
  TestSuccessInput onSuccess(TestResponse response) {
    return TestSuccessInput(response.foo);
  }
}

class TestWatcherGatewayWitFailure extends WatcherGateway<TestDirectOutput,
    FailedRequest, TestResponse, TestSuccessInput> {
  TestWatcherGatewayWitFailure(UseCaseProvider provider)
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

  Future<void> fetchDataImmediatelyWithFailure() async {
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
