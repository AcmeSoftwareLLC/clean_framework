import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/src/tests/gateway_fake.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

void main() {
  test('RestExternalInterface success response', () async {
    // for coverage purposes:
    RestExternalInterface(baseUrl: '', gatewayConnections: []);

    final testContent = {'foo': 'bar'};
    final restService = RestServiceFake(testContent);
    final gateWay = GatewayFake<TestRequest, RestSuccessResponse>();
    RestExternalInterface(
        restService: restService,
        baseUrl: '',
        gatewayConnections: [() => gateWay]);

    final result = await gateWay.transport(TestRequest());
    expect(result.isRight, isTrue);
    expect(result.right, RestSuccessResponse(data: testContent));
  });

  test('RestExternalInterface connectivity failure', () async {
    final restService = RestServiceFake({});
    final gateWay = GatewayFake<TestRequest, RestSuccessResponse>();
    RestExternalInterface(
        restService: restService,
        baseUrl: '',
        gatewayConnections: [() => gateWay]);

    final result = await gateWay.transport(TestRequest());
    expect(result.isLeft, isTrue);
    expect(result.left, isA<UnknownFailureResponse>());
  });
}

class TestRequest extends GetRestRequest {
  @override
  String get path => 'http://fake.com';
}

class RestServiceFake extends Fake implements RestService {
  final Map<String, dynamic> _response;

  RestServiceFake(this._response);

  @override
  Future<Map<String, dynamic>> request({
    required RestMethod method,
    required String path,
    Map<String, dynamic> data = const {},
    Client? client,
  }) async {
    if (_response.isEmpty) throw RestServiceFailure();
    return {'foo': 'bar'};
  }
}
