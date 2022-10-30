import 'dart:io';
import 'dart:typed_data';

import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework_rest/clean_framework_rest.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

void main() {
  const fileName = 'test/test_file.txt';

  setUp(() {
    File(fileName).createSync();
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
      gatewayConnections: [() => gateWay],
    );

    final result = await gateWay.transport(TestRequest());
    expect(result.isRight, isTrue);
    expect(result.right, JsonRestSuccessResponse(data: testContent));
  });

  test('RestExternalInterface connectivity failure', () async {
    final restService = RestServiceFake({});
    final gateWay = GatewayFake<TestRequest, RestSuccessResponse>();
    RestExternalInterface(
      restService: restService,
      baseUrl: '',
      gatewayConnections: [() => gateWay],
    );

    final result = await gateWay.transport(TestRequest());
    expect(result.isLeft, isTrue);
    expect(
      result.left,
      isA<HttpFailureResponse>()
          .having((err) => err.statusCode, 'statusCode', 400)
          .having((err) => err.error, 'error', {'error': 'Bad Request'}).having(
        (err) => err.path,
        'path',
        'http://fake.com',
      ),
    );
  });

  test('RestExternalInterface multipart request request success response',
      () async {
    final testContent = {'foo': 'bar'};
    final restService = RestServiceFake(testContent);
    final gateWay =
        GatewayFake<TestPostMultipartRequest, RestSuccessResponse>();
    RestExternalInterface(
      restService: restService,
      baseUrl: '',
      gatewayConnections: [() => gateWay],
    );

    final result = await gateWay.transport(TestPostMultipartRequest());
    expect(result.isRight, isTrue);
    expect(result.right, JsonRestSuccessResponse(data: testContent));
  });

  test('RestExternalInterface binary data src request success response',
      () async {
    final testContent = {'foo': 'bar'};
    final restService = RestServiceFake(testContent);
    final gateWay =
        GatewayFake<TestBinarySrcPostRequest, RestSuccessResponse>();
    RestExternalInterface(
      restService: restService,
      baseUrl: '',
      gatewayConnections: [() => gateWay],
    );

    final result = await gateWay.transport(TestBinarySrcPostRequest());
    expect(result.isRight, isTrue);
    expect(result.right, JsonRestSuccessResponse(data: testContent));
  });

  test('RestExternalInterface binary data request success response', () async {
    final testContent = {'foo': 'bar'};
    final restService = RestServiceFake(testContent);
    final gateWay =
        GatewayFake<TestBinaryDataPutRequest, RestSuccessResponse>();
    RestExternalInterface(
      restService: restService,
      baseUrl: '',
      gatewayConnections: [() => gateWay],
    );
    final result = await gateWay.transport(TestBinaryDataPutRequest());
    expect(result.isRight, isTrue);
    expect(result.right, JsonRestSuccessResponse(data: testContent));
  });

  test('RestExternalInterface binary data request rest service failure',
      () async {
    final restService = RestServiceFake({});
    final gateWay =
        GatewayFake<TestBinaryDataPostRequest, RestSuccessResponse>();
    RestExternalInterface(
      restService: restService,
      baseUrl: '',
      gatewayConnections: [() => gateWay],
    );

    final result = await gateWay.transport(TestBinaryDataPostRequest());
    expect(result.isLeft, isTrue);
    expect(
      result.left,
      isA<UnknownFailureResponse>()
          .having((err) => err.message, 'message', 'Something went wrong'),
    );
  });

  test(
      'RestExternalInterface binary data src '
      'request rest service failure on invalid file path', () async {
    final restService = RestServiceFake({});
    final gateWay = GatewayFake<TestBinarySrcPutRequest, RestSuccessResponse>();
    RestExternalInterface(
      restService: restService,
      baseUrl: '',
      gatewayConnections: [() => gateWay],
    );

    final result = await gateWay.transport(TestBinarySrcPutRequest());
    expect(result.isLeft, isTrue);
    expect(
      result.left,
      isA<UnknownFailureResponse>()
          .having((err) => err.message, 'message', isNotEmpty),
    );
  });

  test(
      'RestExternalInterface binary data src '
      'request invalid response service failure', () async {
    final restService = RestServiceFake({'statusCode': 400});
    final gateWay =
        GatewayFake<TestBinarySrcPostRequest, RestSuccessResponse>();
    RestExternalInterface(
      restService: restService,
      baseUrl: '',
      gatewayConnections: [() => gateWay],
    );

    final result = await gateWay.transport(TestBinarySrcPostRequest());
    expect(result.isLeft, isTrue);
    expect(
      result.left,
      isA<HttpFailureResponse>()
          .having((err) => err.statusCode, 'statusCode', 400)
          .having((err) => err.error, 'error', {'error': 'Bad Request'}).having(
        (err) => err.path,
        'path',
        'http://fake.com',
      ),
    );
  });

  test(
      'RestExternalInterface binary data '
      'request invalid response service failure', () async {
    final restService = RestServiceFake({'statusCode': 400});
    final gateWay =
        GatewayFake<TestBinarySrcPostRequest, RestSuccessResponse>();
    RestExternalInterface(
      restService: restService,
      baseUrl: '',
      gatewayConnections: [() => gateWay],
    );

    final result = await gateWay.transport(TestBinarySrcPostRequest());
    expect(result.isLeft, isTrue);
    expect(
      result.left,
      isA<HttpFailureResponse>()
          .having((err) => err.statusCode, 'statusCode', 400)
          .having((err) => err.error, 'error', {'error': 'Bad Request'}).having(
        (err) => err.path,
        'path',
        'http://fake.com',
      ),
    );
  });

  test('RestExternalInterface bytes rest request success response', () async {
    // for coverage purposes:
    RestExternalInterface(baseUrl: '', gatewayConnections: []);

    final testContent = {'foo': 'bar'};
    final restService = RestServiceFake(testContent);
    final gateWay = GatewayFake<TestBytesRestRequest, RestSuccessResponse>();
    RestExternalInterface(
      restService: restService,
      baseUrl: '',
      gatewayConnections: [() => gateWay],
    );

    final result = await gateWay.transport(const TestBytesRestRequest());
    expect(result.isRight, isTrue);
    expect(
      result.right,
      BytesRestSuccessResponse(
        data: Uint8List.fromList([]),
      ),
    );
  });

  tearDown(() {
    final ioFile = File(fileName);
    if (ioFile.existsSync()) ioFile.deleteSync();
  });
}

class TestBytesRestRequest extends BytesRestRequest {
  const TestBytesRestRequest() : super(method: RestMethod.get);
  @override
  String get path => 'http://fake.com';
}

class TestRequest extends GetRestRequest {
  @override
  String get path => 'http://fake.com';
}

class TestPostMultipartRequest extends PostMultiPartRestRequest {
  @override
  String get path => 'http://fake.com';
}

class TestBinarySrcPostRequest extends BinaryDataSrcPostRestRequest {
  @override
  String get path => 'http://fake.com';

  @override
  String get src => 'test/test_file.txt';
}

class TestBinarySrcPutRequest extends BinaryDataSrcPutRestRequest {
  @override
  String get path => 'http://fake.com';

  @override
  String get src => '';
}

class TestBinaryDataPostRequest extends BinaryDataPostRestRequest {
  @override
  String get path => 'http://fake.com';

  @override
  Uint8List get binaryData => Uint8List.fromList([]);
}

class TestBinaryDataPutRequest extends BinaryDataPutRestRequest {
  @override
  String get path => 'http://fake.com';

  @override
  Uint8List get binaryData => Uint8List.fromList([]);
}

class RestServiceFake extends Fake implements RestService {
  RestServiceFake(this._response);
  final Map<String, dynamic> _response;
  final Uint8List byteResponse = Uint8List.fromList([]);

  @override
  Future<T> request<T extends Object>({
    required RestMethod method,
    required String path,
    Map<String, dynamic> data = const {},
    Map<String, dynamic> headers = const {},
    Client? client,
  }) async {
    if (T == Uint8List) return byteResponse as T;
    if (_response.isEmpty) {
      throw InvalidResponseRestServiceFailure(
        error: {'error': 'Bad Request'},
        statusCode: 400,
        path: path,
      );
    }
    return {'foo': 'bar'} as T;
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
    if (_response['statusCode'] == 400) {
      throw InvalidResponseRestServiceFailure(
        error: {'error': 'Bad Request'},
        statusCode: 400,
        path: path,
      );
    }
    return {'foo': 'bar'};
  }

  @override
  Future<Map<String, dynamic>> multipartRequest<T extends Object>({
    required RestMethod method,
    required String path,
    Map<String, dynamic> data = const {},
    Map<String, String> headers = const {
      'Content-Type': 'multipart/form-data',
    },
    Client? client,
  }) async {
    if (_response.isEmpty) throw RestServiceFailure('Something went wrong');
    if (_response['statusCode'] == 400) {
      throw InvalidResponseRestServiceFailure(
        error: {'error': 'Bad Request'},
        statusCode: 400,
        path: path,
      );
    }
    return {'foo': 'bar'};
  }
}
