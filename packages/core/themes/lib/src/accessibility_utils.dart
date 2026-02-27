/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/theme_providers.dart';

/// Extension to provide easy access to accessibility scaling (Riverpod version)
extension AccessibilityScaling on WidgetRef {
  /// Get the current zoom scale from accessibility config
  double get zoomScale {
    final config = watch(accessibilityConfigProvider);
    return config.zoomScale;
  }

  /// Get the current font scale from accessibility config
  double get fontScale {
    final config = watch(accessibilityConfigProvider);
    return config.fontScale;
  }

  /// Get the current border scale from accessibility config
  double get borderScale {
    final config = watch(accessibilityConfigProvider);
    return config.borderScale;
  }

  /// Scale a double value by the zoom scale
  double scaleValue(double baseValue) {
    return baseValue * zoomScale;
  }

  /// Scale an EdgeInsets by the zoom scale
  EdgeInsets scaleEdgeInsets(EdgeInsets base) {
    final scale = zoomScale;
    return EdgeInsets.only(
      left: base.left * scale,
      top: base.top * scale,
      right: base.right * scale,
      bottom: base.bottom * scale,
    );
  }

  /// Scale a BorderRadius by the zoom scale
  BorderRadius scaleBorderRadius(BorderRadius base) {
    final scale = zoomScale;
    return BorderRadius.only(
      topLeft: base.topLeft * scale,
      topRight: base.topRight * scale,
      bottomLeft: base.bottomLeft * scale,
      bottomRight: base.bottomRight * scale,
    );
  }

  /// Scale a Size by the zoom scale
  Size scaleSize(Size base) {
    final scale = zoomScale;
    return Size(base.width * scale, base.height * scale);
  }

  /// Scale font size by the font scale
  double scaleFontSize(double baseFontSize) {
    final config = watch(accessibilityConfigProvider);
    return baseFontSize * config.fontScale;
  }

  /// Scale border width by the border scale
  double scaleBorderWidth(double baseWidth) {
    final config = watch(accessibilityConfigProvider);
    return baseWidth * config.borderScale;
  }
}
