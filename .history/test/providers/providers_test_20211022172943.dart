import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('All providers', () async {
    final context = ProvidersContext();
    final useCase = TestUseCase(TestEntity());
    final gateway = TestGateway(useCase);
    final externalInterface = TestInterface();

    final provider = UseCaseProvider((_) => useCase);
    final gatewayProvider = GatewayProvider((_) => gateway);
    final externalInterfaceProvider =
        ExternalInterfaceProvider((_) => externalInterface);

    expect(provider.getUseCaseFromContext(context), useCase);
    expect(gatewayProvider.getGateway(context), gateway);
    expect(externalInterfaceProvider.getExternalInterface(context),
        externalInterface);
  });

  test('Providers with overrides', () async {
    final provider = UseCaseProvider((_) => TestUseCase(TestEntity()));
    final gatewayProvider =
        GatewayProvider((_) => TestGateway(TestUseCase(TestEntity())));
    final externalInterfaceProvider =
        ExternalInterfaceProvider((_) => TestInterface());

    final useCase = TestUseCase(TestEntity());
    final gateway = TestGateway(useCase);
    final externalInterface = TestInterface();

    final context = ProvidersContext([
      provider.overrideWith(useCase),
      gatewayProvider.overrideWith(gateway),
      externalInterfaceProvider.overrideWith(externalInterface),
    ]);

    expect(provider.getUseCaseFromContext(context), useCase);
    expect(gatewayProvider.getGateway(context), gateway);
    expect(externalInterfaceProvider.getExternalInterface(context),
        externalInterface);
  });
}

class TestInterface extends ExternalInterface {
  TestInterface() : super([]);

  @override
  void handleRequest() {
    on((request, send) {
      send(Right(TestResponse()));
    });
  }
}

class TestGateway extends Gateway {
  TestGateway(UseCase useCase) : super(useCase: useCase);

  @override
  buildRequest(output) => TestRequest();

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: 'backend error');
  }

  @override
  onSuccess(response) {
    return SuccessInput();
  }
}

class TestUseCase extends UseCase<TestEntity> {
  TestUseCase(TestEntity entity) : super(entity: entity);

  void doRequest() => request(TestOutput(),
      onSuccess: (_) => TestEntity(), onFailure: (_) => TestEntity());
}

class TestEntity extends Entity {
  @override
  List<Object?> get props => [];
  TestEntity merge({String? foo}) => TestEntity();
}

class TestEntity2 extends TestEntity {
  @override
  List<Object?> get props => [];
  TestEntity2 merge({String? foo}) => TestEntity2();
}

class TestOutput extends Output {
  @override
  List<Object?> get props => [];
}

class TestRequest extends Request {
  @override
  List<Object?> get props => [];
}

class TestResponse extends SuccessResponse {
  @override
  List<Object?> get props => [];
}
