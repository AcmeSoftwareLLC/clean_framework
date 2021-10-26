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
  });
}

class ClientMock extends Mock implements Client {}

class StreamedResponseMock extends Mock implements StreamedResponse {}

class BaseRequestMock extends Mock implements BaseRequest {}
