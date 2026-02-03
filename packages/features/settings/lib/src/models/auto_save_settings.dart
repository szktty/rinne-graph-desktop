/// A model that represents the auto-save settings.
class AutoSaveSettings {
  const AutoSaveSettings({
    this.enabled = false,
    this.interval = const Duration(minutes: 5),
  });

  /// Whether auto-save is enabled.
  final bool enabled;

  /// The interval for auto-save.
  final Duration interval;

  /// Returns an instance updated with the new settings.
  AutoSaveSettings copyWith({bool? enabled, Duration? interval}) {
    return AutoSaveSettings(
      enabled: enabled ?? this.enabled,
      interval: interval ?? this.interval,
    );
  }
}
