import 'dart:convert';

import 'package:clean_framework/src/defaults/network_service.dart';
import 'package:http/http.dart';

class RestService extends NetworkService {
  RestService({
    String baseUrl = '',
    Map<String, String> headers = const {},
  }) : super(baseUrl: baseUrl, headers: headers);

  Future<Map<String, dynamic>> request({
    required RestMethod method,
    required String path,
    Map<String, dynamic> data = const {},
    Client? client,
  }) async {
    final _client = client ?? Client();
    var uri = _pathToUri(path);

    if (method == RestMethod.get) {
      uri = uri.replace(queryParameters: data);
    }

    final request = Request(method.rawString, uri);
    request.bodyFields = data.cast<String, String>();
    request.headers.addAll(headers!);

    try {
      final response = await Response.fromStream(await _client.send(request));

      final resultData = jsonDecode(response.body);

      if (resultData is Map<String, dynamic>) return resultData;
      return {'data': resultData};

      //TODO Enable the types of error we should consider later:
      // } on SocketException {
      //   print('No Internet connection 😑');
      // } on HttpException {
      //   print("Couldn't find the post 😱");
      // } on FormatException {
      //   print("Bad response format 👎");
    } catch (e) {
      print(e);
      throw RestServiceFailure;
    } finally {
      _client.close();
    }
  }

  Uri _pathToUri(String path) {
    String _url;
    if (baseUrl.isEmpty)
      _url = path;
    else
      _url = '$baseUrl/$path';
    return Uri.parse(_url);
  }
}

class RestServiceFailure {}
