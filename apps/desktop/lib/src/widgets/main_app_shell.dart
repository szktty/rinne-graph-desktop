/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fonde_ui/fonde_ui.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:features_updates/updates.dart' as features_updates;
import 'package:app/app.dart';
import 'package:presentation_workflow/presentation_workflow.dart'
    as presentation_workflow;
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:core_app_config/core_app_config.dart';

import '../providers/app_state_providers.dart';
import '../providers/open_stacks_providers.dart';
import '../providers/entity_selection_bridge_providers.dart';
import '../providers/shell_state_manager.dart';
import '../commands/register_core_commands.dart';
import 'shell/startup_handler.dart';
import 'shell/sidebar_builder.dart';
import 'shell/main_content_builder.dart';
import 'shell/activity_bar_builder.dart';
import 'package:features_welcome/src/widgets/welcome_screen_content.dart';

/// Main shell of the application
class MainAppShell extends ConsumerWidget {
  const MainAppShell({
    super.key,
    this.enableDevStacks = false,
    this.commandLineArgs = const [],
    this.globalActivityBarNavigator,
    this.navigatorKey,
  });

  final bool enableDevStacks;
  final List<String> commandLineArgs;
  final Function(int)? globalActivityBarNavigator;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedActivityIndex = ref.watch(activityBarStateProvider);
    final activeStack = ref.watch(core_stack.activeStackProvider);

    // Initialize the link between entity selection and the editor
    ref.watch(initializeEntitySelectionBridgeProvider);

    // Initialize activity bar change monitoring
    ref.watch(activityBarChangeListenerProvider);

    // Monitor stack loading errors
    ref.listen<ErrorDialogData?>(stackLoadingErrorProvider, (previous, next) {
      if (next != null && next.hasError && context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await showAppErrorDialogFromData(
            context,
            errorData: next,
            onOkPressed: () {
              ref.read(stackLoadingErrorProvider.notifier).state = null;
            },
          );
        });
      }
    });

    final shellState = ref.watch(shellStateManagerProvider);

    // Stack loading process at startup (delegated to StartupHandler)
    StartupHandler.schedule(
      ref: ref,
      context: context,
      commandLineArgs: commandLineArgs,
    );

    // Check for updates at startup
    ref.listen<AsyncValue<features_updates.StartupUpdateCheckResult>>(
      features_updates.startupUpdateCheckProvider,
      (previous, next) {
        next.whenData((result) {
          if (result.updateAvailable && context.mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await features_updates.showUpdateCheckDialog(context);
            });
          }
        });
      },
    );

    // Register commands
    if (!shellState.commandsRegistered) {
      Future(() {
        registerCoreCommands(ref);
        ref.read(shellStateManagerProvider.notifier).markCommandsRegistered();
      });
    }

    // Development stacks auto-import
    final startupConfig = ref.watch(startupConfigProvider);
    final actualEnableDevStacks =
        startupConfig.enableDevStacks || enableDevStacks;

    debugPrint(
      'MainAppShell: enableDevStacks=$actualEnableDevStacks (config: ${startupConfig.enableDevStacks}, arg: $enableDevStacks), devStacksImported=${shellState.devStacksImported}',
    );
    if (actualEnableDevStacks && !shellState.devStacksImported) {
      Future(() {
        ref.read(shellStateManagerProvider.notifier).markDevStacksImported();
      });
      debugPrint('MainAppShell: Starting dev stack import process...');
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        debugPrint(
          'Development stacks feature planned for future implementation',
        );
      });
    }

    final selectedActivityType = ref.watch(selectedActivityItemProvider);

    // Get the sidebar visibility state
    final isPrimarySidebarVisible = ref.watch(primarySidebarStateProvider);
    final isSecondarySidebarVisible = ref.watch(
      secondarySidebarStateProvider,
    );

    // Get workflow state
    final panelVisibility = ref.watch(
      presentation_workflow.taskPanelVisibilityProvider,
    );
    final panelState = ref.watch(presentation_workflow.taskPanelStateProvider);
    final activeTasks = ref.watch(presentation_workflow.activeTasksProvider);
    final taskPanelActions = ref.read(
      presentation_workflow.taskPanelActionsProvider.notifier,
    );

    // If no stack is open, display the welcome screen
    if (activeStack == null) {
      return _buildStackManagementContent(ref);
    }

    return widgets.Stack(
      children: [
        FondeScaffold(
          toolbar: FondeMainToolbar(),
          launchBar: ActivityBarBuilder.buildBar(),
          showLaunchBar: true,
          primarySidebar: SidebarBuilder.buildPrimary(selectedActivityType),
          secondarySidebar: SidebarBuilder.buildSecondary(selectedActivityType),
          showPrimarySidebar: SidebarBuilder.shouldShowPrimary(
            selectedActivityType,
            isPrimarySidebarVisible,
          ),
          showSecondarySidebar: SidebarBuilder.shouldShowSecondary(
            selectedActivityType,
            isSecondarySidebarVisible,
          ),
          content: ContentBuilder.buildContent(ref, selectedActivityIndex),
        ),
        // Background task panel
        if (panelVisibility)
          presentation_workflow.TaskPanel(
            tasks: activeTasks,
            initialPosition: panelState.geometry.position,
            initialSize: panelState.geometry.size,
            onPositionChanged: taskPanelActions.updatePanelPosition,
            onSizeChanged: taskPanelActions.updatePanelSize,
            onTaskCancel: (task) => {},
            onClose:
                () => ref
                    .read(
                      presentation_workflow
                          .taskPanelVisibilityProvider
                          .notifier,
                    )
                    .setVisible(false),
          ),
      ],
    );
  }

  Widget _buildStackManagementContent(WidgetRef ref) {
    return FondeMainContentArea(
      child: WelcomeScreenContent(
        onCreateNewStack: () {
          debugPrint('Create new stack from WelcomeScreenContent');
        },
        onOpenStack: () {
          debugPrint('Open existing stack from WelcomeScreenContent');
        },
        onImportStack: () {
          debugPrint('Import data from WelcomeScreenContent');
        },
        onStackSelected: (selectedStack) async {
          final navContext = navigatorKey?.currentContext;
          if (navContext == null) return;

          try {
            debugPrint(
              'Opening stack from WelcomeScreenContent: ${selectedStack.directory.path}',
            );

            ref
                .read(core_stack.activeStackProvider.notifier)
                .setStack(selectedStack);
            ref
                .read(openStacksActionsProvider.notifier)
                .addStack(selectedStack);
            ref.read(selectedActivityItemProvider.notifier).state =
                AppActivityItemType.lens;

            debugPrint('Stack successfully loaded and UI updated');
          } catch (e, stackTrace) {
            debugPrint('Error opening stack: $e');
            debugPrint('Stack trace: $stackTrace');

            if (navContext.mounted) {
              await showAppErrorDialog(
                navContext,
                message:
                    'An error occurred while opening stack "${selectedStack.info.name}".',
                details: '$e',
              );
            }
          }
        },
        onGoToMainScreen: () {
          debugPrint('Go to main screen from WelcomeScreenContent');
        },
      ),
    );
  }
}
