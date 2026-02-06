import 'dart:convert' as convert;
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:features_welcome/features_welcome.dart';
import 'package:core_themes/core_themes.dart' as core_themes;
import 'package:presentation_components/presentation_components.dart'; // For showAppDialog and AppText
import 'package:features_welcome/src/widgets/welcome_screen_dialogs.dart'; // For buildDialogFooterHelper
import '../providers/app_state_providers.dart';
import '../providers/shell_state_manager.dart';
import '../providers/ui_test_action_providers.dart';
import '../providers/dialog_visibility_providers.dart';
import 'command_result.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../main.dart';

import 'command_model.dart';
import 'command_registry.dart';

// ---- Small helpers for UI-test commands ----
Map<String, dynamic> _invokeUiAction(VoidCallback? action, String name) {
  if (action == null) {
    return {'ok': false, 'message': '$name action not available'};
  }
  WidgetsBinding.instance.addPostFrameCallback((_) => action());
  return {'ok': true};
}

Future<bool> _waitFor(
  bool Function() condition,
  int timeoutMs, {
  int pollMs = 50,
}) async {
  final stopwatch = Stopwatch()..start();
  while (stopwatch.elapsedMilliseconds < timeoutMs) {
    if (condition()) return true;
    await Future.delayed(Duration(milliseconds: pollMs));
  }
  return false;
}

/// Register core commands
void registerCoreCommands(WidgetRef ref) {
  final registry = ref.read(commandRegistryProvider.notifier);

  final commands = <AppCommand>[
    // 1) Select activity
    AppCommand(
      id: 'navigation.selectActivity',
      title: 'Select Activity',
      category: 'navigation',
      description: 'Select activity bar index',
      run: (ref, args) async {
        final index = (args['index'] as num?)?.toInt() ?? 0;
        ref.read(activityBarStateProvider.notifier).setIndex(index);
        return {'ok': true, 'selectedIndex': index};
      },
    ),

    // 2) Toggle/show/hide secondary sidebar
    AppCommand(
      id: 'sidebar.secondary.toggle',
      title: 'Toggle Secondary Sidebar',
      category: 'sidebar',
      run: (ref, args) async {
        ref.read(screenBasedSecondarySidebarStateProvider.notifier).toggle();
        return {'ok': true};
      },
    ),
    AppCommand(
      id: 'sidebar.secondary.show',
      title: 'Show Secondary Sidebar',
      category: 'sidebar',
      run: (ref, args) async {
        ref.read(screenBasedSecondarySidebarStateProvider.notifier).show();
        return {'ok': true};
      },
    ),
    AppCommand(
      id: 'sidebar.secondary.hide',
      title: 'Hide Secondary Sidebar',
      category: 'sidebar',
      run: (ref, args) async {
        ref.read(screenBasedSecondarySidebarStateProvider.notifier).hide();
        return {'ok': true};
      },
    ),

    // 3) Switch unified sidebar tab (0: browse / 1: search)
    AppCommand(
      id: 'unifiedSidebar.setTab',
      title: 'Set Unified Sidebar Tab',
      category: 'navigation',
      run: (ref, args) async {
        final tab = (args['tab'] as num?)?.toInt() ?? 0;
        ref.read(unifiedSidebarTabProvider.notifier).setTab(tab);
        return {'ok': true, 'tab': tab};
      },
    ),
    AppCommand(
      id: 'unifiedSidebar.setBrowse',
      title: 'Switch Unified Sidebar to Browse Tab',
      category: 'navigation',
      run: (ref, args) async {
        ref.read(unifiedSidebarTabProvider.notifier).setBrowseTab();
        return {'ok': true, 'tab': 0};
      },
    ),
    AppCommand(
      id: 'unifiedSidebar.setSearch',
      title: 'Switch Unified Sidebar to Search Tab',
      category: 'navigation',
      run: (ref, args) async {
        ref.read(unifiedSidebarTabProvider.notifier).setSearchTab();
        return {'ok': true, 'tab': 1};
      },
    ),

    // 4) Explicitly set secondary sidebar visibility state
    AppCommand(
      id: 'sidebar.secondary.setVisible',
      title: 'Set Secondary Sidebar Visibility',
      category: 'sidebar',
      run: (ref, args) async {
        final visible = (args['visible'] as bool?) ?? true;
        ref
            .read(screenBasedSecondarySidebarStateProvider.notifier)
            .setVisible(visible);
        return {'ok': true, 'visible': visible};
      },
    ),

    // 5) State snapshot (for UI test verification)
    AppCommand(
      id: 'app.state.snapshot',
      title: 'Get App State Snapshot',
      category: 'utility',
      run: (ref, args) async {
        final activity = ref.read(activityBarStateProvider);
        final tab = ref.read(unifiedSidebarTabProvider);
        final secondaryVisible = ref.read(
          screenBasedSecondarySidebarStateProvider,
        );
        return {
          'ok': true,
          'activityIndex': activity,
          'unifiedSidebarTab': tab,
          'secondarySidebarVisible': secondaryVisible,
        };
      },
    ),

    // 6) Screenshot (works only when screenshot_server is enabled)
    AppCommand(
      id: 'app.screenshot',
      title: 'Save Screenshot',
      category: 'utility',
      description:
          'Enabled at startup with ENABLE_SCREENSHOT_SERVER=true (proxied to /screenshot)',
      run: _screenshot,
    ),

    // 7) App version information
    AppCommand(
      id: 'app.version',
      title: 'Get App Version Information',
      category: 'utility',
      run: (ref, args) async {
        final info = await PackageInfo.fromPlatform();
        return {
          'ok': true,
          'data': {
            'appName': info.appName,
            'packageName': info.packageName,
            'version': info.version,
            'buildNumber': info.buildNumber,
            'buildSignature': info.buildSignature,
          },
        };
      },
    ),

    // 8) Shell state snapshot (test helper)
    AppCommand(
      id: 'app.state.shell',
      title: 'Get Shell Internal Flags',
      category: 'utility',
      run: (ref, args) async {
        final shell = ref.read(shellStateManagerProvider);

        return {
          'ok': true,
          'commandsRegistered': shell.commandsRegistered,
          'screenshotServerStarted': shell.screenshotServerStarted,
          'devStacksImported': shell.devStacksImported,
          'remoteCommandServerStarted': shell.remoteCommandServerStarted,
          'importantDialogOpen': shell.importantDialogOpen,
          'importantDialogTag': shell.importantDialogTag,
        };
      },
    ),

    // 9) Sleep (wait/test helper)
    AppCommand(
      id: 'app.util.sleep',
      title: 'Wait for Specified Milliseconds',
      category: 'utility',
      run: (ref, args) async {
        final ms = (args['ms'] as num?)?.toInt() ?? 300;
        await Future.delayed(Duration(milliseconds: ms));
        return {'ok': true, 'sleptMs': ms};
      },
    ),

    // 10) Ping (operation check)
    const AppCommand(
      id: 'app.ping',
      title: 'Ping',
      category: 'utility',
      run: _ping,
    ),

    // 10.5) Confirmation dialog: Cancel pressed (pop(false) top)
    AppCommand(
      id: 'ui.confirm.cancel',
      title: 'Confirmation Dialog: Cancel Pressed',
      category: 'ui',
      run: (ref, args) async {
        final nav = navigatorKey.currentState;
        if (nav != null && nav.canPop()) {
          WidgetsBinding.instance.addPostFrameCallback((_) => nav.pop(false));
          return {'ok': true, 'closed': true};
        }
        return {
          'ok': false,
          'closed': false,
          'message': 'No confirmation dialog open',
        };
      },
    ),

    // 10.6) Confirmation dialog: OK pressed (pop(true) top)
    AppCommand(
      id: 'ui.confirm.ok',
      title: 'Confirmation Dialog: OK Pressed',
      category: 'ui',
      run: (ref, args) async {
        final nav = navigatorKey.currentState;
        if (nav != null && nav.canPop()) {
          WidgetsBinding.instance.addPostFrameCallback((_) => nav.pop(true));
          return {'ok': true, 'closed': true};
        }
        return {
          'ok': false,
          'closed': false,
          'message': 'No confirmation dialog open',
        };
      },
    ),

    // 10.7) Dialog general: Is anything open
    AppCommand(
      id: 'ui.dialog.isAnyOpen',
      title: 'Dialog: Is Anything Open',
      category: 'ui',
      run: (ref, args) async {
        final anyOpen = ref.read(anyDialogOpenProvider);
        final count = ref.read(dialogRouteCountProvider);
        return {'ok': true, 'anyOpen': anyOpen, 'count': count};
      },
    ),

    // 10.8) Dialog general: Wait until open
    AppCommand(
      id: 'ui.dialog.waitAnyOpen',
      title: 'Dialog: Wait Until Open',
      category: 'ui',
      description: '{ timeoutMs?: number } (default: 5000)',
      run: (ref, args) async {
        final timeoutMs = (args['timeoutMs'] as num?)?.toInt() ?? 5000;
        final ok = await _waitFor(
          () => ref.read(anyDialogOpenProvider) == true,
          timeoutMs,
        );
        if (ok) return {'ok': true, 'anyOpen': true};
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'message': 'Timeout waiting for any dialog to open',
        };
      },
    ),

    // 10.9) Dialog general: Wait until all closed
    AppCommand(
      id: 'ui.dialog.waitAllClosed',
      title: 'Dialog: Wait Until All Closed',
      category: 'ui',
      description: '{ timeoutMs?: number } (default: 5000)',
      run: (ref, args) async {
        final timeoutMs = (args['timeoutMs'] as num?)?.toInt() ?? 5000;
        final ok = await _waitFor(
          () => ref.read(dialogRouteCountProvider) == 0,
          timeoutMs,
        );
        if (ok) return {'ok': true, 'anyOpen': false};
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'message': 'Timeout waiting for all dialogs to close',
        };
      },
    ),

    // 10.10) Important dialog: Mark next dialog as important
    AppCommand(
      id: 'ui.dialog.markNextAsImportant',
      title: 'Dialog: Mark Next as Important',
      category: 'ui',
      description: '{ tag?: string }',
      run: (ref, args) async {
        final tag = (args['tag'] as String?) ?? 'important';
        ref.read(nextImportantDialogTagProvider.notifier).state = tag;
        return {'ok': true, 'tag': tag};
      },
    ),

    // 10.11) Important dialog: Current state
    AppCommand(
      id: 'ui.dialog.isImportantOpen',
      title: 'Dialog: Important Dialog State',
      category: 'ui',
      run: (ref, args) async {
        final shell = ref.read(shellStateManagerProvider);
        return {
          'ok': true,
          'open': shell.importantDialogOpen,
          'tag': shell.importantDialogTag,
        };
      },
    ),

    // 10.12) Important dialog: Wait until open
    AppCommand(
      id: 'ui.dialog.waitImportantOpen',
      title: 'Dialog: Wait Until Important Opens',
      category: 'ui',
      description: '{ timeoutMs?: number } (default: 5000)',
      run: (ref, args) async {
        final timeoutMs = (args['timeoutMs'] as num?)?.toInt() ?? 5000;
        final ok = await _waitFor(
          () => ref.read(shellStateManagerProvider).importantDialogOpen == true,
          timeoutMs,
        );
        if (ok) {
          return {
            'ok': true,
            'open': true,
            'tag': ref.read(shellStateManagerProvider).importantDialogTag,
          };
        }
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'message': 'Timeout waiting for important dialog to open',
        };
      },
    ),

    // 10.13) Important dialog: Wait until closed
    AppCommand(
      id: 'ui.dialog.waitImportantClosed',
      title: 'Dialog: Wait Until Important Closes',
      category: 'ui',
      description: '{ timeoutMs?: number } (default: 5000)',
      run: (ref, args) async {
        final timeoutMs = (args['timeoutMs'] as num?)?.toInt() ?? 5000;
        final ok = await _waitFor(
          () =>
              ref.read(shellStateManagerProvider).importantDialogOpen == false,
          timeoutMs,
        );
        if (ok) return {'ok': true, 'open': false};
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'message': 'Timeout waiting for important dialog to close',
        };
      },
    ),

    // 11) Show welcome dialog

    // 10.14) Dialog general: Close top dialog (arbitrary return value)
    AppCommand(
      id: 'ui.dialog.closeTop',
      title: 'Dialog: Close Top',
      category: 'ui',
      description: '{ result?: any }',
      run: (ref, args) async {
        final nav = navigatorKey.currentState;
        final anyOpen = ref.read(anyDialogOpenProvider);
        if (nav != null && nav.canPop() && anyOpen) {
          final result = args['result'];
          WidgetsBinding.instance.addPostFrameCallback((_) => nav.pop(result));
          return {'ok': true, 'closed': true};
        }
        return {'ok': false, 'closed': false, 'message': 'No dialog open'};
      },
    ),

    // 10.15) Dialog general: Wait until count matches
    AppCommand(
      id: 'ui.dialog.waitCount',
      title: 'Dialog: Wait Until Specified Count',
      category: 'ui',
      description: '{ count: number, timeoutMs?: number } (default: 5000)',
      run: (ref, args) async {
        final target = (args['count'] as num?)?.toInt();
        if (target == null) {
          return {
            'ok': false,
            'code': CommandResultCode.badParams,
            'message': 'count is required',
          };
        }
        final timeoutMs = (args['timeoutMs'] as num?)?.toInt() ?? 5000;
        final ok = await _waitFor(
          () => ref.read(dialogRouteCountProvider) == target,
          timeoutMs,
        );
        if (ok) {
          return {'ok': true, 'count': ref.read(dialogRouteCountProvider)};
        }
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'message': 'Timeout waiting for dialog count == $target',
        };
      },
    ),

    // 10.16) Dialog general: Mark next as important → wait until open
    AppCommand(
      id: 'ui.dialog.awaitNextOpen',
      title: 'Dialog: Mark Next as Important and Wait Until Open',
      category: 'ui',
      description: '{ tag?: string, timeoutMs?: number } (default: 5000)',
      run: (ref, args) async {
        final tag = (args['tag'] as String?) ?? 'important';
        final timeoutMs = (args['timeoutMs'] as num?)?.toInt() ?? 5000;
        ref.read(nextImportantDialogTagProvider.notifier).state = tag;
        final ok = await _waitFor(
          () => ref.read(shellStateManagerProvider).importantDialogOpen,
          timeoutMs,
        );
        if (ok) {
          return {
            'ok': true,
            'open': true,
            'tag': ref.read(shellStateManagerProvider).importantDialogTag,
          };
        }
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'message': 'Timeout waiting for next important dialog to open',
        };
      },
    ),

    AppCommand(
      id: 'welcome.showDialog',
      title: 'Show Welcome Dialog',
      category: 'welcome',
      run: (ref, args) async {
        final ctx = navigatorKey.currentContext;
        if (ctx == null) return {'ok': false, 'message': 'context is null'};

        final activeStack = ref.read(core_stack.activeStackProvider);

        if (activeStack != null) {
          // Show confirmation dialog before closing the active stack
          final confirmed = await showAppDialog<bool>(
            context: ctx,
            title: '現在のスタックの変更を破棄しますか？',
            child: const AppText(
              'ウェルカム画面に戻ると、現在開いているスタックは閉じられ、未保存の変更は失われます。',
              variant: AppTextVariant.bodyText,
            ),
            footer: buildDialogFooterHelper(
              colorScheme: ref.read(core_themes.effectiveColorSchemeProvider),
              cancelLabel: 'キャンセル',
              confirmLabel: '破棄して続行',
              isDestructive: true,
              onCancel: () => Navigator.of(ctx).pop(false),
              onConfirm: () => Navigator.of(ctx).pop(true),
            ),
          );

          if (confirmed == true) {
            ref.read(core_stack.activeStackProvider.notifier).setStack(null);
          }
        } else {
          // No active stack, just show the welcome screen
          ref.read(core_stack.activeStackProvider.notifier).setStack(null);
        }
        return {'ok': true};
      },
    ),

    // 12) Close welcome dialog
    AppCommand(
      id: 'welcome.closeDialog',
      title: 'Close Welcome Dialog',
      category: 'welcome',
      run: (ref, args) async {
        final nav = navigatorKey.currentState;
        if (nav != null && nav.canPop()) {
          nav.pop();
          ref.read(welcomeDialogShowingProvider.notifier).state = false;
          return {'ok': true, 'closed': true};
        }
        return {'ok': false, 'closed': false, 'message': 'No dialog open'};
      },
    ),

    // 13) Show import dialog
    AppCommand(
      id: 'welcome.importDialog.show',
      title: 'Show Import Dialog',
      category: 'welcome',
      run: (ref, args) async {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ctx = navigatorKey.currentContext;
          if (ctx != null) {
            ref.read(importDialogShowingProvider.notifier).state = true;
            showImportDialog(ctx);
          }
        });
        return {'ok': true};
      },
    ),

    // 13.5) Import dialog: Cancel pressed (pop top)
    AppCommand(
      id: 'welcome.importDialog.cancel',
      title: 'Import Dialog: Cancel Pressed',
      category: 'welcome',
      run: (ref, args) async {
        final nav = navigatorKey.currentState;
        if (nav != null && nav.canPop()) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            nav.pop();
            ref.read(importDialogShowingProvider.notifier).state = false;
          });
          return {'ok': true, 'closed': true};
        }
        return {
          'ok': false,
          'closed': false,
          'message': 'No import dialog open',
        };
      },
    ),

    // 13.6) Import dialog visibility state
    AppCommand(
      id: 'welcome.importDialog.isVisible',
      title: 'Import Dialog: Visibility State',
      category: 'welcome',
      run: (ref, args) async {
        final visible = ref.read(importDialogShowingProvider);
        return {'ok': true, 'visible': visible};
      },
    ),

    // 13.7) Wait until import dialog is visible
    AppCommand(
      id: 'welcome.importDialog.waitVisible',
      title: 'Import Dialog: Wait Until Visible',
      category: 'welcome',
      description: '{ timeoutMs?: number } (default: 5000)',
      run: (ref, args) async {
        final timeoutMs = (args['timeoutMs'] as num?)?.toInt() ?? 5000;
        final ok = await _waitFor(
          () => ref.read(importDialogShowingProvider) == true,
          timeoutMs,
        );
        if (ok) return {'ok': true, 'visible': true};
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'message': 'Timeout waiting for import dialog to become visible',
        };
      },
    ),

    // 13.8) Wait until import dialog is closed
    AppCommand(
      id: 'welcome.importDialog.waitClosed',
      title: 'Import Dialog: Wait Until Closed',
      category: 'welcome',
      description: '{ timeoutMs?: number } (default: 5000)',
      run: (ref, args) async {
        final timeoutMs = (args['timeoutMs'] as num?)?.toInt() ?? 5000;
        final ok = await _waitFor(
          () => ref.read(importDialogShowingProvider) == false,
          timeoutMs,
        );
        if (ok) return {'ok': true, 'visible': false};
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'message': 'Timeout waiting for import dialog to close',
        };
      },
    ),

    // 14) Show target selection dialog
    AppCommand(
      id: 'welcome.targetSelection.show',
      title: 'Show Target Selection Dialog',
      category: 'welcome',
      run: (ref, args) async {
        final ctx = navigatorKey.currentContext;
        if (ctx == null) return {'ok': false, 'message': 'context is null'};
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showTargetSelectionDialog(ctx);
        });
        return {'ok': true};
      },
    ),

    // 14.5) Target selection dialog: Cancel (pop top)
    AppCommand(
      id: 'welcome.targetSelection.cancel',
      title: 'Target Selection Dialog: Cancel',
      category: 'welcome',
      run: (ref, args) async {
        final nav = navigatorKey.currentState;
        if (nav != null && nav.canPop()) {
          WidgetsBinding.instance.addPostFrameCallback((_) => nav.pop());
          return {'ok': true, 'closed': true};
        }
        return {
          'ok': false,
          'closed': false,
          'message': 'No target selection dialog open',
        };
      },
    ),

    // 14.6) Target selection dialog visibility state
    AppCommand(
      id: 'welcome.targetSelection.isVisible',
      title: 'Target Selection Dialog: Visibility State',
      category: 'welcome',
      run: (ref, args) async {
        final visible = ref.read(targetSelectionDialogShowingProvider);
        return {'ok': true, 'visible': visible};
      },
    ),

    // 14.7) Target selection dialog: Wait until visible
    AppCommand(
      id: 'welcome.targetSelection.waitVisible',
      title: 'Target Selection Dialog: Wait Until Visible',
      category: 'welcome',
      description: '{ timeoutMs?: number } (default: 5000)',
      run: (ref, args) async {
        final timeoutMs = (args['timeoutMs'] as num?)?.toInt() ?? 5000;
        final ok = await _waitFor(
          () => ref.read(targetSelectionDialogShowingProvider) == true,
          timeoutMs,
        );
        if (ok) return {'ok': true, 'visible': true};
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'message': 'Timeout waiting for target selection dialog to open',
        };
      },
    ),

    // 14.8) Target selection dialog: Wait until closed
    AppCommand(
      id: 'welcome.targetSelection.waitClosed',
      title: 'Target Selection Dialog: Wait Until Closed',
      category: 'welcome',
      description: '{ timeoutMs?: number } (default: 5000)',
      run: (ref, args) async {
        final timeoutMs = (args['timeoutMs'] as num?)?.toInt() ?? 5000;
        final ok = await _waitFor(
          () => ref.read(targetSelectionDialogShowingProvider) == false,
          timeoutMs,
        );
        if (ok) return {'ok': true, 'visible': false};
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'message': 'Timeout waiting for target selection dialog to close',
        };
      },
    ),

    // 14.9) Target selection dialog: Select index
    AppCommand(
      id: 'welcome.targetSelection.selectIndex',
      title: 'Target Selection Dialog: Select Index',
      category: 'welcome',
      description: '{ index: number }',
      run: (ref, args) async {
        final index = (args['index'] as num?)?.toInt();
        if (index == null) {
          return {
            'ok': false,
            'code': CommandResultCode.badParams,
            'message': 'index is required',
          };
        }
        final actions = ref.read(targetSelectionDialogTestActionsProvider);
        if (actions.selectIndex == null) {
          return {'ok': false, 'message': 'selectIndex action not available'};
        }
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => actions.selectIndex!(index),
        );
        return {'ok': true, 'selectedIndex': index};
      },
    ),

    // 14.10) Target selection dialog: OK confirm
    AppCommand(
      id: 'welcome.targetSelection.ok',
      title: 'Target Selection Dialog: OK Confirm',
      category: 'welcome',
      run: (ref, args) async {
        final actions = ref.read(targetSelectionDialogTestActionsProvider);
        if (actions.confirm == null) {
          return {'ok': false, 'message': 'confirm action not available'};
        }
        WidgetsBinding.instance.addPostFrameCallback((_) => actions.confirm!());
        return {'ok': true, 'confirmed': true};
      },
    ),

    // 14) Welcome screen: Test action (Import)
    AppCommand(
      id: 'welcome.action.import',
      title: 'Welcome: Import Pressed',
      category: 'welcome',
      run: (ref, args) async {
        final actions = ref.read(welcomeDialogTestActionsProvider);
        return _invokeUiAction(actions.pressImport, 'Import');
      },
    ),

    // 15) Welcome screen: Test action (Close)
    AppCommand(
      id: 'welcome.action.close',
      title: 'Welcome: Close Pressed',
      category: 'welcome',
      run: (ref, args) async {
        final actions = ref.read(welcomeDialogTestActionsProvider);
        return _invokeUiAction(actions.pressClose, 'Close');
      },
    ),

    // 16) Welcome screen: Test action (Create New)
    AppCommand(
      id: 'welcome.action.createNew',
      title: 'Welcome: Create New Pressed',
      category: 'welcome',
      run: (ref, args) async {
        final actions = ref.read(welcomeDialogTestActionsProvider);
        return _invokeUiAction(actions.pressCreateNew, 'CreateNew');
      },
    ),

    // 17) Welcome screen: Test action (Open)
    AppCommand(
      id: 'welcome.action.open',
      title: 'Welcome: Open Existing Pressed',
      category: 'welcome',
      run: (ref, args) async {
        final actions = ref.read(welcomeDialogTestActionsProvider);
        return _invokeUiAction(actions.pressOpen, 'Open');
      },
    ),

    // 18) Return welcome dialog visibility state
    AppCommand(
      id: 'welcome.isVisible',
      title: 'Welcome: Return Visibility State',
      category: 'welcome',
      run: (ref, args) async {
        final visible = ref.read(welcomeDialogShowingProvider);
        return {'ok': true, 'visible': visible};
      },
    ),

    // 19) Wait until welcome is visible
    AppCommand(
      id: 'welcome.waitVisible',
      title: 'Welcome: Wait Until Visible',
      category: 'welcome',
      description: '{ timeoutMs?: number } (default: 5000)',
      run: (ref, args) async {
        final timeoutMs = (args['timeoutMs'] as num?)?.toInt() ?? 5000;
        final ok = await _waitFor(
          () => ref.read(welcomeDialogShowingProvider) == true,
          timeoutMs,
        );
        if (ok) return {'ok': true, 'visible': true};
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'message': 'Timeout waiting for welcome dialog to become visible',
        };
      },
    ),

    // 20) Wait for welcome to close
    AppCommand(
      id: 'welcome.waitClosed',
      title: 'Wait for welcome to close',
      category: 'welcome',
      description: '{ timeoutMs?: number } (default: 5000)',
      run: (ref, args) async {
        final timeoutMs = (args['timeoutMs'] as num?)?.toInt() ?? 5000;
        final ok = await _waitFor(
          () => ref.read(welcomeDialogShowingProvider) == false,
          timeoutMs,
        );
        if (ok) return {'ok': true, 'visible': false};
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'message': 'Timeout waiting for welcome dialog to close',
        };
      },
    ),
  ];

  registry.registerAll(commands);
}

Future<dynamic> _ping(WidgetRef ref, Map<String, dynamic> _) async {
  return {'ok': true, 'timestamp': DateTime.now().toIso8601String()};
}

Future<dynamic> _screenshot(WidgetRef ref, Map<String, dynamic> args) async {
  final filename = args['filename'] as String?;
  final client = io.HttpClient();
  try {
    final uri = Uri.parse('http://localhost:8080/screenshot');
    final req = await client.postUrl(uri);
    req.headers.set('Content-Type', 'application/json');
    final body = <String, dynamic>{};
    if (filename != null) body['filename'] = filename;
    req.write(convert.jsonEncode(body));
    final resp = await req.close();
    final text = await resp.transform(convert.utf8.decoder).join();
    final parsed = text.isNotEmpty ? convert.jsonDecode(text) : null;
    return {
      'ok': resp.statusCode == 200,
      'statusCode': resp.statusCode,
      'result': parsed,
    };
  } catch (e) {
    return {'ok': false, 'error': e.toString()};
  } finally {
    client.close(force: true);
  }
}
