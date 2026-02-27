/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:logger/logger.dart';

/// Debug logging system.
/// Manages debug logs throughout the application.
class DebugLogger {
  static final DebugLogger _instance = DebugLogger._internal();
  factory DebugLogger() => _instance;
  DebugLogger._internal();

  late final Logger _logger;
  bool _isEnabled = false;

  /// Initializes the logger.
  void initialize({bool enabled = false}) {
    _isEnabled = enabled;
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: _isEnabled ? Level.debug : Level.off,
    );
  }

  /// Toggle debug logging on/off
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: _isEnabled ? Level.debug : Level.off,
    );
  }

  /// Outputs debug logs.
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    if (_isEnabled) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Outputs info logs.
  void info(String message, {Object? error, StackTrace? stackTrace}) {
    if (_isEnabled) {
      _logger.i(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Outputs warning logs.
  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    if (_isEnabled) {
      _logger.w(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Outputs error logs.
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (_isEnabled) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Outputs fatal error logs.
  void fatal(String message, {Object? error, StackTrace? stackTrace}) {
    if (_isEnabled) {
      _logger.f(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Debug log for stack operations.
  void logStackOperation(
    String operation,
    String stackName, {
    Map<String, dynamic>? details,
  }) {
    if (_isEnabled) {
      final message = 'Stack Operation: $operation - $stackName';
      if (details != null) {
        _logger.d('$message\nDetails: $details');
      } else {
        _logger.d(message);
      }
    }
  }

  /// Debug log for UI operations.
  void logUIOperation(
    String operation,
    String component, {
    Map<String, dynamic>? details,
  }) {
    if (_isEnabled) {
      final message = 'UI Operation: $operation - $component';
      if (details != null) {
        _logger.d('$message\nDetails: $details');
      } else {
        _logger.d(message);
      }
    }
  }

  /// Debug log for database operations.
  void logDatabaseOperation(String operation, {Map<String, dynamic>? details}) {
    if (_isEnabled) {
      final message = 'Database Operation: $operation';
      if (details != null) {
        _logger.d('$message\nDetails: $details');
      } else {
        _logger.d(message);
      }
    }
  }

  /// Debug log for performance measurement.
  void logPerformance(
    String operation,
    Duration duration, {
    Map<String, dynamic>? details,
  }) {
    if (_isEnabled) {
      final message =
          'Performance: $operation took ${duration.inMilliseconds}ms';
      if (details != null) {
        _logger.d('$message\nDetails: $details');
      } else {
        _logger.d(message);
      }
    }
  }

  /// Gets the current enabled state.
  bool get isEnabled => _isEnabled;
}

/// Global debug logger instance.
final debugLogger = DebugLogger();

/// Helper function for debug log output.
void debugLog(String message, {Object? error, StackTrace? stackTrace}) {
  debugLogger.debug(message, error: error, stackTrace: stackTrace);
}

/// Helper function for stack operation logs.
void logStackOp(
  String operation,
  String stackName, {
  Map<String, dynamic>? details,
}) {
  debugLogger.logStackOperation(operation, stackName, details: details);
}

/// Helper function for UI operation logs.
void logUIOperation(
  String operation,
  String component, {
  Map<String, dynamic>? details,
}) {
  debugLogger.logUIOperation(operation, component, details: details);
}
