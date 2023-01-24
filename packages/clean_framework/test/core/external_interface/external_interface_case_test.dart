import 'package:clean_framework/clean_framework.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('External Interface tests |', () {
    test('gateway success', () async {
      final container = ProviderContainer();
      _testExternalInterfaceProvider.initializeFor(container);

      final gateway = _testGatewayProvider.read(container);

      final input = await gateway.buildInput(
        const TestGatewayOutput(success: true),
      );

      expect(input.isRight, isTrue);
      expect(input.right, isA<TestSuccessInput>());
    });

    test('gateway failure', () async {
      final container = ProviderContainer();
      _testExternalInterfaceProvider.initializeFor(container);

      final gateway = _testGatewayProvider.read(container);

      final input = await gateway.buildInput(
        const TestGatewayOutput(success: false),
      );

      expect(input.isLeft, isTrue);
      expect(input.left, isA<FailureInput>());
    });

    test('watcher gateway success', () async {
      final container = ProviderContainer();
      _testExternalInterfaceProvider.initializeFor(container);

      final gateway = _testWatcherGatewayProvider.read(container);

      final input = await gateway.buildInput(
        const TestGatewayOutput(success: true),
      );

      expect(input.isRight, isTrue);
      expect(input.right, isA<TestSuccessInput>());
    });

    test('watcher gateway failure', () async {
      final container = ProviderContainer();
      _testExternalInterfaceProvider.initializeFor(container);

      final gateway = _testWatcherGatewayProvider.read(container);

      final input = await gateway.buildInput(
        const TestGatewayOutput(success: false),
      );

      expect(input.isLeft, isTrue);
      expect(input.left, isA<FailureInput>());
    });

    test('override external interface provider', () {
      final container = ProviderContainer(
        overrides: [
          _testExternalInterfaceProvider.overrideWith(
            NewTestExternalInterface(),
          ),
        ],
      );

      final interface = _testExternalInterfaceProvider.read(container);

      expect(interface, isA<NewTestExternalInterface>());
    });
  });
}

final _testExternalInterfaceProvider = ExternalInterfaceProvider(
  TestExternalInterface.new,
  gateways: [
    _testGatewayProvider,
    _testWatcherGatewayProvider,
  ],
);

final _testGatewayProvider = GatewayProvider(TestGateway.new);

final _testWatcherGatewayProvider = GatewayProvider(
  TestWatcherGateway.new,
);

class NewTestExternalInterface extends TestExternalInterface {}

class TestExternalInterface
    extends ExternalInterface<TestRequest, TestSuccessResponse> {
  @override
  void handleRequest() {
    on<TestRequest>(
      (request, send) async {
        await Future<void>.delayed(const Duration(milliseconds: 100));

        if (request.success) {
          send(TestSuccessResponse());
        } else {
          sendError(TestFailureResponse());
        }
      },
    );
  }

  @override
  FailureResponse onError(Object error) {
    return UnknownFailureResponse(error);
  }
}

class TestSuccessResponse extends SuccessResponse {}

class TestFailureResponse extends FailureResponse {}

class TestRequest extends Request {
  const TestRequest({required this.success});

  final bool success;
}

class TestGateway extends Gateway<TestGatewayOutput, TestRequest,
    TestSuccessResponse, TestSuccessInput> {
  @override
  TestRequest buildRequest(TestGatewayOutput output) {
    return TestRequest(success: output.success);
  }

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: failureResponse.message);
  }

  @override
  TestSuccessInput onSuccess(TestSuccessResponse response) {
    return TestSuccessInput();
  }
}

class TestWatcherGateway extends WatcherGateway<TestGatewayOutput, TestRequest,
    TestSuccessResponse, TestSuccessInput> {
  @override
  TestRequest buildRequest(TestGatewayOutput output) {
    return TestRequest(success: output.success);
  }

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: failureResponse.message);
  }

  @override
  TestSuccessInput onSuccess(TestSuccessResponse response) {
    return TestSuccessInput();
  }
}

class TestGatewayOutput extends Output {
  const TestGatewayOutput({required this.success});

  final bool success;

  @override
  List<Object?> get props => [success];
}

class TestSuccessInput extends SuccessInput {}
