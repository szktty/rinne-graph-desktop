import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:app/app.dart';
import 'package:plough/plough.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart' as core_themes;
import 'package:macos_ui/macos_ui.dart' as macos_ui;
import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import 'package:core_app_config/core_app_config.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;

import 'src/widgets/menu_builder.dart';
import 'src/widgets/main_app_shell.dart';
import 'src/providers/dialog_visibility_providers.dart';
import 'src/providers/graph_providers.dart';

// Global reference to activity bar navigation function
Function(int)? _globalActivityBarNavigator;

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

  // macOS UI settings
  // Initialization of macos_ui package is not required

  // Main window settings are handled within DesktopApp

  await DesktopApp.run(
    arguments: args,
    mainWindowBuilder:
        () => DesktopAppApp(
          enableDevStacks: enableDevStacks,
          commandLineArgs: args,
        ),
  );
}

// AppApp with ProviderScope for Riverpod
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
    // Wrap with ProviderScope to enable Riverpod state management
    return ProviderScope(
      overrides: [
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
      child: _AppMaterialApp(
        enableDevStacks: enableDevStacks,
        commandLineArgs: commandLineArgs,
      ),
    );
  }
}

// Global NavigatorKey (used for settings dialogs, etc.)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// _AppMaterialApp with PlatformMenuBar for macOS
class _AppMaterialApp extends ConsumerWidget {
  const _AppMaterialApp({
    this.enableDevStacks = false,
    this.commandLineArgs = const [],
  });

  final bool enableDevStacks;
  final List<String> commandLineArgs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeData = ref.watch(core_themes.activeThemeProvider);
    final themeMode = appThemeData.themeMode;
    debugPrint('themeMode: $themeMode');

    // Basic settings for keyboard shortcuts
    final finalShortcuts = <ShortcutActivator, Intent>{};
    final finalActions = <Type, Action<Intent>>{};

    // Use new color scheme system
    final colorScheme = ref.watch(
      core_themes.effectiveColorSchemeWithThemeProvider,
    );
    final themeData = ref.watch(core_themes.effectiveThemeDataProvider);
    final flutterColorScheme = ref.watch(
      core_themes.effectiveFlutterColorSchemeProvider,
    );

    // Build app depending on platform
    if (Platform.isMacOS) {
      // Add macOS specific PlatformMenuBar
      // Apply app-specific theme while using MacosThemeData

      return macos_ui.MacosApp(
        title: 'App',
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        navigatorObservers: [ref.watch(dialogRouteObserverProvider)],
        home: PlatformMenuBar(
          menus: MenuBuilder.buildMenus(context, ref, navigatorKey),
          child: ScaffoldMessenger(
            child: Scaffold(
              // Provide Scaffold and ScaffoldMessenger
              body: Material(
                // Provide Material context
                type: MaterialType.canvas,
                child: Theme(
                  // Apply Material theme on top of MacosApp
                  data: themeData.copyWith(
                    colorScheme: flutterColorScheme,
                    textTheme: themeData.textTheme,
                  ),
                  child: Shortcuts(
                    shortcuts: finalShortcuts,
                    child: Actions(
                      actions: finalActions,
                      child: ProviderScope(
                        overrides: [
                          core_themes.defaultColorScopeProvider
                              .overrideWithValue(
                                core_themes.ColorScope(
                                  text: colorScheme.base.foreground,
                                  background: colorScheme.base.background,
                                  border: colorScheme.base.border,
                                  selection: colorScheme.base.selection,
                                  hover: colorScheme.base.selection.withValues(
                                    alpha: 0.1,
                                  ),
                                  accent: colorScheme.theme.primaryColor,
                                  disabled: colorScheme.base.foreground
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                        ],
                        child: MainAppShell(
                          enableDevStacks: enableDevStacks,
                          commandLineArgs: commandLineArgs,
                          globalActivityBarNavigator:
                              _globalActivityBarNavigator,
                          navigatorKey: navigatorKey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      // MaterialApp for Windows/Linux
      // Use standard MaterialApp, not macOS specific PlatformMenuBar
      return MaterialApp(
        title: 'App',
        navigatorKey: navigatorKey,
        navigatorObservers: [ref.watch(dialogRouteObserverProvider)],
        theme: themeData.copyWith(
          colorScheme: flutterColorScheme,
          textTheme: themeData.textTheme,
        ),
        darkTheme: themeData.copyWith(
          colorScheme: flutterColorScheme,
          textTheme: themeData.textTheme,
        ),
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        shortcuts: finalShortcuts,
        actions: finalActions,
        home: ProviderScope(
          overrides: [
            core_themes.defaultColorScopeProvider.overrideWithValue(
              core_themes.ColorScope(
                text: colorScheme.base.foreground,
                background: colorScheme.base.background,
                border: colorScheme.base.border,
                selection: colorScheme.base.selection,
                hover: colorScheme.base.selection.withValues(alpha: 0.1),
                accent: colorScheme.theme.primaryColor,
                disabled: colorScheme.base.foreground.withValues(alpha: 0.3),
              ),
            ),
          ],
          child: MainAppShell(
            enableDevStacks: enableDevStacks,
            commandLineArgs: commandLineArgs,
            globalActivityBarNavigator: _globalActivityBarNavigator,
            navigatorKey: navigatorKey,
          ),
        ),
      );
    }
  }
}
