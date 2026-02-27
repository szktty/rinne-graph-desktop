/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import 'package:core_stack_flutter/core_stack.dart';
import 'package:macos_ui/macos_ui.dart' as macos_ui;

import 'app_initializer.dart';

class DesktopApp extends StatelessWidget {
  const DesktopApp({required this.body, required this.isMainWindow, super.key});

  static Future<void> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  static Future<void> run({
    required List<String> arguments,
    required Widget Function() mainWindowBuilder,
  }) async {
    debugPrint('DesktopApp.run: $arguments');
    WidgetsFlutterBinding.ensureInitialized();

    // Apply MacosWindowUtilsConfig for macOS
    if (Platform.isMacOS) {
      final windowUtilsConfig = macos_ui.MacosWindowUtilsConfig();
      await windowUtilsConfig.apply();

      // Wait a bit until settings are applied
      await Future.delayed(const Duration(milliseconds: 10));
    }
    // No additional settings for Windows/Linux (Flutter default)

    // Run main app
    runApp(
      DesktopApp(
        body: mainWindowBuilder(),
        isMainWindow: true, // Main window
      ),
    );
  }

  final Widget body;
  final bool isMainWindow;

  @override
  Widget build(BuildContext context) {
    // Perform appropriate initialization depending on the window type
    debugPrint('DesktopApp.build: isMainWindow=$isMainWindow');
    return AppInitializer(
      initializations:
          isMainWindow
              ? [
                // For main window, complete initialization (including SharedPreferences)
                coreFoundationInitialization,
                coreStackInitialization,
                // Add other package initializations here if needed
              ]
              : [
                // For sub-windows, only basic initialization (excluding SharedPreferences)
                coreFoundationBaseInitialization,
                // Add other package initializations here if needed
              ],
      child: body,
    );
  }
}
