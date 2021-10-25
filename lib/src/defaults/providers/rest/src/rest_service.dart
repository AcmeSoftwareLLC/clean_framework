import 'dart:convert';
import 'dart:io';

import 'package:clean_framework/src/defaults/network_service.dart';
import 'package:http/http.dart';

class RestService extends NetworkService {
  RestService({String baseUrl = '', Map<String, String> headers = const {}})
      : super(baseUrl: baseUrl, headers: headers);

  Future<Map<String, dynamic>> request({
    required RestMethod method,
    required String path,
    Map<String, dynamic>? data,
  }) async {
    final client = Client();
    var uri = _pathToUri(path);

    if (method == RestMethod.get) {
      uri = uri.replace(queryParameters: data);
    }

    final request = Request(method.rawString, uri);
    if (data != null) request.bodyFields = data.cast<String, String>();
    if (headers != null) request.headers.addAll(headers!);

    try {
      final response = await Response.fromStream(await client.send(request));

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
    } on Exception {
      throw RestServiceFailure;
    } finally {
      client.close();
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
