import 'package:clean_framework/src/utilities/logging/logging_utility.dart';
import 'package:logger/logger.dart';

class LoggerUtility extends LoggingUtility {
  LoggerUtility({
    required this.logger,
  });

  final Logger logger;

  @override
  void d(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      logger.d(
        message,
        time: time,
        error: error,
        stackTrace: stackTrace,
      );

  @override
  void e(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      logger.e(
        message,
        time: time,
        error: error,
        stackTrace: stackTrace,
      );

  @override
  void f(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      logger.f(
        message,
        time: time,
        error: error,
        stackTrace: stackTrace,
      );

  @override
  void i(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      logger.i(
        message,
        time: time,
        error: error,
        stackTrace: stackTrace,
      );

  @override
  void t(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      logger.t(
        message,
        time: time,
        error: error,
        stackTrace: stackTrace,
      );

  @override
  void w(
    Object? message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      logger.w(
        message,
        time: time,
        error: error,
        stackTrace: stackTrace,
      );
}
