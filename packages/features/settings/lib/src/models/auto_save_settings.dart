/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

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
