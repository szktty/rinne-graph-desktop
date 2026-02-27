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
