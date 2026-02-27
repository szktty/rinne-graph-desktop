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
import 'package:presentation_components/presentation_components.dart';

void main() {
  group('AppText Widget Tests', () {
    // Test widget wrapper
    Widget createTestWidget(Widget child) {
      return ProviderScope(child: MaterialApp(home: Scaffold(body: child)));
    }

    testWidgets('Basic text display test', (WidgetTester tester) async {
      // Build the widget to be tested
      await tester.pumpWidget(
        createTestWidget(
          const AppText('Test Text', variant: AppTextVariant.uiBody),
        ),
      );

      // Verify that the text is displayed
      expect(find.text('Test Text'), findsOneWidget);
    });

    testWidgets('Different typography variants test', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          const Column(
            children: [
              AppText('Heading 1', variant: AppTextVariant.uiHeading1),
              AppText('Heading 2', variant: AppTextVariant.uiHeading2),
              AppText('Body', variant: AppTextVariant.uiBody),
            ],
          ),
        ),
      );

      // Verify that each text is displayed
      expect(find.text('Heading 1'), findsOneWidget);
      expect(find.text('Heading 2'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('Text overflow test', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const SizedBox(
            width: 100, // Set a narrow width
            child: AppText(
              'Test overflow with a very long text',
              variant: AppTextVariant.uiBody,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );

      // Verify that the text widget exists
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.maxLines, equals(1));
      expect(textWidget.overflow, equals(TextOverflow.ellipsis));
    });

    testWidgets('Custom color test', (WidgetTester tester) async {
      const testColor = Colors.red;

      await tester.pumpWidget(
        createTestWidget(
          const AppText(
            'Color Test',
            variant: AppTextVariant.uiBody,
            color: testColor,
          ),
        ),
      );

      // Verify the style of the text widget
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.color, equals(testColor));
    });

    testWidgets('Text alignment test', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const AppText(
            'Center Align Test',
            variant: AppTextVariant.uiBody,
            textAlign: TextAlign.center,
          ),
        ),
      );

      // Verify the alignment of the text widget
      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.textAlign, equals(TextAlign.center));
    });
  });
}
