import 'dart:convert';
import 'dart:typed_data';

import 'package:clean_framework_rest/src/rest_logger.dart';
import 'package:clean_framework_rest/src/rest_method.dart';
import 'package:clean_framework_rest/src/rest_service_options.dart';
import 'package:cross_file/cross_file.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';

///
class RestService {
  /// Default constructor for [RestService].
  RestService({this.options = const RestServiceOptions()});

  /// The configurable options to be sent with the request.
  final RestServiceOptions options;

  Future<T> request<T extends Object>({
    required RestMethod method,
    required String path,
    Map<String, dynamic> data = const {},
    Map<String, String> headers = const {},
    Client? client,
  }) async {
    final resolvedClient = RestLoggerClient(client ?? Client());

    var uri = _pathToUri(path);

    if (method == RestMethod.get) {
      uri = uri.replace(queryParameters: data);
    }

    try {
      final request = Request(method.value, uri);

      if (headers['Content-Type'] == 'application/x-www-form-urlencoded') {
        request.bodyFields = data.map((k, v) => MapEntry(k, v.toString()));
      } else {
        request.body = jsonEncode(data);
      }

      request.headers
        ..addAll(await options.headers)
        ..addAll(headers);

      final response = await resolvedClient.send(request);

      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 299) {
        throw InvalidResponseRestServiceFailure(
          path: uri.toString(),
          error: parseResponse(response),
          statusCode: statusCode,
        );
      }
      if (T == Map<String, dynamic>) {
        final resData = parseResponse(response);
        return resData as T;
      } else if (T == Uint8List || T == List<int>) {
        return response.bodyBytes as T;
      } else {
        throw StateError('The type $T is not supported by request');
      }
    } on InvalidResponseRestServiceFailure {
      rethrow;
    } catch (e) {
      throw RestServiceFailure(e.toString());
    } finally {
      resolvedClient.close();
    }
  }

  Future<Map<String, dynamic>> multipartRequest<T extends Object>({
    required RestMethod method,
    required String path,
    Map<String, dynamic> data = const {},
    Map<String, String> headers = const {},
    Client? client,
  }) async {
    final resolvedClient = client ?? Client();

    final uri = _pathToUri(path);

    try {
      final request = MultipartRequest(method.value, uri);
      for (final entry in data.entries) {
        final k = entry.key;
        final v = entry.value;
        if (v is XFile) {
          final stream = ByteStream(v.openRead());
          final length = await v.length();
          final multipartFile = MultipartFile(
            k,
            stream,
            length,
            filename: basename(v.path),
          );

          request.files.add(multipartFile);
        } else if (v is String) {
          request.fields[k] = v;
        }
      }
      request.headers
        ..addAll(await options.headers)
        ..addAll({'Content-Type': 'multipart/form-data'})
        ..addAll(headers);

      final streamedResponse = await resolvedClient.send(request);
      final response = await Response.fromStream(streamedResponse);

      final statusCode = streamedResponse.statusCode;
      final resData = parseResponse(response);

      if (statusCode < 200 || statusCode > 299) {
        throw InvalidResponseRestServiceFailure(
          path: uri.toString(),
          error: resData,
          statusCode: statusCode,
        );
      }
      return resData;
    } on InvalidResponseRestServiceFailure {
      rethrow;
    } catch (e) {
      throw RestServiceFailure(e.toString());
    } finally {
      resolvedClient.close();
    }
  }

  Future<Map<String, dynamic>> binaryRequest({
    required RestMethod method,
    required String path,
    required List<int> data,
    Map<String, String> headers = const {},
    Client? client,
  }) async {
    final resolvedClient = client ?? Client();
    final uri = _pathToUri(path);

    try {
      final request = Request(method.value, uri)..bodyBytes = data;

      request.headers
        ..addAll(await options.headers)
        ..addAll(headers);

      final response =
          await Response.fromStream(await resolvedClient.send(request));

      final statusCode = response.statusCode;
      final resData = parseResponse(response);

      if (statusCode < 200 || statusCode > 299) {
        throw InvalidResponseRestServiceFailure(
          path: uri.toString(),
          error: resData,
          statusCode: statusCode,
        );
      }
      return resData;
    } on InvalidResponseRestServiceFailure {
      rethrow;
    } catch (e) {
      throw RestServiceFailure(e.toString());
    } finally {
      resolvedClient.close();
    }
  }

  Map<String, dynamic> parseResponse(Response response) {
    final resBody = response.body;
    final resData = resBody.isEmpty ? resBody : jsonDecode(resBody);
    if (resData is Map<String, dynamic>) return resData;
    return {'data': resData};
  }

  Uri _pathToUri(String path) {
    final baseUrl = options.baseUrl;
    final url = baseUrl.isEmpty ? path : '$baseUrl/$path';

    return Uri.parse(url);
  }
}

class RestServiceFailure {
  RestServiceFailure([this.message]);

  final String? message;
}

class InvalidResponseRestServiceFailure extends RestServiceFailure {
  InvalidResponseRestServiceFailure({
    required this.path,
    required this.error,
    required this.statusCode,
  });

  final String path;
  final int statusCode;
  final Map<String, dynamic> error;
}
