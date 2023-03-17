import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_http/src/http_methods.dart';

abstract class HttpRequest extends Request {
  const HttpRequest(this.method);

  final HttpMethods method;

  String get path;

  Object? get data;

  Map<String, dynamic>? get queryParameters;
}

abstract class GetHttpRequest extends HttpRequest {
  const GetHttpRequest() : super(HttpMethods.get);
}
