/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';

/// Extension methods for the Color class.
extension ColorExtensions on Color {
  /// Darkens the color.
  /// [amount] A value between 0.0 and 1.0. The larger the value, the darker the color.
  Color darken(double amount) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  /// Lightens the color.
  /// [amount] A value between 0.0 and 1.0. The larger the value, the lighter the color.
  Color lighten(double amount) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');

    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );

    return hslLight.toColor();
  }

  /// Adjusts the brightness of the color.
  /// [factor] A value between -1.0 and 1.0. Negative values darken the color, positive values lighten it.
  Color adjustBrightness(double factor) {
    assert(factor >= -1 && factor <= 1, 'Factor must be between -1 and 1');

    if (factor == 0) return this;
    if (factor > 0) {
      return lighten(factor);
    } else {
      return darken(-factor);
    }
  }

  /// Adjusts the saturation of the color.
  /// [factor] A value between -1.0 and 1.0. Negative values decrease saturation, positive values increase it.
  Color adjustSaturation(double factor) {
    assert(factor >= -1 && factor <= 1, 'Factor must be between -1 and 1');

    final hsl = HSLColor.fromColor(this);
    final newSaturation = (hsl.saturation + factor).clamp(0.0, 1.0);

    return hsl.withSaturation(newSaturation).toColor();
  }
}
