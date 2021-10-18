import 'dart:convert';

import 'package:clean_framework/src/defaults/network_service.dart';
import 'package:http/http.dart';

class RestService extends NetworkService {
  RestService({String? baseUrl, Map<String, String>? headers})
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

    final response = await Response.fromStream(await client.send(request));
    client.close();

    final resultData = jsonDecode(response.body);

    if (resultData is Map<String, dynamic>) return resultData;
    return {'data': resultData};
  }

  Uri _pathToUri(String path) {
    String _url;
    if (baseUrl == null) _url = path;
    _url = '$baseUrl/$path';
    return Uri.parse(_url);
  }
}
