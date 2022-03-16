import 'dart:convert';
import 'dart:typed_data';

import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(BaseRequestMock());
    registerFallbackValue(StreamedResponseMock());
  });

  test(
    'RestService | correct request for form url encoded POST request',
    () async {
      final service = RestService(baseUrl: 'https://fake.com');
      final client = ClientFake();

      await service.request(
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
        {'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'},
      );
      expect(client.request.method, 'POST');
      expect(client.request.url.toString(), 'https://fake.com/test');

      expect(client.request.bodyFields, {'foo': 'bar'});
      expect(client.request.body, 'foo=bar');
    },
  );

  test('RestService | correct request for json POST request', () async {
    final service = RestService(baseUrl: 'https://fake.com');
    final client = ClientFake();

    await service.request(
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
      {'Content-Type': 'application/json; charset=utf-8'},
    );
    expect(client.request.method, 'POST');
    expect(client.request.url.toString(), 'https://fake.com/test');

    expect(() => client.request.bodyFields, throwsStateError);
    expect(client.request.body, '{"foo":"bar"}');
  });

  test('RestService success', () async {
    final content = {"foo": "bar"};
    final service = RestService(baseUrl: 'http://fake.com');
    final client = ClientMock();
    final streamedResponse = StreamedResponseMock();
    final byteStream = ByteStream.fromBytes(
        Uint8List.fromList((json.encode(content).codeUnits)));

    when(() => client.send(any())).thenAnswer((_) async => streamedResponse);
    when(() => streamedResponse.stream).thenAnswer((_) => byteStream);
    when(() => streamedResponse.statusCode).thenReturn(200);
    when(() => streamedResponse.headers).thenReturn({});
    when(() => streamedResponse.isRedirect).thenReturn(false);
    when(() => streamedResponse.persistentConnection).thenReturn(false);

    final result = await service.request(
        method: RestMethod.get, path: '/', client: client);

    expect(result, {'foo': 'bar'});

    //for coverage purposes, we test a real Client
    expectLater(service.request(method: RestMethod.get, path: '/'),
        throwsA(isA<RestServiceFailure>()));
  });

  test('RestService success list', () async {
    final content = [
      {"foo": "bar"}
    ];
    final service = RestService(baseUrl: 'http://fake.com');
    final client = ClientMock();
    final streamedResponse = StreamedResponseMock();
    final byteStream = ByteStream.fromBytes(
        Uint8List.fromList((json.encode(content).codeUnits)));

    when(() => client.send(any())).thenAnswer((_) async => streamedResponse);
    when(() => streamedResponse.stream).thenAnswer((_) => byteStream);
    when(() => streamedResponse.statusCode).thenReturn(200);
    when(() => streamedResponse.headers).thenReturn({});
    when(() => streamedResponse.isRedirect).thenReturn(false);
    when(() => streamedResponse.persistentConnection).thenReturn(false);

    final result = await service.request(
        method: RestMethod.get, path: '/', client: client);

    expect(result, {
      'data': [
        {'foo': 'bar'}
      ]
    });
  });

  test('RestService no connectivity', () async {
    final service = RestService(baseUrl: 'http://fake.com');
    final client = ClientMock();

    when(() => client.send(any()))
        .thenThrow((_) async => ClientException('no connectivity'));

    expectLater(
        service.request(method: RestMethod.get, path: '/', client: client),
        throwsA(isA<RestServiceFailure>()));
  });

  test('RestService server error', () async {
    final content = {};
    final service = RestService(baseUrl: 'http://fake.com');
    final client = ClientMock();
    final streamedResponse = StreamedResponseMock();
    final byteStream = ByteStream.fromBytes(
        Uint8List.fromList((json.encode(content).codeUnits)));

    when(() => client.send(any())).thenAnswer((_) async => streamedResponse);
    when(() => streamedResponse.stream).thenAnswer((_) => byteStream);
    when(() => streamedResponse.statusCode).thenReturn(500);
    when(() => streamedResponse.headers).thenReturn({});
    when(() => streamedResponse.isRedirect).thenReturn(false);
    when(() => streamedResponse.persistentConnection).thenReturn(false);

    expectLater(
        service.request(method: RestMethod.get, path: '/', client: client),
        throwsA(isA<RestServiceFailure>()));
  });
}

class ClientMock extends Mock implements Client {}

class StreamedResponseMock extends Mock implements StreamedResponse {}

class BaseRequestMock extends Mock implements BaseRequest {}

class ClientFake extends Fake implements Client {
  late final Request request;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    this.request = request as Request;
    final contentBytes = jsonEncode({'foo': 'bar'}).codeUnits;
    return StreamedResponse(Stream.value(contentBytes), 200);
  }

  @override
  void close() {}
}
