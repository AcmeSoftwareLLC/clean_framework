abstract class Logger {
  void setLogLevel(LogLevel level);

  /// Log a message at level [Level.verbose].
  void verbose(dynamic message, [dynamic error, StackTrace stackTrace]);

  /// Log a message at level [Level.debug].
  void debug(dynamic message, [dynamic error, StackTrace stackTrace]);

  /// Log a message at level [Level.info].
  void info(dynamic message, [dynamic error, StackTrace stackTrace]);

  /// Log a message at level [Level.warning].
  void warning(dynamic message, [dynamic error, StackTrace stackTrace]);

  /// Log a message at level [Level.error].
  void error(dynamic message, [dynamic error, StackTrace stackTrace]);

  /// Log a message at level [Level.fatal].
  void fatal(dynamic message, [dynamic error, StackTrace stackTrace]);
}

enum LogLevel { nothing, fatal, error, warning, info, debug, verbose }
