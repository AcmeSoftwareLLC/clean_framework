import 'dart:async';

import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/src/app_providers_container.dart';
import 'package:clean_framework/src/providers/gateway.dart';
import 'package:clean_framework/src/providers/external_interface.dart';
import 'package:clean_framework/src/providers/gateway_provider.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';

final context = ProvidersContext();
late UseCaseProvider<TestEntity, TestUseCase> provider;

void main() {
  test('Interface using basic transport', () async {
    provider = UseCaseProvider((_) => TestUseCase(TestEntity(foo: 'bar')));
    final gatewayProvider = GatewayProvider((_) => TestDirectGateway(provider));

    TestInterface(gatewayProvider);

    final TestUseCase useCase = provider.getUseCaseFromContext(context);

    await useCase.fetchDataImmediatelly();

    var output = useCase.getOutput<TestOutput>();
    expect(output, TestOutput('success'));
  });

  test('Interface using yield', () async {
    provider = UseCaseProvider((_) => TestUseCase(TestEntity(foo: 'bar')));
    final gatewayProvider =
        GatewayProvider<WatcherGateway>((_) => TestYieldGateway(provider));

    TestInterfaceWithYield(gatewayProvider);

    final TestUseCase useCase = provider.getUseCaseFromContext(context);

    await useCase.fetchDataEventually();

    var output = useCase.getOutput<TestOutput>();
    expect(output, TestOutput('with yield'));
  });
}

class TestInterfaceWithYield
    extends WatcherExternalInterface<TestRequest, TestResponse> {
  TestInterfaceWithYield(GatewayProvider<WatcherGateway> provider)
      : super([
          () => provider.getGateway(context),
        ]);

  @override
  Future<Either<FailureResponse, TestResponse>> onTransport(
      TestRequest request, Function(TestResponse) yieldResponse) async {
    yieldResponse(TestResponse('with yield'));
    return Right(TestResponse('success'));
  }
}

class TestInterface extends DirectExternalInterface<TestRequest, TestResponse> {
  TestInterface(GatewayProvider provider)
      : super([
          () => provider.getGateway(context),
        ]);

  @override
  Future<Either<FailureResponse, TestResponse>> onTransport(
          TestRequest request) async =>
      Right(TestResponse('success'));
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
  SuccessInput onSuccess(_) {
    return SuccessInput();
  }

  @override
  TestSuccessInput onYield(TestResponse response) {
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

  @override
  List<Object?> get props => [foo];
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
