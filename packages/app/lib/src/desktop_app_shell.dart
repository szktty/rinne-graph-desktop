/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';

class DesktopAppShell extends ConsumerWidget {
  const DesktopAppShell({required this.body, super.key});

  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeData = ref.watch(activeThemeProvider);
    final themeData = ref.watch(effectiveThemeDataProvider);
    return MaterialApp(
      title: 'Settings Test',
      theme: themeData,
      darkTheme: themeData,
      themeMode: appThemeData.themeMode,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: Scaffold(body: body),
    );
  }
}
