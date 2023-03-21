import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_http/clean_framework_http.dart';

abstract class HttpRequest extends Request {
  const HttpRequest(this.method);

  final HttpMethods method;

  String get path;

  Object? get data => null;

  Map<String, dynamic>? get queryParameters => null;

  String? get contentType => null;

  HttpResponseType? get responseType => null;
}

abstract class GetHttpRequest extends HttpRequest {
  const GetHttpRequest() : super(HttpMethods.get);
}

abstract class PostHttpRequest extends HttpRequest {
  const PostHttpRequest() : super(HttpMethods.post);
}

abstract class PatchHttpRequest extends HttpRequest {
  const PatchHttpRequest() : super(HttpMethods.patch);
}

abstract class PutHttpRequest extends HttpRequest {
  const PutHttpRequest() : super(HttpMethods.put);
}

abstract class HeadHttpRequest extends HttpRequest {
  const HeadHttpRequest() : super(HttpMethods.head);
}

abstract class DeleteHttpRequest extends HttpRequest {
  const DeleteHttpRequest() : super(HttpMethods.head);
}
