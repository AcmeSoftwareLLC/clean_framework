import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final context = ProvidersContext();
  final useCase = TestUseCase(TestEntity());
  UseCaseProvider provider;
  GatewayProvider gatewayProvider;
  ExternalInterfaceProvider externalInterfaceProvider;
  test('All providers', () async {
    provider = UseCaseProvider((_) => useCase);
    final gateway = TestGateway(provider, context);
    gatewayProvider = GatewayProvider((_) => gateway);
    final externalInterface = TestInterface(gatewayProvider);
    externalInterfaceProvider =
        ExternalInterfaceProvider((_) => externalInterface);

    expect(provider.getUseCaseFromContext(context), useCase);
    expect(gatewayProvider.getGateway(context), gateway);
    expect(externalInterfaceProvider.getExternalInterface(context),
        externalInterface);

    final overridenUseCase = TestUseCase(TestEntity2());
    context().updateOverrides([
      provider.overrideWith(overridenUseCase),
    ]);

    expect(provider.getUseCaseFromContext(context), useCase);
    //expect(provider.getUseCaseFromContext(context), overridenUseCase);
  });
}

class TestInterface extends ExternalInterface {
  TestInterface(GatewayProvider provider) : super([]);

  @override
  void handleRequest() {
    on((request, send) {
      send(Right(TestResponse()));
    });
  }
}

class TestGateway extends Gateway {
  TestGateway(UseCaseProvider provider, ProvidersContext context)
      : super(provider: provider, context: context);

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

class TestRequest extends Request {
  @override
  List<Object?> get props => [];
}

class TestResponse extends SuccessResponse {
  @override
  List<Object?> get props => [];
}
