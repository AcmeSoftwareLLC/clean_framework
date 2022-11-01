enum GraphQLErrorPolicy {
  /// Any GraphQL Errors are treated the same as network errors
  /// and any data is ignored from the response. (default)
  none,

  /// Ignore allows you to read any data that is returned alongside
  /// GraphQL Errors, but doesn't save the errors or report them to your UI.
  ignore,

  /// Saves both data and errors into the `cache` so your UI can use them.
  ///
  ///  It is recommended for notifying your users of potential issues,
  ///  while still showing as much data as possible from your server.
  all,
}
