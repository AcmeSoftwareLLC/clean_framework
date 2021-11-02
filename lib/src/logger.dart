abstract class Logger {
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

enum LogLevel { nothing, fatal, error, warning, info, debug, verbose }
