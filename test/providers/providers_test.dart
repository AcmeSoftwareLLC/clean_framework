import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final context = ProvidersContext();

  test('All providers', () async {
    final useCase = TestUseCase(TestEntity());
    final provider = UseCaseProvider((_) => useCase);
    final gateway = TestGateway(provider, context);
    final gatewayProvider = GatewayProvider((_) => gateway);
    final externalInterface = TestInterface(gatewayProvider);
    final externalInterfaceProvider =
        ExternalInterfaceProvider((_) => externalInterface);

    expect(provider.getUseCaseFromContext(context), useCase);
    expect(gatewayProvider.getGateway(context), gateway);
    expect(externalInterfaceProvider.getExternalInterface(context),
        externalInterface);
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

class TestRequest extends Request {
  @override
  List<Object?> get props => [];
}

class TestResponse extends SuccessResponse {
  @override
  List<Object?> get props => [];
}
