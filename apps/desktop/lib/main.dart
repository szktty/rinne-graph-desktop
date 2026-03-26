/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app/app.dart';
import 'package:plough/plough.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import 'package:core_app_config/core_app_config.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;
import 'package:core_settings/core_settings.dart';
import 'package:core_themes/core_themes.dart';

import 'src/widgets/menu_builder.dart';
import 'src/widgets/main_app_shell.dart';
import 'src/providers/dialog_visibility_providers.dart';
import 'src/providers/graph_providers.dart';

// Global reference to activity bar navigation function
Function(int)? _globalActivityBarNavigator;

// ---------------------------------------------------------------------------
// Global controllers (owned outside ProviderScope so they can be passed as
// overrides AND used by FondeThemeManager in the same widget tree).
// ---------------------------------------------------------------------------
final _themeController = FondeThemeController(
  initialTheme: FondeThemePresets.system,
);
final _themeColorController = FondeThemeColorController();
final _accessibilityController = FondeAccessibilityController();
final _iconThemeController = FondeIconThemeController();

Future<void> main(List<String> args) async {
  Plough().debugLogEnabled = false;

  // Initialize Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('WidgetsFlutterBinding ensured');

  // Initialize debug logger (disabled by default)
  debugLogger.initialize(enabled: false);

  // Enabling development stacks is read from the configuration file, so
  // here we temporarily check command line arguments
  final enableDevStacks =
      args.contains('--enable-dev-stacks') ||
      const String.fromEnvironment(
            'ENABLE_DEV_STACKS',
            defaultValue: 'false',
          ) ==
          'true';

  await DesktopApp.run(
    arguments: args,
    mainWindowBuilder:
        () => DesktopAppApp(
          enableDevStacks: enableDevStacks,
          commandLineArgs: args,
        ),
  );
}

// Global NavigatorKey (used for settings dialogs, etc.)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Root app widget.
///
/// Creates [ProviderScope] with controller overrides, wraps with
/// [FondeThemeManager] to activate context.fondeColorScheme etc., then
/// builds the MaterialApp inside [_AppBody].
class DesktopAppApp extends StatelessWidget {
  const DesktopAppApp({
    super.key,
    this.enableDevStacks = false,
    this.commandLineArgs = const [],
  });

  final bool enableDevStacks;
  final List<String> commandLineArgs;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        // Expose Fonde controllers to Riverpod consumers.
        fondeThemeControllerProvider.overrideWithValue(_themeController),
        fondeThemeColorControllerProvider
            .overrideWithValue(_themeColorController),
        fondeAccessibilityControllerProvider
            .overrideWithValue(_accessibilityController),
        fondeIconThemeControllerProvider
            .overrideWithValue(_iconThemeController),
        // Set command line arguments
        commandLineArgsProvider.overrideWith(
          () => CommandLineArgs()..setArgs(commandLineArgs),
        ),
        // Override graphStorageProvider with activeStackGraphStorageProvider
        core_graph.graphStorageProvider.overrideWith((ref) {
          return ref.watch(activeStackGraphStorageProvider) ??
              (throw StateError('No active stack graph storage'));
        }),
      ],
      child: FondeThemeManager(
        themeController: _themeController,
        colorController: _themeColorController,
        accessibilityController: _accessibilityController,
        iconThemeController: _iconThemeController,
        defaultIconTheme: fondeDefaultIconTheme,
        child: _AppBody(
          enableDevStacks: enableDevStacks,
          commandLineArgs: commandLineArgs,
        ),
      ),
    );
  }
}

/// Inner widget that reads theme providers and builds the MaterialApp.
class _AppBody extends ConsumerWidget {
  const _AppBody({
    this.enableDevStacks = false,
    this.commandLineArgs = const [],
  });

  final bool enableDevStacks;
  final List<String> commandLineArgs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(effectiveThemeDataProvider);
    final themeMode = ref.watch(activeThemeProvider).theme.themeMode;

    // Persist & restore accessibility config via settings storage
    final accessibilityCtrl = ref.watch(fondeAccessibilityConfigProvider);
    _syncAccessibilityConfig(ref, accessibilityCtrl.config);

    // Persist & restore active theme via settings storage
    _syncActiveTheme(ref);

    return MaterialApp(
      title: 'RinneGraph',
      navigatorKey: navigatorKey,
      navigatorObservers: [ref.watch(dialogRouteObserverProvider)],
      theme: themeData,
      darkTheme: themeData,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: PlatformMenuBar(
        menus: MenuBuilder.buildMenus(context, ref, navigatorKey),
        child: ScaffoldMessenger(
          child: Scaffold(
            body: Material(
              type: MaterialType.canvas,
              child: MainAppShell(
                enableDevStacks: enableDevStacks,
                commandLineArgs: commandLineArgs,
                globalActivityBarNavigator: _globalActivityBarNavigator,
                navigatorKey: navigatorKey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Loads and applies saved accessibility config on first build.
  void _syncAccessibilityConfig(
    WidgetRef ref,
    FondeAccessibilityConfig current,
  ) {
    // Only load once (when still at default values).
    if (current != const FondeAccessibilityConfig()) return;
    Future.microtask(() async {
      final storage = ref.read(settingsStorageServiceProvider);
      final json = await storage.getString('accessibility_config');
      if (json != null && json.isNotEmpty) {
        try {
          final config = FondeAccessibilityConfig.fromJson(
            Map<String, dynamic>.from(
              (json as dynamic) is Map
                  ? json as Map<String, dynamic>
                  : <String, dynamic>{},
            ),
          );
          ref
              .read(fondeAccessibilityConfigProvider.notifier)
              .updateConfig(config);
        } catch (_) {}
      }
    });
  }

  /// Loads and applies saved theme name on first build.
  void _syncActiveTheme(WidgetRef ref) {
    Future.microtask(() async {
      final storage = ref.read(settingsStorageServiceProvider);
      final themeName = await storage.getString('active_theme_name') ?? '';
      if (themeName.isEmpty) return;
      final theme = FondeThemePresets.all.firstWhere(
        (t) => t.name == themeName,
        orElse: () => FondeThemePresets.system,
      );
      ref.read(fondeThemeControllerProvider).setTheme(theme);
    });
  }
}
