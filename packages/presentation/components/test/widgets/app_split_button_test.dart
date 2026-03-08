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
  group('FondeSplitButton Widget Tests', () {
    late List<FondeSplitButtonAction> testActions;

    setUp(() {
      testActions = [
        FondeSplitButtonAction(label: 'Action 1', onPressed: () {}),
        FondeSplitButtonAction(
          label: 'Action 2',
          onPressed: () {},
          icon: const Icon(Icons.star, size: 16),
        ),
        FondeSplitButtonAction(
          label: 'Disabled Action',
          onPressed: () {},
          enabled: false,
        ),
      ];
    });

    Widget createTestWidget({
      String primaryLabel = 'Primary Action',
      VoidCallback? onPrimaryPressed,
      List<FondeSplitButtonAction>? actions,
      bool enabled = true,
    }) {
      return ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: FondeSplitButton(
              primaryLabel: primaryLabel,
              onPrimaryPressed: onPrimaryPressed,
              actions: actions ?? testActions,
              enabled: enabled,
            ),
          ),
        ),
      );
    }

    testWidgets('Basic FondeSplitButton display test', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify that the primary button label is displayed
      expect(find.text('Primary Action'), findsOneWidget);

      // Verify that the dropdown arrow is displayed
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets('Primary action tap test', (WidgetTester tester) async {
      bool primaryPressed = false;

      await tester.pumpWidget(
        createTestWidget(onPrimaryPressed: () => primaryPressed = true),
      );
      await tester.pumpAndSettle();

      // Tap the primary button part
      final primaryButton = find.text('Primary Action');
      await tester.tap(primaryButton);
      await tester.pumpAndSettle();

      expect(primaryPressed, isTrue);
    });

    testWidgets('Dropdown menu display test', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap the dropdown arrow to open the menu
      final dropdownButton = find.byIcon(Icons.keyboard_arrow_down);
      await tester.tap(dropdownButton);
      await tester.pumpAndSettle();

      // Verify that the menu items are displayed
      expect(find.text('Action 1'), findsOneWidget);
      expect(find.text('Action 2'), findsOneWidget);
      expect(find.text('Disabled Action'), findsOneWidget);
    });

    testWidgets('Dropdown menu action execution test', (
      WidgetTester tester,
    ) async {
      bool action1Pressed = false;
      final actionsWithCallback = [
        FondeSplitButtonAction(
          label: 'Test Action',
          onPressed: () => action1Pressed = true,
        ),
      ];

      await tester.pumpWidget(createTestWidget(actions: actionsWithCallback));
      await tester.pumpAndSettle();

      // Open the dropdown menu
      final dropdownButton = find.byIcon(Icons.keyboard_arrow_down);
      await tester.tap(dropdownButton);
      await tester.pumpAndSettle();

      // Tap the menu item
      await tester.tap(find.text('Test Action'));
      await tester.pumpAndSettle();

      expect(action1Pressed, isTrue);
    });

    testWidgets('Disabled state test', (WidgetTester tester) async {
      bool primaryPressed = false;

      await tester.pumpWidget(
        createTestWidget(
          onPrimaryPressed: () => primaryPressed = true,
          enabled: false,
        ),
      );
      await tester.pumpAndSettle();

      // Tap the primary button (does not react in disabled state)
      final primaryButton = find.text('Primary Action');
      await tester.tap(primaryButton);
      await tester.pumpAndSettle();

      expect(primaryPressed, isFalse);

      // Tap the dropdown button (does not react in disabled state)
      final dropdownButton = find.byIcon(Icons.keyboard_arrow_down);
      await tester.tap(dropdownButton);
      await tester.pumpAndSettle();

      // Verify that the menu is not displayed
      expect(find.text('Action 1'), findsNothing);
    });

    testWidgets('Primary button with icon test', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: FondeSplitButton(
                primaryLabel: 'Save',
                primaryIcon: const Icon(Icons.save, size: 16),
                onPrimaryPressed: () {},
                actions: testActions,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify that the primary button icon and label are displayed
      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('Custom width/height test', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: FondeSplitButton(
                primaryLabel: 'Custom Size',
                onPrimaryPressed: () {},
                actions: testActions,
                width: 200,
                height: 60,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify that custom size is applied
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(FondeSplitButton),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.constraints?.maxWidth, 200);
    });
  });
}
