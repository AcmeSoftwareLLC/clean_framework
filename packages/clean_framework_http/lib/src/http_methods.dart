enum HttpMethods {
  get('GET'),
  post('POST'),
  put('PUT'),
  head('HEAD'),
  delete('DELETE'),
  patch('PATCH');

  const HttpMethods(this.name);

  final String name;
}
