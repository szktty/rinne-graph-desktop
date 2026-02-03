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
