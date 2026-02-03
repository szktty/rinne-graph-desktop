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
