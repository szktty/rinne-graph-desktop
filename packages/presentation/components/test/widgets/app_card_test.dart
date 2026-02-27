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
  group('AppCard', () {
    testWidgets('displays basic card correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: AppCard(child: Text('Test Card'))),
          ),
        ),
      );

      expect(find.text('Test Card'), findsOneWidget);
      expect(find.byType(AppCard), findsOneWidget);
    });

    testWidgets('creates small card correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: AppCard.small(child: Text('Small Card'))),
          ),
        ),
      );

      expect(find.text('Small Card'), findsOneWidget);
      expect(find.byType(AppCard), findsOneWidget);
    });

    testWidgets('creates medium card correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: AppCard.medium(child: Text('Medium Card'))),
          ),
        ),
      );

      expect(find.text('Medium Card'), findsOneWidget);
      expect(find.byType(AppCard), findsOneWidget);
    });

    testWidgets('creates large card correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: AppCard.large(child: Text('Large Card'))),
          ),
        ),
      );

      expect(find.text('Large Card'), findsOneWidget);
      expect(find.byType(AppCard), findsOneWidget);
    });

    testWidgets('creates xlarge card correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: AppCard.xlarge(child: Text('XLarge Card'))),
          ),
        ),
      );

      expect(find.text('XLarge Card'), findsOneWidget);
      expect(find.byType(AppCard), findsOneWidget);
    });

    testWidgets('applies custom properties correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AppCard(
                backgroundColor: Colors.red,
                width: 200,
                height: 100,
                child: Text('Custom Card'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Custom Card'), findsOneWidget);
      expect(find.byType(AppCard), findsOneWidget);
    });

    testWidgets('applies margin correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AppCard(
                margin: EdgeInsets.all(16),
                child: Text('Card with margin'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Card with margin'), findsOneWidget);
      expect(find.byType(AppCard), findsOneWidget);
      // Verify that the margin is applied (existence of Padding widget)
      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('works correctly even when child widget is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: Scaffold(body: AppCard()))),
      );

      expect(find.byType(AppCard), findsOneWidget);
    });
  });
}
