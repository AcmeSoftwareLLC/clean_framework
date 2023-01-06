import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppProviderContainer', (tester) async {
    await tester.pumpWidget(
      AppProvidersContainer(
        child: const MaterialApp(),
        onBuild: (_, __) {},
      ),
    );
  });
  test('All providers', () async {
    final context = ProvidersContext();
    final useCase = TestUseCase(TestEntity());
    final gateway = TestGateway(useCase);
    final bridgeGateway = TestBridgeGateway(
      subscriberUseCase: useCase,
      publisherUseCase: useCase,
    );
    final externalInterface = TestInterface();

    final provider = UseCaseProvider((_) => useCase);
    final gatewayProvider = GatewayProvider((_) => gateway);
    final bridgeGatewayProvider = BridgeGatewayProvider((_) => bridgeGateway);
    final externalInterfaceProvider =
        ExternalInterfaceProvider((_) => externalInterface);

    expect(provider.getUseCaseFromContext(context), useCase);
    expect(gatewayProvider.getGateway(context), gateway);
    expect(bridgeGatewayProvider.getBridgeGateway(context), bridgeGateway);
    expect(
      externalInterfaceProvider.getExternalInterface(context),
      externalInterface,
    );
    context.dispose();
  });

  test('Providers with overrides', () async {
    final provider = UseCaseProvider((_) => TestUseCase(TestEntity()));
    final gatewayProvider =
        GatewayProvider((_) => TestGateway(TestUseCase(TestEntity())));
    final bridgeGatewayProvider = BridgeGatewayProvider(
      (_) => TestBridgeGateway(
        subscriberUseCase: TestUseCase(TestEntity()),
        publisherUseCase: TestUseCase(TestEntity()),
      ),
    );
    final externalInterfaceProvider =
        ExternalInterfaceProvider((_) => TestInterface());

    final useCase = TestUseCase(TestEntity());
    final gateway = TestGateway(useCase);
    final bridgeGateway = TestBridgeGateway(
      subscriberUseCase: useCase,
      publisherUseCase: useCase,
    );
    final externalInterface = TestInterface();

    final context = ProvidersContext([
      provider.overrideWith(useCase),
      gatewayProvider.overrideWith(gateway),
      bridgeGatewayProvider.overrideWith(bridgeGateway),
      externalInterfaceProvider.overrideWith(externalInterface),
    ]);

    expect(provider.getUseCaseFromContext(context), useCase);
    expect(gatewayProvider.getGateway(context), gateway);
    expect(
      externalInterfaceProvider.getExternalInterface(context),
      externalInterface,
    );
    expect(bridgeGatewayProvider.getBridgeGateway(context), bridgeGateway);
    context.dispose();
  });
}

class TestInterface extends ExternalInterface {
  TestInterface() : super([]);

  @override
  void handleRequest() {
    on((request, send) {
      send(TestResponse());
    });
  }

  @override
  FailureResponse onError(Object error) {
    return UnknownFailureResponse(error);
  }
}

class TestBridgeGateway
    extends BridgeGateway<TestOutput, TestOutput, SuccessInput> {
  TestBridgeGateway({
    required super.subscriberUseCase,
    required super.publisherUseCase,
  });
  @override
  SuccessInput onResponse(TestOutput output) => SuccessInput();
}

class TestGateway extends Gateway {
  TestGateway(UseCase useCase) : super(useCase: useCase);

  @override
  TestRequest buildRequest(Output output) => TestRequest();

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: 'backend error');
  }

  @override
  SuccessInput onSuccess(SuccessResponse response) {
    return SuccessInput();
  }
}

class TestUseCase extends UseCase<TestEntity> {
  TestUseCase(TestEntity entity) : super(entity: entity);

  void doRequest() => request(
        TestOutput(),
        onSuccess: (_) => TestEntity(),
        onFailure: (_) => TestEntity(),
      );
}

class TestEntity extends Entity {
  @override
  List<Object?> get props => [];
  TestEntity merge({String? foo}) => TestEntity();
}

class TestEntity2 extends TestEntity {
  @override
  List<Object?> get props => [];
  @override
  TestEntity2 merge({String? foo}) => TestEntity2();
}

class TestOutput extends Output {
  @override
  List<Object?> get props => [];
}

class TestRequest extends Request {}

class TestResponse extends SuccessResponse {
  @override
  List<Object?> get props => [];
}
