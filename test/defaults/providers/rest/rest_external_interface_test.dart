import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/src/tests/gateway_fake.dart';
import 'package:clean_framework/src/utilities/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

void main() {
  final file = File('test/test_file.txt');

  setUp(() async {
    await file.create();
  });

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

  test('RestExternalInterface binary data request success response', () async {
    final testContent = {'foo': 'bar'};
    final restService = RestServiceFake(testContent);
    final gateWay = GatewayFake<TestBinaryPostRequest, RestSuccessResponse>();
    RestExternalInterface(
        restService: restService,
        baseUrl: '',
        gatewayConnections: [() => gateWay]);

    final result = await gateWay.transport(TestBinaryPostRequest());
    expect(result.isRight, isTrue);
    expect(result.right, RestSuccessResponse(data: testContent));
  });

  test('RestExternalInterface binary data request rest service failure',
      () async {
    final restService = RestServiceFake({});
    final gateWay = GatewayFake<TestBinaryPostRequest, RestSuccessResponse>();
    RestExternalInterface(
        restService: restService,
        baseUrl: '',
        gatewayConnections: [() => gateWay]);

    final result = await gateWay.transport(TestBinaryPostRequest());
    expect(result.isLeft, isTrue);
    expect(
      result.left,
      isA<UnknownFailureResponse>()
          .having((err) => err.message, 'message', 'Something went wrong'),
    );
  });

  test(
      'RestExternalInterface binary data request rest service failure on invalid file path',
      () async {
    final restService = RestServiceFake({});
    final gateWay = GatewayFake<TestBinaryPutRequest, RestSuccessResponse>();
    RestExternalInterface(
        restService: restService,
        baseUrl: '',
        gatewayConnections: [() => gateWay]);

    final result = await gateWay.transport(TestBinaryPutRequest());
    expect(result.isLeft, isTrue);
    expect(
      result.left,
      isA<UnknownFailureResponse>(),
    );
  });

  test(
      'RestExternalInterface binary data request invalid response service failure',
      () async {
    final restService = RestServiceFake({'statusCode': 400});
    final gateWay = GatewayFake<TestBinaryPostRequest, RestSuccessResponse>();
    RestExternalInterface(
        restService: restService,
        baseUrl: '',
        gatewayConnections: [() => gateWay]);

    final result = await gateWay.transport(TestBinaryPostRequest());
    expect(result.isLeft, isTrue);
    expect(
      result.left,
      isA<HttpFailureResponse>()
          .having((err) => err.statusCode, 'statusCode', 400)
          .having((err) => err.error, 'error', {'error': 'Bad Request'}).having(
              (err) => err.path, 'path', 'test/test_file.txt'),
    );
  });

  tearDown(() {
    file.delete();
  });
}

class TestRequest extends GetRestRequest {
  @override
  String get path => 'http://fake.com';
}

class TestBinaryPostRequest extends BinaryDataPostRestRequest {
  @override
  String get path => 'http://fake.com';

  @override
  String get src => 'test/test_file.txt';
}

class TestBinaryPutRequest extends BinaryDataPutRestRequest {
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
    Map<String, dynamic> headers = const {},
    Client? client,
  }) async {
    if (_response.isEmpty) throw RestServiceFailure();
    return {'foo': 'bar'};
  }

  @override
  Future<Map<String, dynamic>> binaryRequest({
    required RestMethod method,
    required String path,
    required List<int> data,
    Map<String, String> headers = const {},
    Client? client,
  }) async {
    if (_response.isEmpty) throw RestServiceFailure('Something went wrong');
    if (_response['statusCode'] == 400)
      throw InvalidResponseRestServiceFailure(
        error: {'error': 'Bad Request'},
        statusCode: 400,
        path: 'test/test_file.txt',
      );
    return {'foo': 'bar'};
  }
}
