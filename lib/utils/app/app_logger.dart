import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// A logger class that wraps the Logger from the logger package.
/// It provides methods to log messages at different levels
/// (debug, error, warning, info, trace, and fatal) only in debug mode.
final class AppLogger {
  static final Logger _logger = Logger();

  /// Logs a message at the debug level.
  static void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    time ??= DateTime.now();
    if (kDebugMode) {
      _logger.d(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  /// Logs a message at the error level.
  static void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    time ??= DateTime.now();
    if (kDebugMode) {
      _logger.e(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  /// Logs a message at the warning level.
  static void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    time ??= DateTime.now();
    if (kDebugMode) {
      _logger.w(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  /// Logs a message at the info level.
  static void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    time ??= DateTime.now();
    if (kDebugMode) {
      _logger.i(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  /// Logs a message at the trace level.
  static void t(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    time ??= DateTime.now();
    if (kDebugMode) {
      _logger.t(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  /// Logs a message at the fatal level.
  static void f(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    time ??= DateTime.now();
    if (kDebugMode) {
      _logger.f(message, time: time, error: error, stackTrace: stackTrace);
    }
  }
}
