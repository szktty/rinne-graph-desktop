import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';

void main() {
  group('AppSplitButton Widget Tests', () {
    late List<AppSplitButtonAction> testActions;

    setUp(() {
      testActions = [
        AppSplitButtonAction(label: 'Action 1', onPressed: () {}),
        AppSplitButtonAction(
          label: 'Action 2',
          onPressed: () {},
          icon: const Icon(Icons.star, size: 16),
        ),
        AppSplitButtonAction(
          label: 'Disabled Action',
          onPressed: () {},
          enabled: false,
        ),
      ];
    });

    Widget createTestWidget({
      String primaryLabel = 'Primary Action',
      VoidCallback? onPrimaryPressed,
      List<AppSplitButtonAction>? actions,
      bool enabled = true,
    }) {
      return ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AppSplitButton(
              primaryLabel: primaryLabel,
              onPrimaryPressed: onPrimaryPressed,
              actions: actions ?? testActions,
              enabled: enabled,
            ),
          ),
        ),
      );
    }

    testWidgets('Basic AppSplitButton display test', (
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
        AppSplitButtonAction(
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
              body: AppSplitButton(
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
              body: AppSplitButton(
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
              of: find.byType(AppSplitButton),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.constraints?.maxWidth, 200);
    });
  });
}
