import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('SettingsScreen', () {
    Widget createWidgetUnderTest() {
      return const ProviderScope(
        child: MaterialApp(home: Scaffold(body: SizedBox())),
      );
    }

    testWidgets('renders with ProviderScope', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(ProviderScope), findsOneWidget);
    });
  });
}
