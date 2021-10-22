import 'dart:async';

import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework/src/app_providers_container.dart';
import 'package:clean_framework/src/providers/gateway.dart';
import 'package:clean_framework/src/providers/external_interface.dart';
import 'package:clean_framework/src/providers/gateway_provider.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';

final context = ProvidersContext();
late UseCaseProvider<TestEntity, TestUseCase> provider;

void main() {
  useCaseTest<TestUseCase, TestOutput>(
    'Interface using direct gateway',
    context: context,
    build: (_) => TestUseCase(TestEntity(foo: 'bar')),
    setup: (provider) {
      final gatewayProvider = GatewayProvider(
        (_) => TestDirectGateway(provider),
      );
      TestInterface(gatewayProvider);
    },
    execute: (useCase) => useCase.fetchDataImmediately(),
    verify: (useCase) {
      final output = useCase.getOutput<TestOutput>();
      expect(output, TestOutput('success'));
    },
  );

  useCaseTest<TestUseCase, TestOutput>(
    'Interface using watcher gateway',
    context: context,
    build: (_) => TestUseCase(TestEntity(foo: 'bar')),
    setup: (provider) {
      final gatewayProvider = GatewayProvider<WatcherGateway>(
        (_) => TestYieldGateway(provider),
      );
      TestInterface(gatewayProvider);
    },
    execute: (useCase) => useCase.fetchDataEventually(),
    expect: () => [
      TestOutput('0'),
      TestOutput('1'),
      TestOutput('2'),
      TestOutput('3'),
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
        await Future.delayed(Duration(milliseconds: 100));
        send(Right(TestResponse('success')));
      },
    );
    on<StreamTestRequest>(
      (request, send) async {
        final stream = Stream.periodic(
          Duration(milliseconds: 100),
          (count) => count,
        );

        final subscription = stream.listen(
          (count) => send(Right(TestResponse(count.toString()))),
        );

        await Future.delayed(Duration(milliseconds: 500));
        subscription.cancel();
      },
    );
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
      StreamTestRequest(output.id);

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
          outputFilters: {
            TestOutput: (entity) => TestOutput(entity.foo),
          },
          inputFilters: {
            TestSuccessInput: (TestSuccessInput input, TestEntity entity) =>
                entity.merge(foo: input.foo),
          },
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
}

abstract class TestRequest extends Request {
  final String id;

  TestRequest(this.id);

  @override
  List<Object?> get props => [id];
}

class FutureTestRequest extends TestRequest {
  FutureTestRequest(String id) : super(id);
}

class StreamTestRequest extends TestRequest {
  StreamTestRequest(String id) : super(id);
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

class TestEntity extends Entity {
  final String foo;

  TestEntity({required this.foo});

  @override
  List<Object?> get props => [foo];

  TestEntity merge({String? foo}) => TestEntity(foo: foo ?? this.foo);
}

class TestOutput extends Output {
  final String foo;

  TestOutput(this.foo);

  @override
  List<Object?> get props => [foo];
}
