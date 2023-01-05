import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_core.dart';
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
        TestGatewayOutput('Acme Software'),
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
        TestGatewayOutput('Acme Software'),
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
        TestGatewayOutput('Acme Software'),
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
        TestGatewayOutput('Acme Software'),
      );

      expect(input.isLeft, isTrue);
      expect(input.left.message, 'Something went wrong');
    });
  });
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
  TestGatewayOutput(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class TestSuccessInput extends SuccessInput {
  TestSuccessInput(this.message);

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
