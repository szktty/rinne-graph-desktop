/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// Class representing stack-specific settings (`meta/settings.json`)
class StackSettings {
  // For future schema functionality

  const StackSettings({
    this.defaultView,
    this.autoBackupEnabled = false,
    this.autoBackupInterval = 86400,
    this.customFields = const {},
  });

  factory StackSettings.fromJson(Map<String, dynamic> json) {
    return StackSettings(
      defaultView: json['defaultView'] as String?,
      autoBackupEnabled: json['autoBackupEnabled'] as bool? ?? false,
      autoBackupInterval: json['autoBackupInterval'] as int? ?? 86400,
      // Read customFields as a Map directly
      customFields: (json['customFields'] as Map<String, dynamic>?) ?? {},
    );
  }
  final String? defaultView;
  final bool autoBackupEnabled;
  final int autoBackupInterval; // seconds
  final Map<String, dynamic> customFields;

  Map<String, dynamic> toJson() {
    return {
      if (defaultView != null) 'defaultView': defaultView,
      'autoBackupEnabled': autoBackupEnabled,
      'autoBackupInterval': autoBackupInterval,
      'customFields': customFields,
    };
  }

  StackSettings copyWith({
    String? defaultView,
    bool? autoBackupEnabled,
    int? autoBackupInterval,
    Map<String, dynamic>? customFields,
  }) {
    return StackSettings(
      defaultView: defaultView ?? this.defaultView,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      autoBackupInterval: autoBackupInterval ?? this.autoBackupInterval,
      customFields: customFields ?? this.customFields,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StackSettings &&
          runtimeType == other.runtimeType &&
          defaultView == other.defaultView &&
          autoBackupEnabled == other.autoBackupEnabled &&
          autoBackupInterval == other.autoBackupInterval &&
          // Using MapEquality is more robust, but here we compare simply
          _mapEquals(customFields, other.customFields);

  @override
  int get hashCode => Object.hash(
    runtimeType,
    defaultView,
    autoBackupEnabled,
    autoBackupInterval,
    // Map hashCode (based on key and value hash codes)
    customFields.entries
        .map((e) => Object.hash(e.key, e.value))
        .fold<int>(0, (prev, hash) => prev ^ hash),
  );

  // Helper for simple Map comparison
  bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (final k in a.keys) {
      if (!b.containsKey(k) || a[k] != b[k]) {
        return false;
      }
    }
    return true;
  }

  @override
  String toString() {
    return 'StackSettings(${toJson()})';
  }
}
