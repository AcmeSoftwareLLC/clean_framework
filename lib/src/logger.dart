/// The Logger.
abstract class Logger {
  /// Sets the log [level].
  void setLogLevel(LogLevel level);

  /// Log a message at level [LogLevel.verbose].
  void verbose(dynamic message, [dynamic error, StackTrace stackTrace]);

  /// Log a message at level [LogLevel.debug].
  void debug(dynamic message, [dynamic error, StackTrace stackTrace]);

  /// Log a message at level [LogLevel.info].
  void info(dynamic message, [dynamic error, StackTrace stackTrace]);

  /// Log a message at level [LogLevel.warning].
  void warning(dynamic message, [dynamic error, StackTrace stackTrace]);

  /// Log a message at level [LogLevel.error].
  void error(dynamic message, [dynamic error, StackTrace stackTrace]);

  /// Log a message at level [LogLevel.fatal].
  void fatal(dynamic message, [dynamic error, StackTrace stackTrace]);
}

/// The log levels.
enum LogLevel {
  /// No logs.
  nothing,

  /// Fatal logs.
  fatal,

  /// Error logs.
  error,

  /// Warning logs.
  warning,

  /// Informational logs.
  info,

  /// Debug logs.
  debug,

  /// Verbose logs.
  verbose,
}
