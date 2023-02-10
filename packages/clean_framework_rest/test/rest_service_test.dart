import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:clean_framework_rest/clean_framework_rest.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late String fileName;
  late XFile file;

  setUp(() {
    fileName = 'test/test_file_${DateTime.now()}.txt';
    File(fileName).createSync();
    file = XFile(fileName);
  });

  setUpAll(() {
    registerFallbackValue(BaseRequestMock());
    registerFallbackValue(StreamedResponseMock());
  });

  test(
    'RestService | correct request for multipart form POST request',
    () async {
      final service = RestService(
        options: const RestServiceOptions(baseUrl: 'https://fake.com'),
      );
      final client = ClientFake();

      await service.multipartRequest<Map<String, dynamic>>(
        method: RestMethod.post,
        path: 'multipart/test',
        client: client,
        data: {
          'foo': 'bar',
          'file': file,
        },
      );

      expect(
        client.multipartRequest.headers,
        {'Content-Type': 'multipart/form-data'},
      );
      expect(client.multipartRequest.method, 'POST');
      expect(
        client.multipartRequest.url.toString(),
        'https://fake.com/multipart/test',
      );

      expect(client.multipartRequest.fields, {'foo': 'bar'});
      expect(client.multipartRequest.files.length, 1);
      expect(client.multipartRequest.files[0].length, await file.length());
      expect(client.multipartRequest.files[0].field, 'file');
    },
  );

  test('RestService no connectivity for multipart request', () async {
    final service = RestService(
      options: const RestServiceOptions(baseUrl: 'https://fake.com'),
    );
    final client = ClientMock();

    when(() => client.send(any()))
        .thenThrow((_) async => ClientException('no connectivity'));

    await expectLater(
      service.multipartRequest<Map<String, dynamic>>(
        method: RestMethod.post,
        path: '/',
        client: client,
      ),
      throwsA(isA<RestServiceFailure>()),
    );

    //for coverage purposes, we test a real Client
    await expectLater(
      service.multipartRequest(
        method: RestMethod.post,
        path: '/',
        data: {},
      ),
      throwsA(isA<RestServiceFailure>()),
    );
  });

  test('RestService server error | multipart request', () async {
    final content = {'error': 'testError'};
    final service = RestService(
      options: const RestServiceOptions(baseUrl: 'https://fake.com'),
    );
    final client = ClientMock();
    final streamedResponse = StreamedResponseMock();
    final byteStream = ByteStream.fromBytes(
      Uint8List.fromList(json.encode(content).codeUnits),
    );

    when(() => client.send(any())).thenAnswer((_) async => streamedResponse);
    when(() => streamedResponse.stream).thenAnswer((_) => byteStream);
    when(() => streamedResponse.statusCode).thenReturn(500);
    when(() => streamedResponse.headers).thenReturn({});
    when(() => streamedResponse.isRedirect).thenReturn(false);
    when(() => streamedResponse.persistentConnection).thenReturn(false);

    await expectLater(
      service.multipartRequest<Map<String, dynamic>>(
        method: RestMethod.post,
        path: 'test',
        client: client,
      ),
      throwsA(
        isA<InvalidResponseRestServiceFailure>()
            .having((res) => res.statusCode, 'statusCode', 500)
            .having((res) => res.path, 'path', 'https://fake.com/test')
            .having((res) => res.error, 'error', content),
      ),
    );
  });

  test(
    'RestService | correct request for form url encoded POST request',
    () async {
      final service = RestService(
        options: const RestServiceOptions(baseUrl: 'https://fake.com'),
      );
      final client = ClientFake();

      await service.request<Map<String, dynamic>>(
        method: RestMethod.post,
        path: 'test',
        client: client,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        data: {'foo': 'bar'},
      );

      expect(
        client.request.headers,
        {'content-type': 'application/x-www-form-urlencoded'},
      );
      expect(client.request.method, 'POST');
      expect(client.request.url.toString(), 'https://fake.com/test');

      expect(client.request.bodyFields, {'foo': 'bar'});
      expect(client.request.body, 'foo=bar');
    },
  );

  test('RestService | correct request for json POST request', () async {
    final service = RestService(
      options: const RestServiceOptions(baseUrl: 'https://fake.com'),
    );
    final client = ClientFake();

    await service.request<Map<String, dynamic>>(
      method: RestMethod.post,
      path: 'test',
      client: client,
      headers: {
        'Content-Type': 'application/json',
      },
      data: {'foo': 'bar'},
    );

    expect(
      client.request.headers,
      {'content-type': 'application/json'},
    );
    expect(client.request.method, 'POST');
    expect(client.request.url.toString(), 'https://fake.com/test');

    expect(() => client.request.bodyFields, throwsStateError);
    expect(client.request.body, '{"foo":"bar"}');
  });

  test('RestService success', () async {
    final content = {'foo': 'bar'};
    final service = RestService(
      options: const RestServiceOptions(baseUrl: 'https://fake.com'),
    );
    final client = ClientMock();
    final streamedResponse = StreamedResponseMock();
    final byteStream = ByteStream.fromBytes(
      Uint8List.fromList(json.encode(content).codeUnits),
    );

    when(() => client.send(any())).thenAnswer((_) async => streamedResponse);
    when(() => streamedResponse.stream).thenAnswer((_) => byteStream);
    when(() => streamedResponse.statusCode).thenReturn(200);
    when(() => streamedResponse.headers).thenReturn({});
    when(() => streamedResponse.isRedirect).thenReturn(false);
    when(() => streamedResponse.persistentConnection).thenReturn(false);

    final result = await service.request<Map<String, dynamic>>(
      method: RestMethod.get,
      path: '/',
      client: client,
    );

    expect(result, {'foo': 'bar'});

    //for coverage purposes, we test a real Client
    await expectLater(
      service.request<Map<String, dynamic>>(
        method: RestMethod.get,
        path: '/',
      ),
      throwsA(isA<RestServiceFailure>()),
    );
  });

  test('RestService success list', () async {
    final content = [
      {'foo': 'bar'}
    ];
    final service = RestService(
      options: const RestServiceOptions(baseUrl: 'https://fake.com'),
    );
    final client = ClientMock();
    final streamedResponse = StreamedResponseMock();
    final byteStream = ByteStream.fromBytes(
      Uint8List.fromList(json.encode(content).codeUnits),
    );

    when(() => client.send(any())).thenAnswer((_) async => streamedResponse);
    when(() => streamedResponse.stream).thenAnswer((_) => byteStream);
    when(() => streamedResponse.statusCode).thenReturn(200);
    when(() => streamedResponse.headers).thenReturn({});
    when(() => streamedResponse.isRedirect).thenReturn(false);
    when(() => streamedResponse.persistentConnection).thenReturn(false);

    final result = await service.request<Map<String, dynamic>>(
      method: RestMethod.get,
      path: '/',
      client: client,
    );

    expect(result, {
      'data': [
        {'foo': 'bar'}
      ]
    });
  });

  test('RestService no connectivity', () async {
    final service = RestService(
      options: const RestServiceOptions(baseUrl: 'https://fake.com'),
    );
    final client = ClientMock();

    when(() => client.send(any()))
        .thenThrow((_) async => ClientException('no connectivity'));

    await expectLater(
      service.request<Map<String, dynamic>>(
        method: RestMethod.get,
        path: '/',
        client: client,
      ),
      throwsA(isA<RestServiceFailure>()),
    );
  });

  test('RestService server error', () async {
    final content = {'error': 'testError'};
    final service = RestService(
      options: const RestServiceOptions(baseUrl: 'https://fake.com'),
    );
    final client = ClientMock();
    final streamedResponse = StreamedResponseMock();
    final byteStream = ByteStream.fromBytes(
      Uint8List.fromList(json.encode(content).codeUnits),
    );

    when(() => client.send(any())).thenAnswer((_) async => streamedResponse);
    when(() => streamedResponse.stream).thenAnswer((_) => byteStream);
    when(() => streamedResponse.statusCode).thenReturn(500);
    when(() => streamedResponse.headers).thenReturn({});
    when(() => streamedResponse.isRedirect).thenReturn(false);
    when(() => streamedResponse.persistentConnection).thenReturn(false);

    await expectLater(
      service.request<Map<String, dynamic>>(
        method: RestMethod.post,
        path: 'test',
        client: client,
      ),
      throwsA(
        isA<InvalidResponseRestServiceFailure>()
            .having((res) => res.statusCode, 'statusCode', 500)
            .having((res) => res.path, 'path', 'https://fake.com/test')
            .having((res) => res.error, 'error', content),
      ),
    );
  });

  test('RestService binary request success', () async {
    final content = {'foo': 'bar'};
    final service = RestService(
      options: const RestServiceOptions(baseUrl: 'https://fake.com'),
    );
    final client = ClientMock();
    final streamedResponse = StreamedResponseMock();
    final byteStream = ByteStream.fromBytes(
      Uint8List.fromList(json.encode(content).codeUnits),
    );

    when(() => client.send(any())).thenAnswer((_) async => streamedResponse);
    when(() => streamedResponse.stream).thenAnswer((_) => byteStream);
    when(() => streamedResponse.statusCode).thenReturn(200);
    when(() => streamedResponse.headers).thenReturn({});
    when(() => streamedResponse.isRedirect).thenReturn(false);
    when(() => streamedResponse.persistentConnection).thenReturn(false);

    final result = await service.binaryRequest(
      method: RestMethod.post,
      path: '/',
      client: client,
      data: [],
    );

    expect(result, {'foo': 'bar'});

    //for coverage purposes, we test a real Client
    await expectLater(
      service.binaryRequest(
        method: RestMethod.post,
        path: '/',
        data: [],
      ),
      throwsA(isA<RestServiceFailure>()),
    );
  });

  test('RestService binary request server error', () async {
    final content = {'error': 'testError'};
    final service = RestService(
      options: const RestServiceOptions(baseUrl: 'https://fake.com'),
    );
    final client = ClientMock();
    final streamedResponse = StreamedResponseMock();
    final byteStream = ByteStream.fromBytes(
      Uint8List.fromList(json.encode(content).codeUnits),
    );

    when(() => client.send(any())).thenAnswer((_) async => streamedResponse);
    when(() => streamedResponse.stream).thenAnswer((_) => byteStream);
    when(() => streamedResponse.statusCode).thenReturn(500);
    when(() => streamedResponse.headers).thenReturn({});
    when(() => streamedResponse.isRedirect).thenReturn(false);
    when(() => streamedResponse.persistentConnection).thenReturn(false);

    await expectLater(
      service.binaryRequest(
        method: RestMethod.post,
        path: 'test',
        client: client,
        data: [],
      ),
      throwsA(
        isA<InvalidResponseRestServiceFailure>()
            .having((res) => res.statusCode, 'statusCode', 500)
            .having((res) => res.path, 'path', 'https://fake.com/test')
            .having((res) => res.error, 'error', content),
      ),
    );
  });

  test('RestService success, binary bytes response', () async {
    final content = {'foo': 'bar'};
    final service = RestService(
      options: const RestServiceOptions(baseUrl: 'https://fake.com'),
    );
    final client = ClientMock();
    final streamedResponse = StreamedResponseMock();
    final byteStream = ByteStream.fromBytes(
      Uint8List.fromList(
        json.encode(content).codeUnits,
      ),
    );

    when(() => client.send(any())).thenAnswer((_) async => streamedResponse);
    when(() => streamedResponse.stream).thenAnswer((_) => byteStream);
    when(() => streamedResponse.statusCode).thenReturn(200);
    when(() => streamedResponse.headers).thenReturn({});
    when(() => streamedResponse.isRedirect).thenReturn(false);
    when(() => streamedResponse.persistentConnection).thenReturn(false);

    final result = await service.request<Uint8List>(
      method: RestMethod.get,
      path: '/',
      client: client,
    );

    expect(
      result,
      Uint8List.fromList(
        json.encode(content).codeUnits,
      ),
    );
  });

  test('RestService success, unknown request type', () async {
    final content = {'foo': 'bar'};
    final service = RestService(
      options: const RestServiceOptions(baseUrl: 'https://fake.com'),
    );
    final client = ClientMock();
    final streamedResponse = StreamedResponseMock();
    final byteStream = ByteStream.fromBytes(
      Uint8List.fromList(
        json.encode(content).codeUnits,
      ),
    );

    when(() => client.send(any())).thenAnswer((_) async => streamedResponse);
    when(() => streamedResponse.stream).thenAnswer((_) => byteStream);
    when(() => streamedResponse.statusCode).thenReturn(200);
    when(() => streamedResponse.headers).thenReturn({});
    when(() => streamedResponse.isRedirect).thenReturn(false);
    when(() => streamedResponse.persistentConnection).thenReturn(false);

    expect(
      service.request<String>(
        method: RestMethod.get,
        path: '/',
        client: client,
      ),
      throwsA(const TypeMatcher<RestServiceFailure>()),
    );
  });

  tearDown(() {
    final ioFile = File(fileName);
    if (ioFile.existsSync()) ioFile.deleteSync();
  });
}

class ClientMock extends Mock implements Client {}

class StreamedResponseMock extends Mock implements StreamedResponse {}

class BaseRequestMock extends Mock implements BaseRequest {}

class ClientFake extends Fake implements Client {
  late final Request request;
  late final MultipartRequest multipartRequest;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    if (request is Request) {
      this.request = request;
    } else if (request is MultipartRequest) {
      multipartRequest = request;
    }
    final contentBytes = jsonEncode({'foo': 'bar'}).codeUnits;
    return StreamedResponse(Stream.value(contentBytes), 200);
  }

  @override
  void close() {}
}
