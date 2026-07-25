/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:convert' as convert;
import 'dart:io' as io;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:plough/plough.dart' as plough;
import 'package:features_welcome/features_welcome.dart';
import 'package:core_themes/core_themes.dart' as core_themes;
import 'package:presentation_components/presentation_components.dart';
import 'package:features_welcome/src/widgets/welcome_screen_dialogs.dart';
import 'package:app/app.dart'
    show selectedActivityItemProvider, AppActivityItemType;
import 'package:features_record_editor/record_editor.dart' as record_editor;
import 'package:features_import_export/features_import_export.dart'
    as import_export;
import 'package:core_samples/core_samples.dart' as core_samples;
import '../widgets/app_node_renderer.dart';
import '../providers/app_state_providers.dart';
import '../providers/entity_selection_bridge_providers.dart'
    show graphLoadingStateProvider;
import '../providers/open_stacks_providers.dart';
import '../providers/graph_providers.dart';
import '../providers/search_providers.dart';
import '../providers/selection_providers.dart';
import '../providers/shell_state_manager.dart';
import '../providers/ui_test_action_providers.dart';
import '../providers/dialog_visibility_providers.dart';
import '../providers/view_toolbar_providers.dart';
import '../events/selection_events.dart';
import '../enums/activity_bar_index.dart';
import '../models/search_models.dart';
import '../services/search_execution_service.dart';
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
      title: 'Toggle Secondary FondeSidebar',
      category: 'sidebar',
      run: (ref, args) async {
        ref.read(screenBasedSecondarySidebarStateProvider.notifier).toggle();
        return {'ok': true};
      },
    ),
    AppCommand(
      id: 'sidebar.secondary.show',
      title: 'Show Secondary FondeSidebar',
      category: 'sidebar',
      run: (ref, args) async {
        ref.read(screenBasedSecondarySidebarStateProvider.notifier).show();
        return {'ok': true};
      },
    ),
    AppCommand(
      id: 'sidebar.secondary.hide',
      title: 'Hide Secondary FondeSidebar',
      category: 'sidebar',
      run: (ref, args) async {
        ref.read(screenBasedSecondarySidebarStateProvider.notifier).hide();
        return {'ok': true};
      },
    ),

    // 3) Switch unified sidebar tab (0: browse / 1: search)
    AppCommand(
      id: 'unifiedFondeSidebar.setTab',
      title: 'Set Unified FondeSidebar Tab',
      category: 'navigation',
      run: (ref, args) async {
        final tab = (args['tab'] as num?)?.toInt() ?? 0;
        ref.read(unifiedSidebarTabProvider.notifier).setTab(tab);
        return {'ok': true, 'tab': tab};
      },
    ),
    AppCommand(
      id: 'unifiedFondeSidebar.setBrowse',
      title: 'Switch Unified FondeSidebar to Browse Tab',
      category: 'navigation',
      run: (ref, args) async {
        ref.read(unifiedSidebarTabProvider.notifier).setBrowseTab();
        return {'ok': true, 'tab': 0};
      },
    ),
    AppCommand(
      id: 'unifiedFondeSidebar.setSearch',
      title: 'Switch Unified FondeSidebar to Search Tab',
      category: 'navigation',
      run: (ref, args) async {
        ref.read(unifiedSidebarTabProvider.notifier).setSearchTab();
        return {'ok': true, 'tab': 1};
      },
    ),

    // 4) Explicitly set secondary sidebar visibility state
    AppCommand(
      id: 'sidebar.secondary.setVisible',
      title: 'Set Secondary FondeSidebar Visibility',
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
        final graphNavTab = ref.read(graphNavigatorTabProvider);
        final secondaryVisible = ref.read(
          screenBasedSecondarySidebarStateProvider,
        );
        return {
          'ok': true,
          'activityIndex': activity,
          'unifiedSidebarTab': tab,
          'graphNavigatorTab': graphNavTab,
          'secondarySidebarVisible': secondaryVisible,
        };
      },
    ),

    // 6) Screenshot
    AppCommand(
      id: 'app.screenshot',
      title: 'Save Screenshot',
      category: 'utility',
      description: 'Captures a screenshot of the app window',
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
          'screenshotServerStarted': true,
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
  registry.registerAll(_stackCommands());
  registry.registerAll(_graphCommands());
  registry.registerAll(_recordEditorCommands());
  registry.registerAll(_exchangeCommands());
}

// ---------------------------------------------------------------------------
// Stack commands
// ---------------------------------------------------------------------------

List<AppCommand> _stackCommands() => [
  AppCommand(
    id: 'stack.list',
    title: 'List Available Stacks',
    category: 'stack',
    description: 'Returns all available (non-archived) user stacks',
    run: (ref, args) async {
      final stacks = await ref.read(
        core_stack.availableStacksListProvider.future,
      );
      return {
        'ok': true,
        'stacks':
            stacks
                .map(
                  (s) => {
                    'name': s.info.name,
                    'path': s.directory.path,
                    'description': s.info.description,
                    'tags': s.info.tags,
                  },
                )
                .toList(),
      };
    },
  ),

  AppCommand(
    id: 'stack.list_samples',
    title: 'List Sample Stacks',
    category: 'stack',
    description: 'Returns all instantiated sample stacks',
    run: (ref, args) async {
      final stacks = await ref.read(core_stack.sampleStacksListProvider.future);
      return {
        'ok': true,
        'stacks':
            stacks
                .map(
                  (s) => {
                    'name': s.info.name,
                    'path': s.directory.path,
                    'description': s.info.description,
                    'tags': s.info.tags,
                    'template_id': s.info.sampleTemplateId,
                  },
                )
                .toList(),
      };
    },
  ),

  AppCommand(
    id: 'stack.list_templates',
    title: 'List Stack Templates',
    category: 'stack',
    description:
        'Returns all available built-in stack templates (not yet instantiated)',
    run: (ref, args) async {
      final templates = ref.read(core_samples.stackTemplateManifestsProvider);
      return {
        'ok': true,
        'templates':
            templates
                .map(
                  (t) => {
                    'id': t.id,
                    'name': t.displayName,
                    'description': t.description,
                    'tags': t.tags,
                    'category': t.category,
                    'language': t.language,
                  },
                )
                .toList(),
      };
    },
  ),

  AppCommand(
    id: 'stack.instantiate_template',
    title: 'Instantiate Stack Template',
    category: 'stack',
    description:
        '{ template_id: string, stack_name?: string } — instantiate a template into the Samples directory',
    run: (ref, args) async {
      final templateId = args['template_id'] as String?;
      if (templateId == null) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'template_id is required',
        };
      }
      final template = core_samples.StackTemplateService.getStackTemplateById(
        templateId,
      );
      if (template == null) {
        return {
          'ok': false,
          'code': CommandResultCode.notFound,
          'error': 'template not found: $templateId',
        };
      }
      final samplesDir = await ref.read(
        core_stack.samplesDirectoryProvider.future,
      );
      final stackName = args['stack_name'] as String? ?? template.displayName;
      final resultPath = await core_samples
          .StackTemplateService.generateStackFromTemplate(
        template: template,
        outputDirectory: samplesDir,
        stackName: stackName,
        isSample: true,
      );
      if (resultPath == null) {
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'error': 'failed to instantiate template: $templateId',
        };
      }
      ref.invalidate(core_stack.sampleStacksListProvider);
      return {'ok': true, 'path': resultPath};
    },
  ),

  AppCommand(
    id: 'stack.open',
    title: 'Open Stack',
    category: 'stack',
    description: '{ path: string }',
    run: (ref, args) async {
      // SECURITY: accepts arbitrary file paths. Before enabling on release
      // builds, replace with a stack-ID lookup so only known stacks can open.
      final path = args['path'] as String?;
      if (path == null) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'path is required',
        };
      }
      final stackDir = io.Directory(path);
      if (!await stackDir.exists()) {
        return {
          'ok': false,
          'code': CommandResultCode.notFound,
          'error': 'stack directory not found: $path',
        };
      }
      final metadataService = core_stack.StackMetadataService();
      final (info, settings) = await metadataService.loadMetadata(stackDir);
      if (info == null) {
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'error': 'failed to load stack metadata: $path',
        };
      }
      final stack = core_stack.Stack(
        directory: stackDir,
        info: info,
        settings: settings ?? const core_stack.StackSettings(),
      );
      ref.read(core_stack.activeStackProvider.notifier).setStack(stack);
      ref.read(openStacksActionsProvider.notifier).addStack(stack);
      ref
          .read(activityBarStateProvider.notifier)
          .setIndex(ActivityBarIndex.graphNavigation.value);
      return {'ok': true, 'stack_path': stack.directory.path};
    },
  ),

  AppCommand(
    id: 'stack.close',
    title: 'Close Stack',
    category: 'stack',
    canExecute: (ref) => ref.read(core_stack.activeStackProvider) != null,
    run: (ref, args) async {
      ref.read(core_stack.activeStackProvider.notifier).clearStack();
      return {'ok': true};
    },
  ),

  AppCommand(
    id: 'stack.navigate',
    title: 'Navigate to Screen',
    category: 'stack',
    description: '{ screen: "welcome" | "editor" }',
    run: (ref, args) async {
      final screen = args['screen'] as String?;
      if (screen == null) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'screen is required',
        };
      }
      switch (screen) {
        case 'welcome':
          ref.read(core_stack.activeStackProvider.notifier).clearStack();
          return {'ok': true, 'screen': 'welcome'};
        case 'editor':
          if (ref.read(core_stack.activeStackProvider) == null) {
            return {
              'ok': false,
              'code': CommandResultCode.commandError,
              'error': 'no stack is open; use stack.open first',
            };
          }
          ref.read(selectedActivityItemProvider.notifier).state =
              AppActivityItemType.lens;
          return {'ok': true, 'screen': 'editor'};
        default:
          return {
            'ok': false,
            'code': CommandResultCode.badParams,
            'error': 'screen must be "welcome" or "editor"',
          };
      }
    },
  ),
];

// ---------------------------------------------------------------------------
// Graph commands
// ---------------------------------------------------------------------------

List<AppCommand> _graphCommands() => [
  AppCommand(
    id: 'graph.view.set',
    title: 'Set Graph View Mode',
    category: 'graph',
    description: '{ view: "graph" | "table" }',
    canExecute: (ref) => ref.read(core_stack.activeStackProvider) != null,
    run: (ref, args) async {
      final view = args['view'] as String?;
      if (view == null) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'view is required',
        };
      }
      if (view != 'graph' && view != 'table') {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'view must be "graph" or "table"',
        };
      }
      ref.read(viewToolbarStateProvider.notifier).setActiveView(view);
      return {'ok': true, 'view': view};
    },
  ),

  AppCommand(
    id: 'graph.search',
    title: 'Run Keyword Search',
    category: 'graph',
    description: '{ keyword: string }',
    canExecute: (ref) => ref.read(core_stack.activeStackProvider) != null,
    run: (ref, args) async {
      final keyword = args['keyword'] as String?;
      if (keyword == null || keyword.trim().isEmpty) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'keyword is required',
        };
      }
      final searchService = ref.read(searchExecutionServiceProvider);
      if (searchService == null) {
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'error': 'no stack is open',
        };
      }
      ref.read(keywordSearchQueryProvider.notifier).setQuery(keyword);
      ref.read(keywordSearchExecutingProvider.notifier).start();
      try {
        final result = await searchService.executeKeywordSearch(
          keyword: keyword,
          options: const ExplorationOptions(maxResults: 200),
        );
        ref.read(keywordSearchResultProvider.notifier).setResult(result);
        ref
            .read(searchHighlightProvider.notifier)
            .setIds(
              nodeIds: result.nodes.map((n) => n.id).toSet(),
              linkIds: result.links.map((l) => l.id).toSet(),
            );
        ref.read(graphNavigatorTabProvider.notifier).setSearchTab();
        return {
          'ok': true,
          'node_count': result.nodes.length,
          'link_count': result.links.length,
        };
      } catch (e) {
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'error': 'search failed: $e',
        };
      } finally {
        ref.read(keywordSearchExecutingProvider.notifier).stop();
      }
    },
  ),

  AppCommand(
    id: 'graph.search.dim',
    title: 'Toggle Search Dim',
    category: 'graph',
    description:
        '{ enabled?: boolean } — dim non-matching entities. Omit to toggle.',
    canExecute: (ref) => ref.read(core_stack.activeStackProvider) != null,
    run: (ref, args) async {
      final notifier = ref.read(searchHighlightProvider.notifier);
      final enabled = args['enabled'] as bool?;
      if (enabled == null) {
        notifier.toggleDim();
      } else if (enabled != ref.read(searchHighlightProvider).dimEnabled) {
        notifier.toggleDim();
      }
      return {
        'ok': true,
        'dim_enabled': ref.read(searchHighlightProvider).dimEnabled,
      };
    },
  ),

  AppCommand(
    id: 'graph.node.open',
    title: 'Open Node in Record Editor',
    category: 'graph',
    description: '{ id: string }',
    canExecute: (ref) => ref.read(core_stack.activeStackProvider) != null,
    run: (ref, args) async {
      final id = args['id'] as String?;
      if (id == null) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'id is required',
        };
      }
      final entityId = core_graph.EntityId.fromString(id);
      // Update both providers synchronously so selectedEntityForEditorProvider
      // reflects the new selection immediately without waiting for EntitySelectionBridge's
      // ref.listen callback (which fires on the next microtask/frame).
      ref
          .read(selectionStateProvider.notifier)
          .selectEntity(entityId, source: SelectionSource.program);
      ref
          .read(core_graph.selectedEntityIdProvider.notifier)
          .setEntityId(entityId);
      ref.read(screenBasedSecondarySidebarStateProvider.notifier).show();
      return {'ok': true, 'id': id};
    },
  ),

  AppCommand(
    id: 'graph.node.focus',
    title: 'Focus Node in Graph View',
    category: 'graph',
    description: '{ id: string }',
    canExecute: (ref) => ref.read(core_stack.activeStackProvider) != null,
    run: (ref, args) async {
      final id = args['id'] as String?;
      if (id == null) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'id is required',
        };
      }
      ref
          .read(searchFocusTargetProvider.notifier)
          .focus(core_graph.EntityId.fromString(id));
      return {'ok': true, 'id': id};
    },
  ),

  AppCommand(
    id: 'graph.node.highlight',
    title: 'Highlight Nodes in Graph View',
    category: 'graph',
    description: '{ ids: string[] }',
    canExecute: (ref) => ref.read(core_stack.activeStackProvider) != null,
    run: (ref, args) async {
      final rawIds = args['ids'];
      if (rawIds == null) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'ids is required',
        };
      }
      final idList = rawIds is List ? rawIds : [rawIds];
      final nodeIds =
          idList
              .map((e) => core_graph.EntityId.fromString(e.toString()))
              .toSet()
              .cast<core_graph.EntityId>();
      ref
          .read(searchHighlightProvider.notifier)
          .setIds(nodeIds: nodeIds, linkIds: const {});
      return {'ok': true, 'count': nodeIds.length};
    },
  ),

  // ---- Viewport commands ----
  AppCommand(
    id: 'graph.viewport.get',
    title: 'Get Viewport State',
    category: 'graph',
    description:
        'Returns current translation (tx, ty) and scale of the graph viewport',
    canExecute:
        (ref) =>
            ref.read(graphViewCacheProvider).transformationController != null,
    run: (ref, args) async {
      final tc = ref.read(graphViewCacheProvider).transformationController;
      if (tc == null) {
        return {'ok': false, 'error': 'graph view is not mounted'};
      }
      final pan = tc.panOffset;
      return {'ok': true, 'tx': pan.dx, 'ty': pan.dy, 'scale': tc.scale};
    },
  ),

  AppCommand(
    id: 'graph.viewport.reset',
    title: 'Reset Viewport',
    category: 'graph',
    description: 'Resets the graph viewport to origin with scale 1.0',
    canExecute:
        (ref) =>
            ref.read(graphViewCacheProvider).transformationController != null,
    run: (ref, args) async {
      final tc = ref.read(graphViewCacheProvider).transformationController;
      if (tc == null) {
        return {'ok': false, 'error': 'graph view is not mounted'};
      }
      tc.reset();
      return {'ok': true};
    },
  ),

  AppCommand(
    id: 'graph.viewport.pan',
    title: 'Pan Viewport',
    category: 'graph',
    description:
        '{ dx: number, dy: number } — translate viewport by the given offset',
    canExecute:
        (ref) =>
            ref.read(graphViewCacheProvider).transformationController != null,
    run: (ref, args) async {
      final tc = ref.read(graphViewCacheProvider).transformationController;
      if (tc == null) {
        return {'ok': false, 'error': 'graph view is not mounted'};
      }
      final dx = (args['dx'] as num?)?.toDouble();
      final dy = (args['dy'] as num?)?.toDouble();
      if (dx == null || dy == null) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'dx and dy are required',
        };
      }
      tc.pan(Offset(dx, dy));
      final pan = tc.panOffset;
      return {'ok': true, 'tx': pan.dx, 'ty': pan.dy};
    },
  ),

  AppCommand(
    id: 'graph.viewport.set_zoom',
    title: 'Set Viewport Zoom',
    category: 'graph',
    description:
        '{ scale: number } — set viewport scale to an absolute value (clamped to 0.5–3.0). Pan offset is preserved.',
    canExecute:
        (ref) =>
            ref.read(graphViewCacheProvider).transformationController != null,
    run: (ref, args) async {
      final tc = ref.read(graphViewCacheProvider).transformationController;
      if (tc == null) {
        return {'ok': false, 'error': 'graph view is not mounted'};
      }
      final scale = (args['scale'] as num?)?.toDouble();
      if (scale == null || scale <= 0) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'scale must be a positive number',
        };
      }
      tc.setScale(scale);
      return {'ok': true, 'scale': tc.scale};
    },
  ),

  AppCommand(
    id: 'graph.viewport.fit',
    title: 'Fit Graph in Viewport',
    category: 'graph',
    description:
        '{ padding?: number } — fit all nodes into the viewport (default padding: 40)',
    canExecute: (ref) {
      final cache = ref.read(graphViewCacheProvider);
      return cache.transformationController != null &&
          cache.ploughGraph != null &&
          cache.viewportSize != Size.zero;
    },
    run: (ref, args) async {
      final cache = ref.read(graphViewCacheProvider);
      final tc = cache.transformationController;
      final ploughGraph = cache.ploughGraph;
      final vpSize = cache.viewportSize;
      if (tc == null || ploughGraph == null) {
        return {'ok': false, 'error': 'graph view is not mounted'};
      }
      if (vpSize == Size.zero) {
        return {'ok': false, 'error': 'viewport size is not yet available'};
      }
      if (ploughGraph.nodes.isEmpty) {
        return {'ok': false, 'error': 'graph has no nodes'};
      }

      final padding = (args['padding'] as num?)?.toDouble() ?? 40.0;

      double minX = double.infinity, minY = double.infinity;
      double maxX = double.negativeInfinity, maxY = double.negativeInfinity;
      for (final node in ploughGraph.nodes) {
        final pos = node.logicalPosition;
        if (pos.dx < minX) minX = pos.dx;
        if (pos.dy < minY) minY = pos.dy;
        if (pos.dx > maxX) maxX = pos.dx;
        if (pos.dy > maxY) maxY = pos.dy;
      }

      final bbW = maxX - minX;
      final bbH = maxY - minY;
      final availW = vpSize.width - padding * 2;
      final availH = vpSize.height - padding * 2;

      double scale;
      if (bbW < 1 && bbH < 1) {
        scale = 1.0;
      } else if (bbW < 1) {
        scale = availH / bbH;
      } else if (bbH < 1) {
        scale = availW / bbW;
      } else {
        scale = math.min(availW / bbW, availH / bbH);
      }
      scale = scale.clamp(0.5, 3.0);

      final bbCenterX = (minX + maxX) / 2;
      final bbCenterY = (minY + maxY) / 2;
      final tx = vpSize.width / 2 - bbCenterX * scale;
      final ty = vpSize.height / 2 - bbCenterY * scale;

      tc.value =
          Matrix4.diagonal3Values(scale, scale, scale)
            ..setEntry(0, 3, tx)
            ..setEntry(1, 3, ty);
      return {'ok': true, 'tx': tx, 'ty': ty, 'scale': scale};
    },
  ),

  // ---- Node position commands ----
  AppCommand(
    id: 'graph.node.get_position',
    title: 'Get Node Position',
    category: 'graph',
    description:
        '{ id: string } — returns logical and screen position of a node',
    canExecute: (ref) => ref.read(graphViewCacheProvider).ploughGraph != null,
    run: (ref, args) async {
      final id = args['id'] as String?;
      if (id == null) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'id is required',
        };
      }
      final ploughGraph = ref.read(graphViewCacheProvider).ploughGraph;
      if (ploughGraph == null) {
        return {'ok': false, 'error': 'graph view is not mounted'};
      }
      final ploughId = plough.GraphId(type: plough.GraphIdType.node, value: id);
      final node = ploughGraph.getNode(ploughId);
      if (node == null) {
        return {'ok': false, 'error': 'node not found: $id'};
      }
      final pos = node.logicalPosition;
      final geo = node.geometry;
      return {
        'ok': true,
        'logical': {'x': pos.dx, 'y': pos.dy},
        'screen':
            geo == null
                ? null
                : {
                  'x': geo.bounds.left,
                  'y': geo.bounds.top,
                  'width': geo.bounds.width,
                  'height': geo.bounds.height,
                },
      };
    },
  ),

  AppCommand(
    id: 'graph.node.get_all_positions',
    title: 'Get All Node Positions',
    category: 'graph',
    description: 'Returns logical and screen positions of all nodes',
    canExecute: (ref) => ref.read(graphViewCacheProvider).ploughGraph != null,
    run: (ref, args) async {
      final ploughGraph = ref.read(graphViewCacheProvider).ploughGraph;
      if (ploughGraph == null) {
        return {'ok': false, 'error': 'graph view is not mounted'};
      }
      final nodes =
          ploughGraph.nodes.map((node) {
            final pos = node.logicalPosition;
            final geo = node.geometry;
            return {
              'id': node.id.value,
              'label': AppNodeRenderer.resolveDisplayLabel(node),
              'logical': {'x': pos.dx, 'y': pos.dy},
              'screen':
                  geo == null
                      ? null
                      : {
                        'x': geo.bounds.left,
                        'y': geo.bounds.top,
                        'width': geo.bounds.width,
                        'height': geo.bounds.height,
                      },
            };
          }).toList();
      return {'ok': true, 'nodes': nodes};
    },
  ),

  AppCommand(
    id: 'graph.node.move',
    title: 'Move Node',
    category: 'graph',
    description:
        '{ id: string, x: number, y: number } — move a node to the given logical position',
    canExecute: (ref) => ref.read(graphViewCacheProvider).ploughGraph != null,
    run: (ref, args) async {
      final id = args['id'] as String?;
      final x = (args['x'] as num?)?.toDouble();
      final y = (args['y'] as num?)?.toDouble();
      if (id == null || x == null || y == null) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'id, x, and y are required',
        };
      }
      final ploughGraph = ref.read(graphViewCacheProvider).ploughGraph;
      if (ploughGraph == null) {
        return {'ok': false, 'error': 'graph view is not mounted'};
      }
      final ploughId = plough.GraphId(type: plough.GraphIdType.node, value: id);
      final node = ploughGraph.getNode(ploughId);
      if (node == null) {
        return {'ok': false, 'error': 'node not found: $id'};
      }
      node.logicalPosition = Offset(x, y);
      ploughGraph.markNeedsLayout(shouldAnimate: false);
      return {'ok': true, 'id': id, 'x': x, 'y': y};
    },
  ),

  // ---- Link geometry commands ----
  AppCommand(
    id: 'graph.link.get_geometry',
    title: 'Get Link Geometry',
    category: 'graph',
    description:
        '{ id: string } — returns connection points, bounds, angle, and node bounds for a link',
    canExecute: (ref) => ref.read(graphViewCacheProvider).ploughGraph != null,
    run: (ref, args) async {
      final id = args['id'] as String?;
      if (id == null) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'id is required',
        };
      }
      final ploughGraph = ref.read(graphViewCacheProvider).ploughGraph;
      if (ploughGraph == null) {
        return {'ok': false, 'error': 'graph view is not mounted'};
      }
      final ploughId = plough.GraphId(type: plough.GraphIdType.link, value: id);
      final link = ploughGraph.getLink(ploughId);
      if (link == null) {
        return {'ok': false, 'error': 'link not found: $id'};
      }
      final geo = link.geometry;
      return {
        'ok': true,
        'id': id,
        'source_node_id': link.source.id.value,
        'target_node_id': link.target.id.value,
        'direction': link.direction.name,
        'logical_position': {
          'x': link.logicalPosition.dx,
          'y': link.logicalPosition.dy,
        },
        'geometry':
            geo == null
                ? null
                : {
                  'bounds': {
                    'left': geo.bounds.left,
                    'top': geo.bounds.top,
                    'right': geo.bounds.right,
                    'bottom': geo.bounds.bottom,
                    'width': geo.bounds.width,
                    'height': geo.bounds.height,
                  },
                  'angle': geo.angle,
                  'thickness': geo.thickness,
                  'connection': {
                    'source_bounds': {
                      'left': geo.connection.source.bounds.left,
                      'top': geo.connection.source.bounds.top,
                      'right': geo.connection.source.bounds.right,
                      'bottom': geo.connection.source.bounds.bottom,
                    },
                    'target_bounds': {
                      'left': geo.connection.target.bounds.left,
                      'top': geo.connection.target.bounds.top,
                      'right': geo.connection.target.bounds.right,
                      'bottom': geo.connection.target.bounds.bottom,
                    },
                    'outgoing': {
                      'x': geo.connection.connectionPoints.outgoing.dx,
                      'y': geo.connection.connectionPoints.outgoing.dy,
                    },
                    'incoming': {
                      'x': geo.connection.connectionPoints.incoming.dx,
                      'y': geo.connection.connectionPoints.incoming.dy,
                    },
                    'distance': geo.connection.connectionPoints.distance,
                    'angle': geo.connection.connectionPoints.angle,
                  },
                },
      };
    },
  ),

  AppCommand(
    id: 'graph.link.get_all_geometries',
    title: 'Get All Link Geometries',
    category: 'graph',
    description: 'Returns geometry info for all links',
    canExecute: (ref) => ref.read(graphViewCacheProvider).ploughGraph != null,
    run: (ref, args) async {
      final ploughGraph = ref.read(graphViewCacheProvider).ploughGraph;
      if (ploughGraph == null) {
        return {'ok': false, 'error': 'graph view is not mounted'};
      }
      final links =
          ploughGraph.links.map((link) {
            final geo = link.geometry;
            return {
              'id': link.id.value,
              'source_node_id': link.source.id.value,
              'target_node_id': link.target.id.value,
              'direction': link.direction.name,
              'geometry':
                  geo == null
                      ? null
                      : {
                        'bounds': {
                          'left': geo.bounds.left,
                          'top': geo.bounds.top,
                          'right': geo.bounds.right,
                          'bottom': geo.bounds.bottom,
                        },
                        'angle': geo.angle,
                        'thickness': geo.thickness,
                        'connection': {
                          'outgoing': {
                            'x': geo.connection.connectionPoints.outgoing.dx,
                            'y': geo.connection.connectionPoints.outgoing.dy,
                          },
                          'incoming': {
                            'x': geo.connection.connectionPoints.incoming.dx,
                            'y': geo.connection.connectionPoints.incoming.dy,
                          },
                          'distance': geo.connection.connectionPoints.distance,
                          'angle': geo.connection.connectionPoints.angle,
                        },
                      },
            };
          }).toList();
      return {'ok': true, 'links': links};
    },
  ),

  AppCommand(
    id: 'graph.link.check_arrow_drift',
    title: 'Check Link Arrow Drift',
    category: 'graph',
    description:
        'Checks all links for arrow-position drift (connection points outside node bounds)',
    canExecute: (ref) => ref.read(graphViewCacheProvider).ploughGraph != null,
    run: (ref, args) async {
      final ploughGraph = ref.read(graphViewCacheProvider).ploughGraph;
      if (ploughGraph == null) {
        return {'ok': false, 'error': 'graph view is not mounted'};
      }
      const margin = 20.0;
      int total = 0;
      final drifted = <Map<String, dynamic>>[];

      for (final link in ploughGraph.links) {
        final geo = link.geometry;
        if (geo == null) continue;
        total++;
        final cp = geo.connection.connectionPoints;
        final srcBounds = geo.connection.source.bounds;
        final tgtBounds = geo.connection.target.bounds;

        final outgoingOutside =
            !srcBounds.inflate(margin).contains(cp.outgoing);
        final incomingOutside =
            !tgtBounds.inflate(margin).contains(cp.incoming);

        if (outgoingOutside || incomingOutside) {
          drifted.add({
            'id': link.id.value,
            'source_node_id': link.source.id.value,
            'target_node_id': link.target.id.value,
            'outgoing': {'x': cp.outgoing.dx, 'y': cp.outgoing.dy},
            'outgoing_outside_source': outgoingOutside,
            'source_bounds': {
              'left': srcBounds.left,
              'top': srcBounds.top,
              'right': srcBounds.right,
              'bottom': srcBounds.bottom,
            },
            'incoming': {'x': cp.incoming.dx, 'y': cp.incoming.dy},
            'incoming_outside_target': incomingOutside,
            'target_bounds': {
              'left': tgtBounds.left,
              'top': tgtBounds.top,
              'right': tgtBounds.right,
              'bottom': tgtBounds.bottom,
            },
          });
        }
      }

      return {
        'ok': true,
        'total': total,
        'drifted_count': drifted.length,
        'drifted': drifted,
      };
    },
  ),

  // ---- Layout commands ----
  AppCommand(
    id: 'graph.layout.run',
    title: 'Re-run Graph Layout',
    category: 'graph',
    description:
        '{ animate?: boolean } — re-run the graph layout algorithm (default animate: true)',
    canExecute: (ref) => ref.read(graphViewCacheProvider).ploughGraph != null,
    run: (ref, args) async {
      final ploughGraph = ref.read(graphViewCacheProvider).ploughGraph;
      if (ploughGraph == null) {
        return {'ok': false, 'error': 'graph view is not mounted'};
      }
      final animate = args['animate'] as bool? ?? true;
      ploughGraph.markNeedsLayout(shouldAnimate: animate);
      return {'ok': true};
    },
  ),

  // ---- Selection commands (simulates user tap on graph entities) ----
  AppCommand(
    id: 'graph.node.select',
    title: 'Select Node in Graph View',
    category: 'graph',
    description:
        '{ id: string } — selects a node as if the user tapped it (triggers selection side-effects)',
    canExecute: (ref) => ref.read(graphViewCacheProvider).ploughGraph != null,
    run: (ref, args) async {
      final id = args['id'] as String?;
      if (id == null) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'id is required',
        };
      }
      final ploughGraph = ref.read(graphViewCacheProvider).ploughGraph;
      if (ploughGraph == null) {
        return {'ok': false, 'error': 'graph view is not mounted'};
      }
      final ploughId = plough.GraphId(type: plough.GraphIdType.node, value: id);
      final node = ploughGraph.getNode(ploughId);
      if (node == null) {
        return {'ok': false, 'error': 'node not found: $id'};
      }
      ploughGraph.selectNode(ploughId);
      ref
          .read(selectedGraphEntityIdProvider.notifier)
          .setSelectedEntityId(
            core_graph.EntityId.fromString(id),
            source: SelectionSource.ui,
          );
      return {'ok': true, 'id': id};
    },
  ),

  AppCommand(
    id: 'graph.link.select',
    title: 'Select Link in Graph View',
    category: 'graph',
    description:
        '{ id: string } — selects a link as if the user tapped it (triggers selection side-effects)',
    canExecute: (ref) => ref.read(graphViewCacheProvider).ploughGraph != null,
    run: (ref, args) async {
      final id = args['id'] as String?;
      if (id == null) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'id is required',
        };
      }
      final ploughGraph = ref.read(graphViewCacheProvider).ploughGraph;
      if (ploughGraph == null) {
        return {'ok': false, 'error': 'graph view is not mounted'};
      }
      final ploughId = plough.GraphId(type: plough.GraphIdType.link, value: id);
      final link = ploughGraph.getLink(ploughId);
      if (link == null) {
        return {'ok': false, 'error': 'link not found: $id'};
      }
      ploughGraph.selectLink(ploughId);
      ref
          .read(selectedGraphEntityIdProvider.notifier)
          .setSelectedEntityId(
            core_graph.EntityId.fromString(id),
            source: SelectionSource.ui,
          );
      return {'ok': true, 'id': id};
    },
  ),

  AppCommand(
    id: 'graph.entity.deselect',
    title: 'Deselect Entity in Graph View',
    category: 'graph',
    description: 'Clears the current graph selection',
    canExecute: (ref) => ref.read(graphViewCacheProvider).ploughGraph != null,
    run: (ref, args) async {
      final ploughGraph = ref.read(graphViewCacheProvider).ploughGraph;
      if (ploughGraph == null) {
        return {'ok': false, 'error': 'graph view is not mounted'};
      }
      for (final node in ploughGraph.nodes) {
        if (ploughGraph.getNode(node.id)?.isSelected ?? false) {
          ploughGraph.deselectNode(node.id);
        }
      }
      for (final link in ploughGraph.links) {
        if (ploughGraph.getLink(link.id)?.isSelected ?? false) {
          ploughGraph.deselectLink(link.id);
        }
      }
      ref
          .read(selectedGraphEntityIdProvider.notifier)
          .setSelectedEntityId(null, source: SelectionSource.ui);
      return {'ok': true};
    },
  ),

  // ---- Wait commands ----
  //
  // The plough graph is rebuilt from activeGraphProvider during the next
  // widget build, so it lags a stack.open by a frame or more. Reading
  // geometry right after opening a stack therefore returns the *previous*
  // stack's nodes. These commands wait for the view to catch up; a fixed
  // sleep cannot do the job, because two stacks may share a node count
  // (罪と罰 and Crime and Punishment both have 96) and a count-only check
  // would pass against stale data.
  AppCommand(
    id: 'graph.wait.loaded',
    title: 'Wait Until Graph View Is Loaded',
    category: 'graph',
    description:
        '{ nodeCount?: number, linkCount?: number, timeoutMs?: number } — '
        'waits until the mounted graph matches the given counts (default '
        'timeout: 10000). Omit both counts to wait for any non-empty graph.',
    run: (ref, args) async {
      final nodeCount = (args['nodeCount'] as num?)?.toInt();
      final linkCount = (args['linkCount'] as num?)?.toInt();
      final timeoutMs = (args['timeoutMs'] as num?)?.toInt() ?? 10000;

      bool matches() {
        if (ref.read(graphLoadingStateProvider)) return false;
        final graph = ref.read(graphViewCacheProvider).ploughGraph;
        if (graph == null) return false;
        if (nodeCount != null && graph.nodes.length != nodeCount) return false;
        if (linkCount != null && graph.links.length != linkCount) return false;
        if (nodeCount == null && linkCount == null) {
          return graph.nodes.isNotEmpty;
        }
        return true;
      }

      final ok = await _waitFor(matches, timeoutMs);
      final graph = ref.read(graphViewCacheProvider).ploughGraph;
      if (ok) {
        return {
          'ok': true,
          'node_count': graph?.nodes.length ?? 0,
          'link_count': graph?.links.length ?? 0,
        };
      }
      return {
        'ok': false,
        'code': CommandResultCode.commandError,
        'error':
            'Timeout waiting for graph view; currently '
            '${graph?.nodes.length ?? 0} nodes, '
            '${graph?.links.length ?? 0} links',
      };
    },
  ),

  AppCommand(
    id: 'graph.wait.nodeCaption',
    title: 'Wait Until a Node Caption Appears',
    category: 'graph',
    description:
        '{ caption: string, timeoutMs?: number } — waits until some node in '
        'the mounted graph renders the given caption (default: 10000). Use to '
        'confirm the view switched to the stack you expect, rather than '
        'matching on node counts alone.',
    run: (ref, args) async {
      final caption = args['caption'] as String?;
      if (caption == null || caption.isEmpty) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'caption is required',
        };
      }
      final timeoutMs = (args['timeoutMs'] as num?)?.toInt() ?? 10000;

      final ok = await _waitFor(() {
        final graph = ref.read(graphViewCacheProvider).ploughGraph;
        if (graph == null) return false;
        return graph.nodes.any(
          (node) => AppNodeRenderer.resolveDisplayLabel(node) == caption,
        );
      }, timeoutMs);

      if (ok) return {'ok': true, 'caption': caption};
      return {
        'ok': false,
        'code': CommandResultCode.commandError,
        'error': 'Timeout waiting for a node captioned "$caption"',
      };
    },
  ),
];

// ---------------------------------------------------------------------------
// Record editor commands
// ---------------------------------------------------------------------------

List<AppCommand> _recordEditorCommands() => [
  AppCommand(
    id: 'record_editor.state',
    title: 'Get Record Editor State',
    category: 'record_editor',
    description: 'Returns the currently selected entity and its properties',
    canExecute: (ref) => ref.read(core_stack.activeStackProvider) != null,
    run: (ref, args) async {
      final entity = ref.read(record_editor.selectedEntityForEditorProvider);
      if (entity == null) {
        return {
          'ok': true,
          'selected': false,
          'entity': null,
          'properties': {},
        };
      }
      // Merge saved properties with in-progress edits.
      final savedProperties = ref.read(
        record_editor.selectedEntityPropertiesProvider,
      );
      final editingProperties = ref.read(
        record_editor.editingEntityPropertiesProvider,
      );
      final keys = ref.read(record_editor.selectedEntityPropertyKeysProvider);
      final merged = {...savedProperties, ...editingProperties};
      return {
        'ok': true,
        'selected': true,
        'entity': {
          'id': entity.id.toString(),
          'kind': entity.kind.name,
          'custom_id': entity.customId,
        },
        'property_keys': keys,
        'properties': {for (final key in keys) key: merged[key]},
      };
    },
  ),

  AppCommand(
    id: 'record_editor.field.set',
    title: 'Set Record Editor Field',
    category: 'record_editor',
    description: '{ field: string, value: string }',
    canExecute: (ref) {
      if (ref.read(core_stack.activeStackProvider) == null) return false;
      return ref.read(record_editor.selectedEntityForEditorProvider) != null;
    },
    run: (ref, args) async {
      final field = args['field'] as String?;
      final value = args['value'];
      if (field == null) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'field is required',
        };
      }
      ref
          .read(record_editor.editingEntityPropertiesProvider.notifier)
          .updateProperty(field, value);
      return {'ok': true, 'field': field, 'value': value};
    },
  ),

  AppCommand(
    id: 'record_editor.save',
    title: 'Save Record Editor',
    category: 'record_editor',
    description: 'Save changes in the record editor',
    canExecute: (ref) {
      if (ref.read(core_stack.activeStackProvider) == null) return false;
      if (ref.read(graphLoadingStateProvider)) return false;
      return ref.read(record_editor.selectedEntityForEditorProvider) != null;
    },
    run: (ref, args) async {
      final selectedEntity = ref.read(
        record_editor.selectedEntityForEditorProvider,
      );
      if (selectedEntity == null) {
        return {'ok': false, 'error': 'no entity selected'};
      }

      final editingProperties = ref.read(
        record_editor.editingEntityPropertiesProvider,
      );
      final propertyNameChanges = ref.read(
        record_editor.editingPropertyNameChangesProvider,
      );

      final finalProperties = Map<String, dynamic>.from(editingProperties);
      for (final change in propertyNameChanges.entries) {
        final oldValue = finalProperties.remove(change.key);
        finalProperties[change.value] = oldValue;
      }

      // WORKAROUND: Open a dedicated SQLite connection for the save operation.
      // This is a temporary workaround until GraphContext.transaction() is fixed
      // to pass a transaction-scoped context to its callback instead of 'this'.
      // See record-editor-save-database-locking.md in rinne-graph-desktop-private.
      //
      // The dedicated connection is needed because sharing the same RinneGraphStorage
      // instance as EntitySelectionBridge causes a database lock: sqflite_ffi
      // serializes transactions per connection, and the read connection held by
      // EntitySelectionBridge blocks any write transaction on the same connection.
      final activeStack = ref.read(core_stack.activeStackProvider);
      if (activeStack == null) {
        return {'ok': false, 'error': 'no active stack'};
      }
      final graphDbPath = '${activeStack.directory.path}/data/graph.db';
      final dedicatedStorage = core_graph.ChiffonStorage(
        path: graphDbPath,
        schema: core_graph.ChiffonSchemaGenerator.minimalSchema,
      );
      await dedicatedStorage.initialize();

      final saveContext = core_graph.GraphContext(storage: dedicatedStorage);

      final updatedEntity = selectedEntity.copyWith(
        properties: core_graph.PropertySet.fromMap(finalProperties),
      );

      // WORKAROUND: Call updateNode/updateLink directly instead of using
      // saveContext.transaction(). GraphContext.transaction() passes 'this' to
      // its callback, so any write inside the callback calls storage.updateNode()
      // → _graph.transaction() → re-enters the same BasicLock → deadlock.
      // Each updateNode/updateLink call opens its own transaction safely.
      if (updatedEntity is core_graph.Node) {
        await saveContext.updateNode(updatedEntity);
      } else if (updatedEntity is core_graph.Link) {
        await saveContext.updateLink(updatedEntity);
      }

      await dedicatedStorage.close();

      ref
          .read(record_editor.editingPropertyNameChangesProvider.notifier)
          .reset();
      ref.read(record_editor.editingEntityPropertiesProvider.notifier).reset();
      return {'ok': true};
    },
  ),

  AppCommand(
    id: 'record_editor.close',
    title: 'Close Record Editor',
    category: 'record_editor',
    description: 'Close the record editor (hides secondary sidebar)',
    run: (ref, args) async {
      ref.read(screenBasedSecondarySidebarStateProvider.notifier).hide();
      return {'ok': true};
    },
  ),
];

Future<dynamic> _ping(WidgetRef ref, Map<String, dynamic> _) async {
  return {'ok': true, 'timestamp': DateTime.now().toIso8601String()};
}

// ---------------------------------------------------------------------------
// Import / export commands
// ---------------------------------------------------------------------------

List<AppCommand> _exchangeCommands() => [
  // Parses without writing anything, so a test can assert on how a CSV is
  // read before committing to a stack.
  //
  // There is deliberately no command that runs a full CSV import: it would
  // depend on StackActions.createCustomStack, which is still a stub returning
  // null (stack_providers.dart), so importing a CSV into a new stack cannot
  // work yet regardless of how it is invoked. Add the import command once
  // stack creation is implemented.
  AppCommand(
    id: 'import.csv.parse',
    title: 'Parse a CSV File Without Importing',
    category: 'import',
    description:
        '{ path: string } — reports the detected type (node/link), the row '
        'count, and the first row, leaving the filesystem untouched.',
    run: (ref, args) async {
      final path = args['path'] as String?;
      if (path == null || path.isEmpty) {
        return {
          'ok': false,
          'code': CommandResultCode.badParams,
          'error': 'path is required',
        };
      }
      final file = io.File(path);
      if (!await file.exists()) {
        return {
          'ok': false,
          'code': CommandResultCode.notFound,
          'error': 'file not found: $path',
        };
      }
      try {
        final contents = await file.readAsString();
        final parsed = import_export.CsvImportService.parseCsv(contents);
        final isNodes = parsed.type == import_export.CsvDataType.node;
        return {
          'ok': true,
          'type': isNodes ? 'node' : 'link',
          'row_count': isNodes ? parsed.nodes.length : parsed.links.length,
          'first_row':
              isNodes
                  ? (parsed.nodes.isEmpty
                      ? null
                      : {
                        'id': parsed.nodes.first.customId,
                        'labels': parsed.nodes.first.labels.toList(),
                        'properties': parsed.nodes.first.properties,
                      })
                  : (parsed.links.isEmpty
                      ? null
                      : {
                        'source': parsed.links.first.sourceId,
                        'target': parsed.links.first.targetId,
                        'type': parsed.links.first.type,
                        'properties': parsed.links.first.properties,
                      }),
        };
      } catch (e) {
        return {
          'ok': false,
          'code': CommandResultCode.commandError,
          'error': 'parse failed: $e',
        };
      }
    },
  ),
];

Future<dynamic> _screenshot(WidgetRef ref, Map<String, dynamic> args) async {
  final client = io.HttpClient();
  try {
    final uri = Uri.parse('http://localhost:6107/ui/screenshot');
    final req = await client.getUrl(uri);
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
