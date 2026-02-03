import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';

void main() {
  group('Selectable', () {
    testWidgets('child widget is displayed as is when not selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Selectable(
                isSelected: false,
                child: Text('Unselected Text'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Unselected Text'), findsOneWidget);
      expect(find.byType(Container), findsNothing);
    });

    testWidgets('decorated container is displayed when selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Selectable(isSelected: true, child: Text('Selected Text')),
            ),
          ),
        ),
      );

      expect(find.text('Selected Text'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('custom selection colors are applied correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Selectable(
                isSelected: true,
                selectedBackgroundColor: Colors.yellow,
                selectedBorderColor: Colors.red,
                child: Text('Custom Color Text'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Custom Color Text'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('works correctly in combination with AppCard', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Selectable(
                isSelected: true,
                child: AppCard(child: Text('Selectable Card')),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Selectable Card'), findsOneWidget);
      expect(find.byType(AppCard), findsOneWidget);
      expect(find.byType(Selectable), findsOneWidget);
      // Verify that the container for the selected state exists
      expect(find.byType(Container), findsAtLeastNWidgets(1));
    });
  });

  group('SelectionState', () {
    test('nothing is selected in the initial state', () {
      final selectionState = SelectionState<String>();

      expect(selectionState.selectedItems, isEmpty);
      expect(selectionState.selectedCount, equals(0));
      expect(selectionState.hasSelection, isFalse);
    });

    test('items can be selected', () {
      final selectionState = SelectionState<String>();

      selectionState.select('item1');

      expect(selectionState.isSelected('item1'), isTrue);
      expect(selectionState.selectedCount, equals(1));
      expect(selectionState.hasSelection, isTrue);
    });

    test('items can be deselected', () {
      final selectionState = SelectionState<String>();

      selectionState.select('item1');
      selectionState.deselect('item1');

      expect(selectionState.isSelected('item1'), isFalse);
      expect(selectionState.selectedCount, equals(0));
      expect(selectionState.hasSelection, isFalse);
    });

    test('item selection state can be toggled', () {
      final selectionState = SelectionState<String>();

      // Selected on the first toggle
      selectionState.toggle('item1');
      expect(selectionState.isSelected('item1'), isTrue);

      // Deselected on the second toggle
      selectionState.toggle('item1');
      expect(selectionState.isSelected('item1'), isFalse);
    });

    test('multiple items can be selected', () {
      final selectionState = SelectionState<String>();

      selectionState.select('item1');
      selectionState.select('item2');
      selectionState.select('item3');

      expect(selectionState.selectedCount, equals(3));
      expect(selectionState.isSelected('item1'), isTrue);
      expect(selectionState.isSelected('item2'), isTrue);
      expect(selectionState.isSelected('item3'), isTrue);
    });

    test('all selections can be cleared', () {
      final selectionState = SelectionState<String>();

      selectionState.select('item1');
      selectionState.select('item2');
      selectionState.clearSelection();

      expect(selectionState.selectedCount, equals(0));
      expect(selectionState.hasSelection, isFalse);
    });

    test(
      'selecting the same item multiple times does not cause duplicates',
      () {
        final selectionState = SelectionState<String>();

        selectionState.select('item1');
        selectionState.select('item1');
        selectionState.select('item1');

        expect(selectionState.selectedCount, equals(1));
      },
    );
  });
}
