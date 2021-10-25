enum RestMethod {
  get,
  post,
  put,
  delete,
  patch,
}

enum GraphQLMethod {
  query,
  mutation,
}

extension RestMethodExt on RestMethod {
  String get rawString {
    switch (this) {
      case RestMethod.get:
        return 'GET';
      case RestMethod.post:
        return 'POST';
      case RestMethod.put:
        return 'PUT';
      case RestMethod.delete:
        return 'DELETE';
      case RestMethod.patch:
        return 'PATCH';
    }
  }
}

abstract class NetworkService {
  final String? baseUrl;
  final Map<String, String>? headers;

  NetworkService({required this.baseUrl, this.headers})
      : assert(
          () {
            return baseUrl == null || !baseUrl.endsWith('/');
          }(),
          'Base URl must not end with "/"',
        );
}
