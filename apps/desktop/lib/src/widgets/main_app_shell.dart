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
import 'package:presentation_components/presentation_components.dart'
    hide Toolbar;
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
        // If an error occurs, display a dialog
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await showAppErrorDialogFromData(
            context,
            errorData: next,
            onOkPressed: () {
              // Clear the error
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
            // If an update is available, display a dialog
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
        // Register in-app commands
        registerCoreCommands(ref);
        ref.read(shellStateManagerProvider.notifier).markCommandsRegistered();
      });
    }

    // Development stacks auto-import - get from configuration file
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
          'MainAppShell: Post-frame callback executing for dev stack import',
        );
        // Development test stack feature planned for future implementation
        // For details, see "Future development test stack concept" in packages/core/samples/README.md
        debugPrint(
          'Development stacks feature planned for future implementation',
        );
      });
    }

    // Automatic display logic for the welcome page
    // If no stack is open, do not navigate to the lens to display the welcome dialog
    final selectedActivityType = ref.watch(selectedActivityItemProvider);
    // If no stack is open, the welcome dialog is displayed in _buildStackManagementContent

    // Since AppActivityBar is used, defining activity bar items is unnecessary

    // Get the sidebar visibility state (using the new unified provider)
    final isPrimarySidebarVisible = ref.watch(primarySidebarStateProvider);
    final isSecondarySidebarVisible = ref.watch(secondarySidebarStateProvider);

    // Get workflow state
    final panelVisibility = ref.watch(
      presentation_workflow.taskPanelVisibilityProvider,
    );
    final panelState = ref.watch(presentation_workflow.taskPanelStateProvider);
    final activeTasks = ref.watch(presentation_workflow.activeTasksProvider);
    final taskPanelActions = ref.read(
      presentation_workflow.taskPanelActionsProvider.notifier,
    );

    // If no stack is open, display the welcome dialog
    if (activeStack == null) {
      return _buildStackManagementContent(ref);
    }

    return widgets.Stack(
      children: [
        MainShellLayout(
          toolbar: const MainAreaTitlebar(), // Title bar for the main area
          activityBar: ActivityBarBuilder.buildBar(),
          showActivityBar:
              true, // Activity bar is always displayed (except on the welcome screen)
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
    return MainContentArea(
      child: WelcomeScreenContent(
        onCreateNewStack: () {
          // Implement create new stack logic
          debugPrint('Create new stack from WelcomeScreenContent');
        },
        onOpenStack: () {
          // Implement open existing stack logic
          debugPrint('Open existing stack from WelcomeScreenContent');
        },
        onImportStack: () {
          // Implement import data logic
          debugPrint('Import data from WelcomeScreenContent');
        },
        onStackSelected: (selectedStack) async {
          final navContext = navigatorKey?.currentContext;
          if (navContext == null) return;

          bool stackLoadedSuccessfully = false;

          try {
            debugPrint(
              'Opening stack from WelcomeScreenContent: ${selectedStack.directory.path}',
            );

            // Execute sequentially to ensure state is updated reliably
            ref
                .read(core_stack.activeStackProvider.notifier)
                .setStack(selectedStack);
            ref
                .read(openStacksActionsProvider.notifier)
                .addStack(selectedStack);
            ref.read(selectedActivityItemProvider.notifier).state =
                AppActivityItemType.lens;

            stackLoadedSuccessfully = true;
            debugPrint('Stack successfully loaded and UI updated');
          } catch (e, stackTrace) {
            debugPrint('Error opening stack: $e');
            debugPrint('Stack trace: $stackTrace');

            // Show error dialog
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
          // This callback is less relevant for a full-screen welcome,
          // but can be used for any necessary cleanup if the app transitions away
          debugPrint('Go to main screen from WelcomeScreenContent');
        },
      ),
    );
  }
}
