/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// A class representing accessibility settings.
class AppAccessibilityConfig {
  /// Font size scaling factor (1.0 is standard).
  final double fontScale;

  /// Zoom factor for UI elements (1.0 is standard).
  final double zoomScale;

  /// Border thickness scaling factor (1.0 is standard).
  final double borderScale;

  /// Enable/disable high contrast mode.
  final bool highContrastMode;

  const AppAccessibilityConfig({
    this.fontScale = 1.0,
    this.zoomScale = 1.0,
    this.borderScale = 1.0,
    this.highContrastMode = false,
  });

  /// Creates a copy and modifies the specified properties.
  AppAccessibilityConfig copyWith({
    double? fontScale,
    double? zoomScale,
    double? borderScale,
    bool? highContrastMode,
  }) {
    return AppAccessibilityConfig(
      fontScale: fontScale ?? this.fontScale,
      zoomScale: zoomScale ?? this.zoomScale,
      borderScale: borderScale ?? this.borderScale,
      highContrastMode: highContrastMode ?? this.highContrastMode,
    );
  }

  /// Creates an instance from JSON.
  factory AppAccessibilityConfig.fromJson(Map<String, dynamic> json) {
    return AppAccessibilityConfig(
      fontScale: (json['fontScale'] as num?)?.toDouble() ?? 1.0,
      zoomScale: (json['zoomScale'] as num?)?.toDouble() ?? 1.0,
      borderScale: (json['borderScale'] as num?)?.toDouble() ?? 1.0,
      highContrastMode: json['highContrastMode'] as bool? ?? false,
    );
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'fontScale': fontScale,
      'zoomScale': zoomScale,
      'borderScale': borderScale,
      'highContrastMode': highContrastMode,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppAccessibilityConfig &&
        other.fontScale == fontScale &&
        other.zoomScale == zoomScale &&
        other.borderScale == borderScale &&
        other.highContrastMode == highContrastMode;
  }

  @override
  int get hashCode {
    return fontScale.hashCode ^
        zoomScale.hashCode ^
        borderScale.hashCode ^
        highContrastMode.hashCode;
  }

  @override
  String toString() {
    return 'AppAccessibilityConfig(fontScale: $fontScale, zoomScale: $zoomScale, borderScale: $borderScale, highContrastMode: $highContrastMode)';
  }
}
