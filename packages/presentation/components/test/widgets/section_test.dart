import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';

void main() {
  group('Section Widget Tests', () {
    Widget createTestWidget(Widget child) {
      return ProviderScope(child: MaterialApp(home: Scaffold(body: child)));
    }

    testWidgets('Basic Section display test', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          Section(
            title: Text('Test Title'),
            description: Text('Test Description'),
            children: [Text('Item 1'), Text('Item 2'), Text('Item 3')],
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('Section without dividers test', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          Section(
            showDividers: false,
            children: [Text('Item 1'), Text('Item 2')],
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('Section with dividers test', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          Section(
            showDividers: true,
            children: [Text('Item 1'), Text('Item 2')],
          ),
        ),
      );

      await tester.pump();

      // Verify that there is one divider between two items
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('Custom padding test', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(32.0);

      await tester.pumpWidget(
        createTestWidget(
          Section(padding: customPadding, children: [Text('Test Item')]),
        ),
      );

      await tester.pump();

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, customPadding);
    });

    testWidgets('Background color settings test', (WidgetTester tester) async {
      const backgroundColor = Colors.blue;

      await tester.pumpWidget(
        createTestWidget(
          Section(
            backgroundColor: backgroundColor,
            children: [Text('Test Item')],
          ),
        ),
      );

      await tester.pump();

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, backgroundColor);
    });
  });
}
