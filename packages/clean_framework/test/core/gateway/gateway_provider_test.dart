import 'package:clean_framework/clean_framework.dart';
import 'package:flutter_test/flutter_test.dart';

import 'gateway_test.dart';

void main() {
  group('Gateway Provider tests |', () {
    test('override gateway provider', () {
      final container = ProviderContainer(
        overrides: [
          _gatewayProvider.overrideWith(NewTestGateway()),
        ],
      );

      final interface = _gatewayProvider.read(container);

      expect(interface, isA<NewTestGateway>());
    });
  });
}

final _gatewayProvider = GatewayProvider(TestGateway.new);

class NewTestGateway extends TestGateway {}

class TestGateway extends Gateway {
  @override
  Request buildRequest(Output output) {
    return const TestRequest('');
  }

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: failureResponse.message);
  }

  @override
  SuccessInput onSuccess(SuccessResponse response) {
    return const TestSuccessInput('');
  }
}
