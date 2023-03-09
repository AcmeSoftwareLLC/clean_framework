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
        const TestGatewayOutput('Acme Software'),
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
        const TestGatewayOutput('Acme Software'),
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
        const TestGatewayOutput('Acme Software'),
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
        const TestGatewayOutput('Acme Software'),
      );

      expect(input.isLeft, isTrue);
      expect(input.left.message, 'Something went wrong');
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
  });
}

final _testGatewayProvider = GatewayProvider(
  TestWatcherGateway.new,
  useCases: [_testUseCaseProvider],
);

final _testUseCaseProvider = UseCaseProvider(TestUseCase.new);

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
            InputTransformer<TestEntity, TestSuccessInput>.from(
              (e, i) => e.copyWith(message: i.message),
            ),
          ],
        );
}

class TestGateway extends Gateway<TestGatewayOutput, TestRequest,
    TestSuccessResponse, TestSuccessInput> {
  @override
  TestRequest buildRequest(TestGatewayOutput output) {
    return TestRequest(output.name);
  }

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: failureResponse.message);
  }

  @override
  TestSuccessInput onSuccess(TestSuccessResponse response) {
    return TestSuccessInput(response.message);
  }
}

class TestWatcherGateway extends WatcherGateway<TestGatewayOutput, TestRequest,
    TestSuccessResponse, TestSuccessInput> {
  @override
  TestRequest buildRequest(TestGatewayOutput output) {
    return TestRequest(output.name);
  }

  @override
  TestSuccessInput onSuccess(covariant TestSuccessResponse response) {
    return TestSuccessInput(response.message);
  }
}

class TestGatewayOutput extends Output {
  const TestGatewayOutput(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class TestSuccessInput extends SuccessInput {
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
