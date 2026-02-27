/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// A class representing settings-related exceptions.
class SettingsException implements Exception {
  const SettingsException(this.message);

  final String message;

  @override
  String toString() => 'SettingsException: $message';
}

/// Exception thrown when loading the settings file fails.
class SettingsLoadException extends SettingsException {
  const SettingsLoadException(super.message, {this.cause});

  final Object? cause;
}

/// Exception thrown when saving the settings file fails.
class SettingsSaveException extends SettingsException {
  const SettingsSaveException(super.message, {this.cause});

  final Object? cause;
}
