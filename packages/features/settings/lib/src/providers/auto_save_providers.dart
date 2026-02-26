import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

part 'auto_save_providers.g.dart';

/// Model representing auto-save settings.
@immutable
class AutoSaveSettings {
  final bool enabled;
  final Duration interval;

  const AutoSaveSettings({required this.enabled, required this.interval});

  factory AutoSaveSettings.defaults() {
    return const AutoSaveSettings(
      enabled: true,
      interval: Duration(minutes: 5),
    );
  }

  AutoSaveSettings copyWith({bool? enabled, Duration? interval}) {
    return AutoSaveSettings(
      enabled: enabled ?? this.enabled,
      interval: interval ?? this.interval,
    );
  }
}

/// Provider for managing auto-save settings.
@riverpod
class AutoSaveSettingsNotifier extends _$AutoSaveSettingsNotifier {
  @override
  AutoSaveSettings build() {
    // TODO: Load from actual settings storage
    return AutoSaveSettings.defaults();
  }

  void updateSettings(AutoSaveSettings settings) {
    state = settings;
    // TODO: Save settings to storage
  }

  void setEnabled(bool enabled) {
    state = state.copyWith(enabled: enabled);
    // TODO: Save settings to storage
  }

  void setInterval(Duration interval) {
    state = state.copyWith(interval: interval);
    // TODO: Save settings to storage
  }
}
