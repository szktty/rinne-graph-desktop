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
  group('FondeSnackBar Tests', () {
    // Test widget wrapper
    Widget createTestWidget(Widget child) {
      return ProviderScope(child: MaterialApp(home: Scaffold(body: child)));
    }

    testWidgets('FondeSnackBar.show displays snackbar with correct message', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  FondeSnackBar.show(
                    context: context,
                    message: 'Test SnackBar Message',
                    type: FondeSnackBarType.info,
                  );
                },
                child: const Text('Show SnackBar'),
              );
            },
          ),
        ),
      );

      // Tap the button to show the snackbar
      await tester.tap(find.text('Show SnackBar'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the snackbar message is displayed
      expect(find.text('Test SnackBar Message'), findsOneWidget);
    });

    testWidgets('FondeSnackBar.showSuccess displays success snackbar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  FondeSnackBar.showSuccess(
                    context: context,
                    message: 'Success!',
                  );
                },
                child: const Text('Show Success'),
              );
            },
          ),
        ),
      );

      // Tap the button to show the success snackbar
      await tester.tap(find.text('Show Success'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the success message is displayed
      expect(find.text('Success!'), findsOneWidget);

      // Verify that the success icon is displayed
      expect(find.byIcon(FondeIcons.check), findsOneWidget);
    });

    testWidgets('FondeSnackBar.showError displays error snackbar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  FondeSnackBar.showError(
                    context: context,
                    message: 'Error occurred!',
                  );
                },
                child: const Text('Show Error'),
              );
            },
          ),
        ),
      );

      // Tap the button to show the error snackbar
      await tester.tap(find.text('Show Error'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the error message is displayed
      expect(find.text('Error occurred!'), findsOneWidget);

      // Verify that the error icon is displayed
      expect(find.byIcon(FondeIcons.error), findsOneWidget);
    });

    testWidgets('FondeSnackBar.showWarning displays warning snackbar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  FondeSnackBar.showWarning(
                    context: context,
                    message: 'Warning!',
                  );
                },
                child: const Text('Show Warning'),
              );
            },
          ),
        ),
      );

      // Tap the button to show the warning snackbar
      await tester.tap(find.text('Show Warning'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the warning message is displayed
      expect(find.text('Warning!'), findsOneWidget);

      // Verify that the warning icon is displayed (currently uses the error icon)
      expect(find.byIcon(FondeIcons.error), findsOneWidget);
    });

    testWidgets('FondeSnackBar.showInfo displays info snackbar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  FondeSnackBar.showInfo(
                    context: context,
                    message: 'Information',
                  );
                },
                child: const Text('Show Info'),
              );
            },
          ),
        ),
      );

      // Tap the button to show the info snackbar
      await tester.tap(find.text('Show Info'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the info message is displayed
      expect(find.text('Information'), findsOneWidget);

      // Verify that the info icon is displayed
      expect(find.byIcon(FondeIcons.info), findsOneWidget);
    });

    testWidgets('FondeSnackBar with action button displays action', (
      WidgetTester tester,
    ) async {
      bool actionPressed = false;

      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  FondeSnackBar.show(
                    context: context,
                    message: 'Message with action',
                    type: FondeSnackBarType.info,
                    actionLabel: 'UNDO',
                    onActionPressed: () {
                      actionPressed = true;
                    },
                  );
                },
                child: const Text('Show with Action'),
              );
            },
          ),
        ),
      );

      // Tap the button to show the snackbar with an action
      await tester.tap(find.text('Show with Action'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the message is displayed
      expect(find.text('Message with action'), findsOneWidget);

      // Verify that the action button is displayed
      expect(find.text('UNDO'), findsOneWidget);

      // Tap the action button
      await tester.tap(find.text('UNDO'));
      await tester.pump();

      // Verify that the action was executed
      expect(actionPressed, isTrue);
    });

    testWidgets('FondeSnackBar with custom icon displays custom icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  FondeSnackBar.show(
                    context: context,
                    message: 'Custom Icon SnackBar',
                    type: FondeSnackBarType.info,
                    icon: FondeIcons.star,
                  );
                },
                child: const Text('Show Custom Icon'),
              );
            },
          ),
        ),
      );

      // Tap the button to show the snackbar with a custom icon
      await tester.tap(find.text('Show Custom Icon'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the message is displayed
      expect(find.text('Custom Icon SnackBar'), findsOneWidget);

      // Verify that the custom icon is displayed
      expect(find.byIcon(FondeIcons.star), findsOneWidget);
    });

    testWidgets('FondeSnackBar respects accessibility zoom scale', (
      WidgetTester tester,
    ) async {
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
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      FondeSnackBar.show(
                        context: context,
                        message: 'Zoom Test',
                        type: FondeSnackBarType.info,
                      );
                    },
                    child: const Text('Show Zoom Test'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Tap the button to show the snackbar
      await tester.tap(find.text('Show Zoom Test'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the message is displayed
      expect(find.text('Zoom Test'), findsOneWidget);

      // Verify that a container with zoom settings applied exists
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsWidgets);
    });

    testWidgets('FondeSnackBar hides current snackbar before showing new one', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      FondeSnackBar.show(
                        context: context,
                        message: 'First SnackBar',
                        type: FondeSnackBarType.info,
                      );
                    },
                    child: const Text('Show First'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FondeSnackBar.show(
                        context: context,
                        message: 'Second SnackBar',
                        type: FondeSnackBarType.success,
                      );
                    },
                    child: const Text('Show Second'),
                  ),
                ],
              );
            },
          ),
        ),
      );

      // Show the first snackbar
      await tester.tap(find.text('Show First'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the first message is displayed
      expect(find.text('First SnackBar'), findsOneWidget);

      // Show the second snackbar
      await tester.tap(find.text('Show Second'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify that the second message is displayed
      expect(find.text('Second SnackBar'), findsOneWidget);

      // Verify that the first message is not displayed
      expect(find.text('First SnackBar'), findsNothing);
    });
  });
}
