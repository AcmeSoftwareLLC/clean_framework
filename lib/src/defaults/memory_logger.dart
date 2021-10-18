import 'package:clean_framework/clean_framework.dart';

class MemoryLogger implements Logger {
  LogLevel _level;
  StringBuffer _logBuffer = StringBuffer('');

  MemoryLogger([this._level = LogLevel.verbose]);

  String get dump => _logBuffer.toString();

  void clear() => _logBuffer.clear();

  @override
  void setLogLevel(LogLevel level) => this._level = level;

  @override
  void fatal(message, [error, StackTrace? stackTrace]) {
    if (_level.index >= LogLevel.fatal.index)
      _logBuffer.write('[FATAL]: $message\n');
  }

  @override
  void error(message, [error, StackTrace? stackTrace]) {
    if (_level.index >= LogLevel.error.index)
      _logBuffer.write('[ERROR]: $message\n');
  }

  @override
  void warning(message, [error, StackTrace? stackTrace]) {
    if (_level.index >= LogLevel.warning.index)
      _logBuffer.write('[WARNING]: $message\n');
  }

  @override
  void info(message, [error, StackTrace? stackTrace]) {
    if (_level.index >= LogLevel.info.index)
      _logBuffer.write('[INFO]: $message\n');
  }

  @override
  void debug(message, [error, StackTrace? stackTrace]) {
    if (_level.index >= LogLevel.debug.index)
      _logBuffer.write('[DEBUG]: $message\n');
  }

  @override
  void verbose(message, [error, StackTrace? stackTrace]) {
    if (_level.index >= LogLevel.verbose.index)
      _logBuffer.write('[VERBOSE]: $message\n');
  }
}
