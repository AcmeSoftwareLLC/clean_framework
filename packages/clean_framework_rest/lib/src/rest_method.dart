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
