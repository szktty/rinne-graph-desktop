import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';

void main() {
  group('TagView Widget Tests', () {
    Widget createTestWidget(Widget child) {
      return ProviderScope(child: MaterialApp(home: Scaffold(body: child)));
    }

    testWidgets('Basic TagView display test', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(TagView(label: 'Test Tag')));

      await tester.pump();

      expect(find.text('Test Tag'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Custom color TagView test', (WidgetTester tester) async {
      const customColor = Colors.red;

      await tester.pumpWidget(
        createTestWidget(TagView(label: 'Custom Tag', color: customColor)),
      );

      await tester.pump();

      expect(find.text('Custom Tag'), findsOneWidget);

      // Check Container decoration
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      // Verify that background and border colors are custom color-based
      expect(decoration.color, customColor.withValues(alpha: 0.1));
      expect(decoration.border?.top.color, customColor.withValues(alpha: 0.2));
    });

    testWidgets('TagView text style test', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(TagView(label: 'Style Test')));

      await tester.pump();

      final textWidget = tester.widget<Text>(find.text('Style Test'));
      expect(textWidget.style?.color, isNotNull);
    });

    testWidgets('Long label TagView test', (WidgetTester tester) async {
      const longLabel = 'This is a very long tag label test';

      await tester.pumpWidget(createTestWidget(TagView(label: longLabel)));

      await tester.pump();

      expect(find.text(longLabel), findsOneWidget);
    });

    testWidgets('Empty label TagView test', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(TagView(label: '')));

      await tester.pump();

      expect(find.text(''), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
