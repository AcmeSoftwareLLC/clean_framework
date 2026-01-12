import 'package:clean_framework/clean_framework.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Gateway tests |', () {
    test('success', () async {
      final gateway = TestGateway()
        ..feedResponse(
          (request) async => Either.right(
            TestSuccessResponse('Hello ${request.name}!'),
          ),
        );

      final input = await gateway.buildInput(
        const TestDomainToGatewayModel('Acme Software'),
      );

      expect(input.isRight, isTrue);
      expect(input.right.message, 'Hello Acme Software!');
    });

    test('failure', () async {
      final gateway = TestGateway()
        ..feedResponse(
          (request) async => const Either.left(
            TypedFailureResponse(
              message: 'Something went wrong',
              type: 'failure',
            ),
          ),
        );

      final input = await gateway.buildInput(
        const TestDomainToGatewayModel('Acme Software'),
      );

      expect(input.isLeft, isTrue);
      expect(input.left.message, 'Something went wrong');
    });
  });

  group('Watcher Gateway', () {
    test('success', () async {
      final gateway = TestWatcherGateway()
        ..feedResponse(
          (request) async => Either.right(
            TestSuccessResponse('Hello ${request.name}!'),
          ),
        );

      final input = await gateway.buildInput(
        const TestDomainToGatewayModel('Acme Software'),
      );

      expect(input.isRight, isTrue);
      expect(input.right.message, 'Hello Acme Software!');
    });

    test('failure', () async {
      final gateway = TestWatcherGateway()
        ..feedResponse(
          (request) async => const Either.left(
            TypedFailureResponse(
              message: 'Something went wrong',
              type: 'failure',
            ),
          ),
        );

      final input = await gateway.buildInput(
        const TestDomainToGatewayModel('Acme Software'),
      );

      expect(input.isLeft, isTrue);
      expect(input.left.message, 'Something went wrong');
    });

    test('throws assertion if tried to feed response more than once', () async {
      final gateway = TestWatcherGateway()
        ..feedResponse(
          (request) async => const Either.left(
            TypedFailureResponse(
              message: 'Something went wrong',
              type: 'failure',
            ),
          ),
          source: ExternalInterface,
        );

      expect(
        () => gateway.feedResponse(
          (request) async => const Either.left(
            TypedFailureResponse(
              message: 'Something went wrong',
              type: 'failure',
            ),
          ),
        ),
        throwsA(
          isA<AssertionError>().having(
            (e) => e.message,
            'message',
            '\n\nThe "TestWatcherGateway" is already attached '
                'to ExternalInterface<Request, SuccessResponse>.\n',
          ),
        ),
      );
    });

    test('yielding response will update use case', () async {
      final container = ProviderContainer();

      final gateway = _testGatewayProvider.read(container);
      final useCase = _testUseCaseProvider.read(container);

      final expectation = expectLater(
        useCase.stream,
        emitsInOrder(
          const [
            TestEntity(message: 'Hello World 1!'),
            TestEntity(message: 'Hello World 2!'),
            TestEntity(message: 'Hello World 3!'),
            TestEntity(message: 'Hello World 4!'),
            TestEntity(message: 'Hello World 5!'),
          ],
        ),
      );

      _testUseCaseProvider.init();

      final subscription = Stream.fromIterable([1, 2, 3, 4, 5]).listen((event) {
        gateway.yieldResponse(TestSuccessResponse('Hello World $event!'));
      });

      await Future<void>.delayed(Duration.zero);
      await expectation;
      await subscription.cancel();
    });

    test('yielding response will update use case created using family',
        () async {
      final container = ProviderContainer();

      final gateway = _testGatewayProvider.read(container);
      final useCase = _testUseCaseProviderFamily('arg').read(container);

      final expectation = expectLater(
        useCase.stream,
        emitsInOrder(
          const [
            TestEntity(message: 'Hello World 1!'),
            TestEntity(message: 'Hello World 2!'),
            TestEntity(message: 'Hello World 3!'),
            TestEntity(message: 'Hello World 4!'),
            TestEntity(message: 'Hello World 5!'),
          ],
        ),
      );

      _testUseCaseProviderFamily.init('arg');

      final subscription = Stream.fromIterable([1, 2, 3, 4, 5]).listen((event) {
        gateway.yieldResponse(TestSuccessResponse('Hello World $event!'));
      });

      await Future<void>.delayed(Duration.zero);
      await expectation;
      await subscription.cancel();
    });
  });
}

final GatewayProvider<TestWatcherGateway> _testGatewayProvider =
    GatewayProvider(
  TestWatcherGateway.new,
  useCases: [_testUseCaseProvider],
  families: [_testUseCaseProviderFamily],
);

final UseCaseProvider<Entity, TestUseCase> _testUseCaseProvider =
    UseCaseProvider(TestUseCase.new);
final UseCaseProviderFamily<TestEntity, TestUseCase, String>
    _testUseCaseProviderFamily =
    UseCaseProvider.family<TestEntity, TestUseCase, String>(
  (_) => TestUseCase(),
);

class TestEntity extends Entity {
  const TestEntity({this.message = ''});

  final String message;

  @override
  TestEntity copyWith({String? message}) {
    return TestEntity(message: message ?? this.message);
  }

  @override
  List<Object?> get props => [message];
}

class TestUseCase extends UseCase<TestEntity> {
  TestUseCase()
      : super(
          entity: const TestEntity(),
          transformers: [
            DomainInputTransformer<TestEntity, TestSuccessInput>.from(
              (e, i) => e.copyWith(message: i.message),
            ),
          ],
        );
}

class TestGateway extends Gateway<TestDomainToGatewayModel, TestRequest,
    TestSuccessResponse, TestSuccessInput> {
  @override
  TestRequest buildRequest(TestDomainToGatewayModel output) {
    return TestRequest(output.name);
  }

  @override
  FailureDomainInput onFailure(FailureResponse failureResponse) {
    return FailureDomainInput(message: failureResponse.message);
  }

  @override
  TestSuccessInput onSuccess(TestSuccessResponse response) {
    return TestSuccessInput(response.message);
  }
}

class TestWatcherGateway extends WatcherGateway<TestDomainToGatewayModel,
    TestRequest, TestSuccessResponse, TestSuccessInput> {
  @override
  TestRequest buildRequest(TestDomainToGatewayModel output) {
    return TestRequest(output.name);
  }

  @override
  TestSuccessInput onSuccess(covariant TestSuccessResponse response) {
    return TestSuccessInput(response.message);
  }
}

class TestDomainToGatewayModel extends DomainModel {
  const TestDomainToGatewayModel(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class TestSuccessInput extends SuccessDomainInput {
  const TestSuccessInput(this.message);

  final String message;
}

class TestSuccessResponse extends SuccessResponse {
  const TestSuccessResponse(this.message);

  final String message;
}

class TestRequest extends Request {
  const TestRequest(this.name);

  final String name;
}
