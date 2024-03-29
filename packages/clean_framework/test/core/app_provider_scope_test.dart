import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppProviderScope tests |', () {
    testWidgets(
      'initializes providers',
      (tester) async {
        final container = ProviderContainer();

        final scope = AppProviderScope(
          parent: container,
          externalInterfaceProviders: [_testExternalInterfaceProvider],
          child: const SizedBox.shrink(),
        );

        await tester.pumpWidget(scope);

        _testUseCaseProvider.init();
        await tester.pumpAndSettle();

        final useCase = container.read(_testUseCaseProvider().notifier);
        await useCase.ping('Hello');

        expect(useCase.debugEntity.pong, 'Hello');
      },
    );

    testWidgets(
      'throws error if no appropriate providers were supplied',
      (tester) async {
        final container = ProviderContainer();

        final scope = AppProviderScope(
          parent: container,
          child: const MaterialApp(home: Text('PING')),
        );

        await tester.pumpWidget(scope);

        _testUseCaseProvider.init();
        await tester.pump();

        final useCase = container.read(_testUseCaseProvider().notifier);

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

class TestGateway extends Gateway<TestGatewayOutput, TestRequest,
    TestSuccessResponse, TestSuccessInput> {
  @override
  TestRequest buildRequest(TestGatewayOutput output) {
    return TestRequest(ping: output.ping);
  }

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: failureResponse.message);
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

class TestGatewayOutput extends Output {
  const TestGatewayOutput({required this.ping});

  final String ping;

  @override
  List<Object?> get props => [ping];
}

class TestSuccessInput extends SuccessInput {
  const TestSuccessInput({required this.pong});

  final String pong;
}

class TestUseCase extends UseCase<TestEntity> {
  TestUseCase() : super(entity: const TestEntity());

  Future<void> ping(String message) {
    return request<TestSuccessInput>(
      TestGatewayOutput(ping: message),
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
