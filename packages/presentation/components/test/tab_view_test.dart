/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presentation_components/presentation_components.dart';

void main() {
  testWidgets('AppTabView can display tabs and switch between them', (
    WidgetTester tester,
  ) async {
    // Mock data for the tab view
    final tabs = [
      const AppTab(id: 'tab1', label: 'Tab 1', icon: Icons.info),
      const AppTab(id: 'tab2', label: 'Tab 2'),
      const AppTab(id: 'tab3', label: 'Tab 3', icon: Icons.favorite),
    ];

    final contents = [
      const AppTabContent(
        id: 'tab1',
        content: _TestContent(text: 'Content of Tab 1'),
      ),
      const AppTabContent(
        id: 'tab2',
        content: _TestContent(text: 'Content of Tab 2'),
      ),
      const AppTabContent(
        id: 'tab3',
        content: _TestContent(text: 'Content of Tab 3'),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(home: AppTabView(tabs: tabs, contents: contents)),
    );

    // Verify that the first tab is selected
    expect(find.text('Tab 1'), findsOneWidget);
    expect(find.text('Content of Tab 1'), findsOneWidget);

    // Tap the second tab
    await tester.tap(find.text('Tab 2'));
    await tester.pumpAndSettle();

    // Verify that the content of the second tab is displayed
    expect(find.text('Content of Tab 2'), findsOneWidget);
    expect(find.text('Content of Tab 1'), findsNothing);
  });

  testWidgets('AppTabView handles custom styling', (WidgetTester tester) async {
    final tabs = [
      const AppTab(id: 'tab1', label: 'Tab 1'),
      const AppTab(id: 'tab2', label: 'Tab 2'),
    ];

    final contents = [
      const AppTabContent(id: 'tab1', content: _TestContent(text: 'Content 1')),
      const AppTabContent(id: 'tab2', content: _TestContent(text: 'Content 2')),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: AppTabView(
          tabs: tabs,
          contents: contents,
          tabBarPosition: TabBarPosition.bottom,
          contentBackgroundColor: Colors.grey.shade100,
        ),
      ),
    );

    expect(find.byType(AppTabView), findsOneWidget);
    expect(find.text('Tab 1'), findsOneWidget);
    expect(find.text('Content 1'), findsOneWidget);
  });
}

class _TestContent extends StatelessWidget {
  final String text;

  const _TestContent({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(16), child: Text(text));
  }
}
