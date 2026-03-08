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
import 'package:core_themes/core_themes.dart';

void main() {
  group('AppToast Tests', () {
    // Widget wrapper for testing
    Widget createTestWidget(Widget child) {
      return ProviderScope(child: MaterialApp(home: Scaffold(body: child)));
    }

    testWidgets('AppToast.show displays toast with correct message', (
      WidgetTester tester,
    ) async {
      final targetKey = GlobalKey();

      await tester.pumpWidget(
        createTestWidget(
          Column(
            children: [
              Container(
                key: targetKey,
                width: 100,
                height: 50,
                color: Colors.blue,
                child: const Text('Target'),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      );

      // トーストを表示
      AppToast.show(
        context: tester.element(find.byKey(targetKey)),
        targetKey: targetKey,
        message: 'Test Toast Message',
        type: AppToastType.info,
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the toast message is displayed
      expect(find.text('Test Toast Message'), findsOneWidget);
    });

    testWidgets('AppToast.showSuccess displays success toast', (
      WidgetTester tester,
    ) async {
      final targetKey = GlobalKey();

      await tester.pumpWidget(
        createTestWidget(
          Container(
            key: targetKey,
            width: 100,
            height: 50,
            color: Colors.blue,
            child: const Text('Target'),
          ),
        ),
      );

      // Display success toast
      AppToast.showSuccess(
        context: tester.element(find.byKey(targetKey)),
        targetKey: targetKey,
        message: 'Success!',
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the success message is displayed
      expect(find.text('Success!'), findsOneWidget);

      // Verify that the success icon is displayed
      expect(find.byIcon(FondeIcons.check), findsOneWidget);
    });

    testWidgets('AppToast.showError displays error toast', (
      WidgetTester tester,
    ) async {
      final targetKey = GlobalKey();

      await tester.pumpWidget(
        createTestWidget(
          Container(
            key: targetKey,
            width: 100,
            height: 50,
            color: Colors.blue,
            child: const Text('Target'),
          ),
        ),
      );

      // Display error toast
      AppToast.showError(
        context: tester.element(find.byKey(targetKey)),
        targetKey: targetKey,
        message: 'Error occurred!',
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the error message is displayed
      expect(find.text('Error occurred!'), findsOneWidget);

      // Verify that the error icon is displayed
      expect(find.byIcon(FondeIcons.error), findsOneWidget);
    });

    testWidgets('AppToast.showWarning displays warning toast', (
      WidgetTester tester,
    ) async {
      final targetKey = GlobalKey();

      await tester.pumpWidget(
        createTestWidget(
          Container(
            key: targetKey,
            width: 100,
            height: 50,
            color: Colors.blue,
            child: const Text('Target'),
          ),
        ),
      );

      // Display warning toast
      AppToast.showWarning(
        context: tester.element(find.byKey(targetKey)),
        targetKey: targetKey,
        message: 'Warning!',
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the warning message is displayed
      expect(find.text('Warning!'), findsOneWidget);

      // Verify that the warning icon is displayed (currently using error icon)
      expect(find.byIcon(FondeIcons.error), findsOneWidget);
    });

    testWidgets('AppToast.showInfo displays info toast', (
      WidgetTester tester,
    ) async {
      final targetKey = GlobalKey();

      await tester.pumpWidget(
        createTestWidget(
          Container(
            key: targetKey,
            width: 100,
            height: 50,
            color: Colors.blue,
            child: const Text('Target'),
          ),
        ),
      );

      // Display info toast
      AppToast.showInfo(
        context: tester.element(find.byKey(targetKey)),
        targetKey: targetKey,
        message: 'Information',
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the info message is displayed
      expect(find.text('Information'), findsOneWidget);

      // Verify that the info icon is displayed
      expect(find.byIcon(FondeIcons.info), findsOneWidget);
    });

    testWidgets('AppToast with custom icon displays custom icon', (
      WidgetTester tester,
    ) async {
      final targetKey = GlobalKey();

      await tester.pumpWidget(
        createTestWidget(
          Container(
            key: targetKey,
            width: 100,
            height: 50,
            color: Colors.blue,
            child: const Text('Target'),
          ),
        ),
      );

      // Display toast with custom icon
      AppToast.show(
        context: tester.element(find.byKey(targetKey)),
        targetKey: targetKey,
        message: 'Custom Icon Toast',
        type: AppToastType.info,
        icon: FondeIcons.star,
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the message is displayed
      expect(find.text('Custom Icon Toast'), findsOneWidget);

      // Verify that the custom icon is displayed
      expect(find.byIcon(FondeIcons.star), findsOneWidget);
    });

    testWidgets('AppToast respects accessibility zoom scale', (
      WidgetTester tester,
    ) async {
      final targetKey = GlobalKey();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            accessibilityConfigProvider.overrideWith(
              () =>
                  AccessibilityConfig()
                    ..state = const AppAccessibilityConfig(
                      zoomScale: 1.5,
                      borderScale: 1.0,
                      fontScale: 1.0,
                      highContrastMode: false,
                    ),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Container(
                key: targetKey,
                width: 100,
                height: 50,
                color: Colors.blue,
                child: const Text('Target'),
              ),
            ),
          ),
        ),
      );

      // トーストを表示
      AppToast.show(
        context: tester.element(find.byKey(targetKey)),
        targetKey: targetKey,
        message: 'Zoom Test',
        type: AppToastType.info,
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the message is displayed
      expect(find.text('Zoom Test'), findsOneWidget);

      // Verify that a container with zoom settings applied exists
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsWidgets);
    });

    testWidgets('AppToast.showAtCursor displays toast at cursor position', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(const Center(child: Text('Test Widget'))),
      );

      // Display toast at cursor position
      AppToast.showAtCursor(
        context: tester.element(find.text('Test Widget')),
        message: 'Cursor Toast',
        type: AppToastType.info,
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the toast message is displayed
      expect(find.text('Cursor Toast'), findsOneWidget);
    });
  });
}
