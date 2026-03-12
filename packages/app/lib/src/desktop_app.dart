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
import 'package:macos_window_utils/macos_window_utils.dart'
    show
        WindowManipulator,
        NSVisualEffectViewMaterial,
        NSWindowToolbarStyle,
        NSAppPresentationOptions,
        NSAppPresentationOption;
import 'package:macos_window_utils/macos/ns_window_delegate.dart'
    show NSWindowDelegate;

import 'app_initializer.dart';

class DesktopApp extends StatelessWidget {
  const DesktopApp({required this.body, required this.isMainWindow, super.key});

  static Future<void> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  static Future<void> _applyMacosWindowConfig() async {
    await WindowManipulator.initialize(enableWindowDelegate: true);
    await WindowManipulator.setMaterial(
      NSVisualEffectViewMaterial.windowBackground,
    );
    await WindowManipulator.enableFullSizeContentView();
    await WindowManipulator.makeTitlebarTransparent();
    await WindowManipulator.hideTitle();
    await WindowManipulator.addToolbar();
    await WindowManipulator.setToolbarStyle(
      toolbarStyle: NSWindowToolbarStyle.unified,
    );
    WindowManipulator.addNSWindowDelegate(_FullScreenToolbarDelegate());
    final options = NSAppPresentationOptions.from({
      NSAppPresentationOption.fullScreen,
      NSAppPresentationOption.autoHideToolbar,
      NSAppPresentationOption.autoHideMenuBar,
      NSAppPresentationOption.autoHideDock,
    });
    options.applyAsFullScreenPresentationOptions();
  }

  static Future<void> run({
    required List<String> arguments,
    required Widget Function() mainWindowBuilder,
  }) async {
    debugPrint('DesktopApp.run: $arguments');
    WidgetsFlutterBinding.ensureInitialized();

    // Apply window configuration for macOS
    if (Platform.isMacOS) {
      await _applyMacosWindowConfig();

      // Wait a bit until settings are applied
      await Future.delayed(const Duration(milliseconds: 10));
    }
    // No additional settings for Windows/Linux (Flutter default)

    // Run main app
    runApp(
      DesktopApp(
        body: mainWindowBuilder(),
        isMainWindow: true,
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
              ]
              : [
                // For sub-windows, only basic initialization (excluding SharedPreferences)
                coreFoundationBaseInitialization,
              ],
      child: body,
    );
  }
}

/// Removes/restores the toolbar when entering/exiting full-screen mode.
class _FullScreenToolbarDelegate extends NSWindowDelegate {
  @override
  void windowWillEnterFullScreen() {
    WindowManipulator.removeToolbar();
    super.windowWillEnterFullScreen();
  }

  @override
  void windowDidExitFullScreen() {
    WindowManipulator.addToolbar();
    super.windowDidExitFullScreen();
  }
}
