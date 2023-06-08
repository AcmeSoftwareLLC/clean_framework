import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_http/clean_framework_http.dart';

abstract class HttpRequest extends Request {
  const HttpRequest(this.method, {this.cancelToken});

  final HttpMethods method;
  final HttpCancelToken? cancelToken;

  String get path;

  Object? get data => null;

  Map<String, dynamic>? get queryParameters => null;

  String? get contentType => null;

  HttpResponseType? get responseType => null;

  HttpCachePolicy? get cachePolicy => null;

  Duration? get maxStale => null;
}

abstract class GetHttpRequest extends HttpRequest {
  const GetHttpRequest({super.cancelToken}) : super(HttpMethods.get);
}

abstract class PostHttpRequest extends HttpRequest {
  const PostHttpRequest({super.cancelToken}) : super(HttpMethods.post);
}

abstract class PatchHttpRequest extends HttpRequest {
  const PatchHttpRequest({super.cancelToken}) : super(HttpMethods.patch);
}

abstract class PutHttpRequest extends HttpRequest {
  const PutHttpRequest({super.cancelToken}) : super(HttpMethods.put);
}

abstract class HeadHttpRequest extends HttpRequest {
  const HeadHttpRequest({super.cancelToken}) : super(HttpMethods.head);
}

abstract class DeleteHttpRequest extends HttpRequest {
  const DeleteHttpRequest({super.cancelToken}) : super(HttpMethods.head);
}
