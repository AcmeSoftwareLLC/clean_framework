import 'package:clean_framework/clean_framework.dart';

class ConsoleLogger implements Logger {
  LogLevel _level;

  ConsoleLogger([this._level = LogLevel.nothing]);

  @override
  void setLogLevel(LogLevel level) => this._level = level;

  @override
  void fatal(message, [error, StackTrace? stackTrace]) {
    if (_level.index >= LogLevel.fatal.index)
      print('[FATAL]: $message ($error)');
  }

  @override
  void error(message, [error, StackTrace? stackTrace]) {
    if (_level.index >= LogLevel.error.index)
      print('[ERROR]: $message ($error)');
  }

  @override
  void warning(message, [error, StackTrace? stackTrace]) {
    if (_level.index >= LogLevel.warning.index)
      print('[WARNING]: $message ($error)');
  }

  @override
  void info(message, [error, StackTrace? stackTrace]) {
    if (_level.index >= LogLevel.info.index) print('[INFO]: $message ($error)');
  }

  @override
  void debug(message, [error, StackTrace? stackTrace]) {
    if (_level.index >= LogLevel.debug.index)
      print('[DEBUG]: $message ($error)');
  }

  @override
  void verbose(message, [error, StackTrace? stackTrace]) {
    if (_level.index >= LogLevel.verbose.index)
      print('[VERBOSE]: $message ($error)');
  }
}
