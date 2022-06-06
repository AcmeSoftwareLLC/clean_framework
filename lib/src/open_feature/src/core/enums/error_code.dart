enum ErrorCode {
  providerNotReady('PROVIDER_NOT_READY'),
  flagNotFound('FLAG_NOT_FOUND'),
  parseError('PARSE_ERROR'),
  typeMismatch('TYPE_MISMATCH'),
  general('GENERAL');

  const ErrorCode(this.rawCode);

  final String rawCode;
}
