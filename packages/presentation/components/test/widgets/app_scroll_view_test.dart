/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation_components/presentation_components.dart';

void main() {
  group('AppScrollView', () {
    testWidgets('renders child widget correctly', (WidgetTester tester) async {
      const testChild = Text('Test Content');

      await tester.pumpWidget(
        const MaterialApp(home: AppScrollView(child: testChild)),
      );

      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('applies correct default physics', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppScrollView(
            child: SizedBox(height: 1000, child: Text('Scrollable Content')),
          ),
        ),
      );

      final scrollView = find.byType(SingleChildScrollView);
      expect(scrollView, findsOneWidget);

      final scrollViewWidget = tester.widget<SingleChildScrollView>(scrollView);
      expect(scrollViewWidget.physics, isA<BouncingScrollPhysics>());
    });

    testWidgets('accepts custom scroll controller', (
      WidgetTester tester,
    ) async {
      final controller = ScrollController();

      await tester.pumpWidget(
        MaterialApp(
          home: AppScrollView(
            controller: controller,
            child: const SizedBox(
              height: 1000,
              child: Text('Scrollable Content'),
            ),
          ),
        ),
      );

      final scrollView = find.byType(SingleChildScrollView);
      final scrollViewWidget = tester.widget<SingleChildScrollView>(scrollView);
      expect(scrollViewWidget.controller, equals(controller));

      controller.dispose();
    });

    testWidgets('supports horizontal scrolling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(width: 1000, child: Text('Horizontal Content')),
          ),
        ),
      );

      final scrollView = find.byType(SingleChildScrollView);
      final scrollViewWidget = tester.widget<SingleChildScrollView>(scrollView);
      expect(scrollViewWidget.scrollDirection, equals(Axis.horizontal));
    });

    testWidgets('applies custom padding', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(16.0);

      await tester.pumpWidget(
        const MaterialApp(
          home: AppScrollView(
            padding: customPadding,
            child: Text('Padded Content'),
          ),
        ),
      );

      final scrollView = find.byType(SingleChildScrollView);
      final scrollViewWidget = tester.widget<SingleChildScrollView>(scrollView);
      expect(scrollViewWidget.padding, equals(customPadding));
    });
  });
}
