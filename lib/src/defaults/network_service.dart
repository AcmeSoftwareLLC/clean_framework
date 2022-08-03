// coverage:ignore-start
/// The types of HTTP methods.
enum RestMethod {
// coverage:ignore-end
  /// GET
  get('GET'),

  /// POST
  post('POST'),

  /// PUT
  put('PUT'),

  /// DELETE
  delete('DELETE'),

  /// PATCH
  patch('PATCH');

  /// Default constructor.
  const RestMethod(this.value);

  /// The HTTP method name.
  final String value;
}

/// The types of GraphQL operations.
enum GraphQLMethod {
  /// Query
  query,

  /// Mutation
  mutation,
}

///
abstract class NetworkService {
  /// Default constructor for [NetworkService].
  NetworkService({required this.baseUrl, this.headers})
      : assert(
          () {
            return !baseUrl.endsWith('/');
          }(),
          'Base URl must not be empty or end with "/"',
        );

  /// The base URL of the service.
  final String baseUrl;

  /// The global headers to be sent with the request.
  final Map<String, String>? headers;
}
