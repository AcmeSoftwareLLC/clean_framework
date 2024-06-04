/// Abstract class that provides for logging using any package or class.
abstract class LoggingUtility {
  /// Trace log.
  void t(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  });

  /// Info log.
  void i(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  });

  /// Debug log.
  void d(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  });

  /// Warning log.
  void w(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  });

  /// Error log.
  void e(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  });

  /// Fatal log.
  void f(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  });
}
