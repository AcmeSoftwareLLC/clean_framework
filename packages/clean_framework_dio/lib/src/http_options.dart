class HttpOptions {
  const HttpOptions({
    this.baseUrl = '',
    this.connectTimeout,
    this.receiveTimeout,
    this.sendTimeout,
    this.validateStatus,
  });

  final String baseUrl;

  /// Timeout for opening url.
  final Duration? connectTimeout;

  /// Timeout for receiving data.
  final Duration? receiveTimeout;

  /// Timeout for sending data.
  final Duration? sendTimeout;

  /// `validateStatus` defines whether the request is successful for a given
  /// HTTP response status code. If `validateStatus` returns `true` ,
  /// the request will be perceived as successful;
  /// otherwise, considered as failed.
  final bool Function(int? status)? validateStatus;
}
