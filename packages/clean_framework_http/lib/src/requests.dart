import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_http/clean_framework_http.dart';

/// The HTTP Request methods.
abstract class HttpRequest extends Request {
  /// Creates a new [HttpRequest] with the given [method] and [cancelToken].
  const HttpRequest(this.method, {this.cancelToken});

  /// The HTTP method to be used.
  final HttpMethods method;

  /// The token to cancel the request.
  final HttpCancelToken? cancelToken;

  /// The path of the request.
  String get path;

  /// The data to be included in the request.
  Object? get data => null;

  /// Query parameters to be included in the request.
  Map<String, dynamic>? get queryParameters => null;

  /// The content type of the request.
  String? get contentType => null;

  /// The type of response expected.
  HttpResponseType? get responseType => null;

  /// The cache policy to be used.
  HttpCachePolicy? get cachePolicy => null;

  /// The maximum time that the cache can be used.
  Duration? get maxStale => null;

  /// Headers to be included in the request.
  Map<String, String> get headers => {};

  /// If true, the cache will be refreshed.
  ///
  /// [cachePolicy] must be null.
  bool get refresh => false;
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
  const DeleteHttpRequest({super.cancelToken}) : super(HttpMethods.delete);
}
