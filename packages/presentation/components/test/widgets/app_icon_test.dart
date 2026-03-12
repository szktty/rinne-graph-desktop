/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_themes/core_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation_components/presentation_components.dart';

void main() {
  group('FondeIcon', () {
    testWidgets('renders with default size and color', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppThemeData.lightTheme().toThemeData(),
            home: const Scaffold(body: FondeIcon(FondeIcons.search)),
          ),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
      expect(find.byIcon(FondeIcons.search), findsOneWidget);
    });

    testWidgets('applies zoom scale when enabled', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilityConfigProvider.overrideWith((ref) {
              return const AppAccessibilityConfig(
                zoomScale: 1.5,
                borderScale: 1.0,
                fontScale: 1.0,
                highContrastMode: false,
              );
            }),
          ],
          child: MaterialApp(
            theme: AppThemeData.lightTheme().toThemeData(),
            home: const Scaffold(
              body: FondeIcon(FondeIcons.settings, size: FondeIconSize.standard),
            ),
          ),
        ),
      );

      final Icon icon = tester.widget(find.byType(Icon));
      expect(icon.size, equals(24.0 * 1.5)); // standard size * zoom scale
    });

    testWidgets('respects disableZoom parameter', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilityConfigProvider.overrideWith((ref) {
              return const AppAccessibilityConfig(
                zoomScale: 2.0,
                borderScale: 1.0,
                fontScale: 1.0,
                highContrastMode: false,
              );
            }),
          ],
          child: MaterialApp(
            theme: AppThemeData.lightTheme().toThemeData(),
            home: const Scaffold(
              body: FondeIcon(
                FondeIcons.settings,
                size: FondeIconSize.standard,
                disableZoom: true,
              ),
            ),
          ),
        ),
      );

      final Icon icon = tester.widget(find.byType(Icon));
      expect(icon.size, equals(24.0)); // no zoom applied
    });

    testWidgets('uses custom size over preset size', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppThemeData.lightTheme().toThemeData(),
            home: const Scaffold(
              body: FondeIcon(
                FondeIcons.check,
                size: FondeIconSize.small,
                customSize: 28.0,
              ),
            ),
          ),
        ),
      );

      final Icon icon = tester.widget(find.byType(Icon));
      expect(icon.size, equals(28.0));
    });

    testWidgets('applies semantic colors correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppThemeData.lightTheme().toThemeData(),
            home: const Scaffold(
              body: Column(
                children: [
                  FondeIcon(FondeIcons.info, color: FondeIconColor.primary),
                  FondeIcon(FondeIcons.x, color: FondeIconColor.error),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Icon), findsNWidgets(2));
    });

    testWidgets('uses custom color over semantic color', (tester) async {
      const customColor = Colors.purple;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppThemeData.lightTheme().toThemeData(),
            home: const Scaffold(
              body: FondeIcon(
                FondeIcons.star,
                color: FondeIconColor.primary,
                customColor: customColor,
              ),
            ),
          ),
        ),
      );

      final Icon icon = tester.widget(find.byType(Icon));
      expect(icon.color, equals(customColor));
    });

    testWidgets('adds semantic label when provided', (tester) async {
      const semanticLabel = 'Search button';

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppThemeData.lightTheme().toThemeData(),
            home: const Scaffold(
              body: FondeIcon(FondeIcons.search, semanticLabel: semanticLabel),
            ),
          ),
        ),
      );

      final Icon icon = tester.widget(find.byType(Icon));
      expect(icon.semanticLabel, equals(semanticLabel));

      // Check Semantics widget
      expect(find.byType(Semantics), findsOneWidget);
      final Semantics semantics = tester.widget(find.byType(Semantics));
      expect(semantics.properties.label, equals(semanticLabel));
    });

    group('Factory methods', () {
      testWidgets('small factory creates small icon', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              theme: AppThemeData.lightTheme().toThemeData(),
              home: Scaffold(body: FondeIconFactories.small(FondeIcons.plus)),
            ),
          ),
        );

        final Icon icon = tester.widget(find.byType(Icon));
        expect(icon.size, equals(16.0));
      });

      testWidgets('error factory applies error color', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              theme: AppThemeData.lightTheme().toThemeData(),
              home: Scaffold(body: FondeIconFactories.error(FondeIcons.x)),
            ),
          ),
        );

        expect(find.byType(Icon), findsOneWidget);
      });
    });

    testWidgets('all preset sizes render correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppThemeData.lightTheme().toThemeData(),
            home: const Scaffold(
              body: Column(
                children: [
                  FondeIcon(FondeIcons.star, size: FondeIconSize.small),
                  FondeIcon(FondeIcons.star, size: FondeIconSize.medium),
                  FondeIcon(FondeIcons.star, size: FondeIconSize.standard),
                  FondeIcon(FondeIcons.star, size: FondeIconSize.large),
                  FondeIcon(FondeIcons.star, size: FondeIconSize.xlarge),
                ],
              ),
            ),
          ),
        ),
      );

      final icons = tester.widgetList<Icon>(find.byType(Icon)).toList();
      expect(icons.length, equals(5));
      expect(icons[0].size, equals(16.0));
      expect(icons[1].size, equals(20.0));
      expect(icons[2].size, equals(24.0));
      expect(icons[3].size, equals(32.0));
      expect(icons[4].size, equals(48.0));
    });
  });
}
