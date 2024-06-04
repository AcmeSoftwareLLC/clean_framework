import 'dart:developer';

/// Interface for a logger.
interface class Logger {
  const Logger();

  /// Log a new critical message.
  void c(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(message.toString(), time: time, error: error, stackTrace: stackTrace);
  }

  /// Log a new debug message.
  void d(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(message.toString(), time: time, error: error, stackTrace: stackTrace);
  }

  /// Log a new error message.
  void e(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(message.toString(), time: time, error: error, stackTrace: stackTrace);
  }

  /// Log a new info message.
  void i(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(message.toString(), time: time, error: error, stackTrace: stackTrace);
  }

  /// Log a new verbose message
  void v(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(message.toString(), time: time, error: error, stackTrace: stackTrace);
  }

  /// Log a new warning message.
  void w(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(message.toString(), time: time, error: error, stackTrace: stackTrace);
  }
}
