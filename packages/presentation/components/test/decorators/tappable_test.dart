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
  group('Tappable', () {
    testWidgets('Basic tap works correctly', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Tappable(
                onTap: () => tapped = true,
                child: Text('Tappable Text'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Tappable Text'), findsOneWidget);

      await tester.tap(find.text('Tappable Text'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('Double tap works correctly', (WidgetTester tester) async {
      bool doubleTapped = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Tappable(
                onDoubleTap: () => doubleTapped = true,
                child: Text('Double Tappable Text'),
              ),
            ),
          ),
        ),
      );

      // Execute double tap
      await tester.tap(find.text('Double Tappable Text'));
      await tester.pump(Duration(milliseconds: 100));
      await tester.tap(find.text('Double Tappable Text'));
      await tester.pump();

      expect(doubleTapped, isTrue);
    });

    testWidgets('Long press works correctly', (WidgetTester tester) async {
      bool longPressed = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Tappable(
                onLongPress: () => longPressed = true,
                child: Text('Long Tappable Text'),
              ),
            ),
          ),
        ),
      );

      await tester.longPress(find.text('Long Tappable Text'));
      await tester.pump();

      expect(longPressed, isTrue);
    });

    testWidgets('Tap down works correctly', (WidgetTester tester) async {
      bool tapDownCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Tappable(
                onTapDown: () => tapDownCalled = true,
                child: Text('Tap Down Tappable Text'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Down Tappable Text'));
      await tester.pump();

      expect(tapDownCalled, isTrue);
    });

    testWidgets('Works correctly in combination with AppCard', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Tappable(
                onTap: () => tapped = true,
                child: AppCard(child: Text('Tappable Card')),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Tappable Card'), findsOneWidget);
      expect(find.byType(AppCard), findsOneWidget);
      expect(find.byType(Tappable), findsOneWidget);

      await tester.tap(find.text('Tappable Card'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('Combination of Selectable and Tappable works correctly', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Tappable(
                onTap: () => tapped = true,
                child: Selectable(
                  isSelected: true,
                  child: AppCard(child: Text('Selectable and Tappable Card')),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Selectable and Tappable Card'), findsOneWidget);
      expect(find.byType(AppCard), findsOneWidget);
      expect(find.byType(Selectable), findsOneWidget);
      expect(find.byType(Tappable), findsOneWidget);

      await tester.tap(find.text('Selectable and Tappable Card'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('GestureDetector is used when InkWell is disabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Tappable(
                onTap: () {},
                disableInkWell: true,
                child: Text('InkWell Disabled Text'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('InkWell is used when InkWell is enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Tappable(
                onTap: () {},
                disableInkWell: false,
                child: Text('InkWell Enabled Text'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(InkWell), findsOneWidget);
    });
  });
}
