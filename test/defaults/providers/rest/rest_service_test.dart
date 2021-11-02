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
