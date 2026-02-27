/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';

void main() {
  group('Theme Providers', () {
    test('Platform brightness provider returns brightness', () {
      final container = ProviderContainer();

      final brightness = container.read(platformBrightnessProvider);

      // Verify that the platform brightness setting can be retrieved.
      expect(brightness, isA<Brightness>());

      container.dispose();
    });

    test('Active theme provider returns AppThemeData', () {
      final container = ProviderContainer();

      final theme = container.read(activeThemeProvider);

      // Verify that the active theme can be retrieved.
      expect(theme, isA<AppThemeData>());
      expect(theme.name, isNotEmpty);

      container.dispose();
    });

    test('Effective color scheme provider returns AppColorScheme', () {
      final container = ProviderContainer();

      final colorScheme = container.read(effectiveColorSchemeProvider);

      // Verify that the effective color scheme can be retrieved.
      expect(colorScheme, isA<AppColorScheme>());

      container.dispose();
    });

    test('Custom theme provider returns AppThemeData', () {
      final container = ProviderContainer();

      final customTheme = container.read(customThemeProvider);

      // Verify that the custom theme can be retrieved.
      expect(customTheme, isA<AppThemeData>());
      expect(customTheme.name, 'Custom Theme');

      container.dispose();
    });

    test('Accessibility config provider returns AppAccessibilityConfig', () {
      final container = ProviderContainer();

      final config = container.read(accessibilityConfigProvider);

      // Verify that the accessibility settings can be retrieved.
      expect(config, isA<AppAccessibilityConfig>());

      container.dispose();
    });
  });
}
