// coverage:ignore-file

/// Different error codes that can be returned by the [FeatureProvider].
enum ErrorCode {
  /// Provider is not in ready state.
  providerNotReady('PROVIDER_NOT_READY'),

  /// The provided flag could not be found.
  flagNotFound('FLAG_NOT_FOUND'),

  /// The error could not be parsed.
  parseError('PARSE_ERROR'),

  /// The provided flag or value type do not match.
  typeMismatch('TYPE_MISMATCH'),

  /// General Errors.
  general('GENERAL');

  /// Default constructor.
  const ErrorCode(this.rawCode);

  /// The raw code of the error.
  final String rawCode;
}
