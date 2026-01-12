import 'package:clean_framework/clean_framework.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('External Interface tests |', () {
    test('gateway success', () async {
      final container = ProviderContainer();
      _testExternalInterfaceProvider.initializeFor(container);

      final gateway = _testGatewayProvider.read(container);

      final input = await gateway.buildInput(
        const TestDomainToGatewayModel(success: true),
      );

      expect(input.isRight, isTrue);
      expect(input.right, isA<TestSuccessInput>());
    });

    test('gateway failure', () async {
      final container = ProviderContainer();
      _testExternalInterfaceProvider.initializeFor(container);

      final gateway = _testGatewayProvider.read(container);

      final input = await gateway.buildInput(
        const TestDomainToGatewayModel(success: false),
      );

      expect(input.isLeft, isTrue);
      expect(input.left, isA<FailureDomainInput>());
    });

    test('watcher gateway success', () async {
      final container = ProviderContainer();
      _testExternalInterfaceProvider.initializeFor(container);

      final gateway = _testWatcherGatewayProvider.read(container);

      final input = await gateway.buildInput(
        const TestDomainToGatewayModel(success: true),
      );

      expect(input.isRight, isTrue);
      expect(input.right, isA<TestSuccessInput>());
    });

    test('watcher gateway failure', () async {
      final container = ProviderContainer();
      _testExternalInterfaceProvider.initializeFor(container);

      final gateway = _testWatcherGatewayProvider.read(container);

      final input = await gateway.buildInput(
        const TestDomainToGatewayModel(success: false),
      );

      expect(input.isLeft, isTrue);
      expect(input.left, isA<FailureDomainInput>());
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

    test('locates dependency', () {
      final container = ProviderContainer();

      var interface = _testExternalInterfaceProvider.read(container);
      var dependency = interface.locate(_testDependencyProvider);

      expect(dependency.value, equals('test'));

      final mockedContainer = ProviderContainer(
        overrides: [
          _testDependencyProvider.overrideWith(_Dependency('mocked')),
        ],
      );

      interface = _testExternalInterfaceProvider.read(mockedContainer);
      dependency = interface.locate(_testDependencyProvider);
      expect(dependency.value, equals('mocked'));

      dependency = _testDependencyProvider.read(mockedContainer);
      expect(dependency.value, equals('mocked'));
      expect(
        (interface.delegate! as TextExternalInterfaceDelegate).value,
        equals('mocked'),
      );
    });
  });
}

class _Dependency {
  _Dependency(this.value);

  final String value;
}

final DependencyProvider<_Dependency> _testDependencyProvider =
    DependencyProvider((_) => _Dependency('test'));

final ExternalInterfaceProvider<TestExternalInterface>
    _testExternalInterfaceProvider = ExternalInterfaceProvider(
  () => TestExternalInterface(delegate: TextExternalInterfaceDelegate()),
  gateways: [
    _testGatewayProvider,
    _testWatcherGatewayProvider,
  ],
);

final GatewayProvider<TestGateway> _testGatewayProvider =
    GatewayProvider(TestGateway.new);

final GatewayProvider<TestWatcherGateway> _testWatcherGatewayProvider =
    GatewayProvider(
  TestWatcherGateway.new,
);

class NewTestExternalInterface extends TestExternalInterface {}

class TestExternalInterface
    extends ExternalInterface<TestRequest, TestSuccessResponse> {
  TestExternalInterface({super.delegate});

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
  // ignore: invalid_override_of_non_virtual_member
  T locate<T extends Object>(DependencyProvider<T> provider) {
    return super.locate(provider);
  }

  @override
  FailureResponse onError(Object error) {
    return UnknownFailureResponse(error);
  }
}

class TextExternalInterfaceDelegate extends ExternalInterfaceDelegate {
  String get value => locate(_testDependencyProvider).value;
}

class TestSuccessResponse extends SuccessResponse {}

class TestFailureResponse extends FailureResponse {}

class TestRequest extends Request {
  const TestRequest({required this.success});

  final bool success;
}

class TestGateway extends Gateway<TestDomainToGatewayModel, TestRequest,
    TestSuccessResponse, TestSuccessInput> {
  @override
  TestRequest buildRequest(TestDomainToGatewayModel output) {
    return TestRequest(success: output.success);
  }

  @override
  FailureDomainInput onFailure(FailureResponse failureResponse) {
    return FailureDomainInput(message: failureResponse.message);
  }

  @override
  TestSuccessInput onSuccess(TestSuccessResponse response) {
    return TestSuccessInput();
  }
}

class TestWatcherGateway extends WatcherGateway<TestDomainToGatewayModel,
    TestRequest, TestSuccessResponse, TestSuccessInput> {
  @override
  TestRequest buildRequest(TestDomainToGatewayModel output) {
    return TestRequest(success: output.success);
  }

  @override
  FailureDomainInput onFailure(FailureResponse failureResponse) {
    return FailureDomainInput(message: failureResponse.message);
  }

  @override
  TestSuccessInput onSuccess(TestSuccessResponse response) {
    return TestSuccessInput();
  }
}

class TestDomainToGatewayModel extends DomainModel {
  const TestDomainToGatewayModel({required this.success});

  final bool success;

  @override
  List<Object?> get props => [success];
}

class TestSuccessInput extends SuccessDomainInput {}
