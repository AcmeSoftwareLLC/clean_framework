import 'dart:async';

import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/src/app_providers_container.dart';
import 'package:clean_framework/src/providers/gateway.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';

final context = ProvidersContext();

void main() {
  test('Gateway transport direct request with success', () async {
    final provider = UseCaseProvider<TestEntity, TestUseCase>(
        (_) => TestUseCase(TestEntity(foo: 'bar')));
    var gateway = TestDirectGateway(provider);

    gateway.transport = (request) async =>
        Right<FailureResponse, TestResponse>(TestResponse('success'));

    final TestUseCase useCase = provider.getUseCaseFromContext(context);

    await useCase.fetchDataImmediatelly();

    var output = useCase.getOutput<TestOutput>();
    expect(output, TestOutput('success'));
  });

  test('Gateway transport direct request with failure', () async {
    final provider = UseCaseProvider<TestEntity, TestUseCase>(
        (_) => TestUseCase(TestEntity(foo: 'bar')));
    var gateway = TestDirectGateway(provider);
    gateway.transport = (request) async =>
        Left<FailureResponse, TestResponse>(FailureResponse());

    final TestUseCase useCase = provider.getUseCaseFromContext(context);

    await useCase.fetchDataImmediatelly();

    var output = useCase.getOutput<TestOutput>();
    expect(output, TestOutput('failure'));
  });

  test('Gateway transport delayed request with a yielded success', () async {
    final provider = UseCaseProvider<TestEntity, TestUseCase>(
        (_) => TestUseCase(TestEntity(foo: 'bar')));
    var gateway = TestYieldGateway(provider);

    gateway.transport = (request) async =>
        Right<FailureResponse, TestResponse>(TestResponse('success'));

    final TestUseCase useCase = provider.getUseCaseFromContext(context);

    await useCase.fetchDataEventually();

    var output = useCase.getOutput<TestOutput>();
    expect(output, TestOutput('bar'));

    gateway.yieldResponse(TestResponse('with yield'));

    var output2 = useCase.getOutput<TestOutput>();
    expect(output2, TestOutput('with yield'));
  });

  test('BridgeGateway transfer of data', () {
    final useCase1 = TestUseCase(TestEntity(foo: 'bar'));
    final useCase2 = TestUseCase(TestEntity(foo: 'to be replaced'));

    final bridge = TestBridgeGateway(
        subscriberUseCase: useCase1, publisherUseCase: useCase2);
  });
}

class TestBridgeGateway
    extends BridgeGateway<TestOutput, TestOutput, TestSuccessInput> {
  TestBridgeGateway({
    required UseCase subscriberUseCase,
    required UseCase publisherUseCase,
  }) : super(
            subscriberUseCase: subscriberUseCase,
            publisherUseCase: publisherUseCase);
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
      : super(entity: entity, outputFilters: {
          TestOutput: (entity) => TestOutput(entity.foo),
        }, inputFilters: {
          TestSuccessInput: (TestSuccessInput input, TestEntity entity) =>
              entity.merge(foo: input.foo),
        });

  Future<void> fetchDataImmediatelly() async {
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
    await request<TestOutput, TestSuccessInput>(TestOutput(''),
        onFailure: (_) => entity,
        onSuccess: (input) => entity.merge(foo: input.foo));
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
