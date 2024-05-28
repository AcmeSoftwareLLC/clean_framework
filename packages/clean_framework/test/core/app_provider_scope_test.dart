import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppProviderScope tests |', () {
    testWidgets(
      'initializes providers',
      (tester) async {
        const key = ValueKey('child');
        final scope = AppProviderScope(
          externalInterfaceProviders: [_testExternalInterfaceProvider],
          child: const SizedBox.shrink(key: key),
        );

        await tester.pumpWidget(scope);

        _testUseCaseProvider.init();
        await tester.pumpAndSettle();

        final useCase = AppProviderScope.containerOf(
          tester.element(find.byKey(key)),
        ).read(_testUseCaseProvider().notifier);
        await useCase.ping('Hello');

        expect(useCase.debugEntity.pong, 'Hello');
      },
    );

    testWidgets(
      'throws error if no appropriate providers were supplied',
      (tester) async {
        const scope = AppProviderScope(
          child: MaterialApp(home: Text('PING')),
        );

        await tester.pumpWidget(scope);

        _testUseCaseProvider.init();
        await tester.pump();

        final useCase = AppProviderScope.containerOf(
          tester.element(find.byType(MaterialApp)),
        ).read(_testUseCaseProvider().notifier);

        try {
          await useCase.ping('Hello');
        } catch (e, s) {
          FlutterError.demangleStackTrace(s);
          expect(e, isA<StateError>());
        }
      },
    );
  });
}

final _testExternalInterfaceProvider = ExternalInterfaceProvider(
  TestExternalInterface.new,
  gateways: [_testGatewayProvider],
);

final _testGatewayProvider = GatewayProvider(
  TestGateway.new,
  useCases: [_testUseCaseProvider],
);

final _testUseCaseProvider = UseCaseProvider(TestUseCase.new);

class TestExternalInterface
    extends ExternalInterface<TestRequest, TestSuccessResponse> {
  @override
  void handleRequest() {
    on<TestRequest>(
      (request, send) {
        send(TestSuccessResponse(pong: request.ping));
      },
    );
  }

  @override
  FailureResponse onError(Object error) {
    return UnknownFailureResponse(error);
  }
}

class TestGateway extends Gateway<TestDomainToGatewayModel, TestRequest,
    TestSuccessResponse, TestSuccessInput> {
  @override
  TestRequest buildRequest(TestDomainToGatewayModel output) {
    return TestRequest(ping: output.ping);
  }

  @override
  FailureDomainInput onFailure(FailureResponse failureResponse) {
    return FailureDomainInput(message: failureResponse.message);
  }

  @override
  TestSuccessInput onSuccess(TestSuccessResponse response) {
    return TestSuccessInput(pong: response.pong);
  }
}

class TestRequest extends Request {
  const TestRequest({required this.ping});

  final String ping;
}

class TestSuccessResponse extends SuccessResponse {
  const TestSuccessResponse({required this.pong});

  final String pong;
}

class TestDomainToGatewayModel extends DomainModel {
  const TestDomainToGatewayModel({required this.ping});

  final String ping;

  @override
  List<Object?> get props => [ping];
}

class TestSuccessInput extends SuccessDomainInput {
  const TestSuccessInput({required this.pong});

  final String pong;
}

class TestUseCase extends UseCase<TestEntity> {
  TestUseCase() : super(entity: const TestEntity());

  Future<void> ping(String message) {
    return request<TestSuccessInput>(
      TestDomainToGatewayModel(ping: message),
      onSuccess: (input) => entity.copyWith(pong: input.pong),
      onFailure: (input) => entity,
    );
  }
}

class TestEntity extends Entity {
  const TestEntity({this.pong = ''});

  final String pong;

  @override
  TestEntity copyWith({String? pong}) => TestEntity(pong: pong ?? this.pong);

  @override
  List<Object?> get props => [pong];
}
