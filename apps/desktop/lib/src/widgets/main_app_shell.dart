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
import 'package:presentation_components/presentation_components.dart';
import 'package:features_updates/updates.dart' as features_updates;
import 'package:app/app.dart';
import 'package:presentation_workflow/presentation_workflow.dart'
    as presentation_workflow;
import 'dart:io';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:core_app_config/core_app_config.dart';

import 'package:core_graph_flutter/core_graph.dart' as core_graph;

import '../providers/app_state_providers.dart';
import '../providers/open_stacks_providers.dart';
import '../providers/entity_selection_bridge_providers.dart';
import '../providers/search_providers.dart';
import '../providers/selection_providers.dart';
import '../providers/shell_state_manager.dart';
import '../providers/view_toolbar_providers.dart';
import '../commands/register_core_commands.dart';
import '../events/selection_events.dart';
import '../models/search_models.dart';
import '../services/mcp_http_server.dart';
import '../services/search_execution_service.dart';
import '../enums/activity_bar_index.dart';
import 'shell/startup_handler.dart';
import 'shell/sidebar_builder.dart';
import 'shell/main_content_builder.dart';
import 'shell/activity_bar_builder.dart';
import 'package:features_welcome/src/widgets/welcome_screen_content.dart';

/// Main shell of the application
class MainAppShell extends ConsumerStatefulWidget {
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
  ConsumerState<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends ConsumerState<MainAppShell> {
  late final FondeSecondarySidebarController _secondarySidebarController;

  @override
  void initState() {
    super.initState();
    _secondarySidebarController = FondeSecondarySidebarController(
      initiallyVisible: false,
    );
    // Sync controller → Riverpod (e.g. close button inside secondary sidebar)
    _secondarySidebarController.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    final visible = _secondarySidebarController.isVisible;
    final riverpodVisible = ref.read(secondarySidebarStateProvider);
    if (riverpodVisible != visible) {
      ref
          .read(screenBasedSecondarySidebarStateProvider.notifier)
          .setVisible(visible);
    }
  }

  @override
  void dispose() {
    _secondarySidebarController.removeListener(_onControllerChanged);
    _secondarySidebarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedActivityIndex = ref.watch(activityBarStateProvider);
    final activeStack = ref.watch(core_stack.activeStackProvider);

    // Register UI state reader for the MCP HTTP server.
    McpHttpServer.instance?.uiStateReader = () async {
      final stack = ref.read(core_stack.activeStackProvider);
      final activityIndex = ref.read(activityBarStateProvider);
      final viewMode = ref.read(viewToolbarStateProvider);
      final screen = activityIndex == 0 ? 'editor' : 'welcome';
      return {
        'screen': activeStack == null ? 'welcome' : screen,
        'stack_path': stack?.directory.path,
        'view_mode': viewMode,
        'activity_index': activityIndex,
      };
    };

    // Register command handler for the MCP HTTP server.
    McpHttpServer.instance?.commandHandler = (command, params) async {
      switch (command) {
        case 'open_stack':
          // SECURITY: Currently accepts arbitrary file paths from the MCP server.
          // Before enabling on release builds, replace with a stack ID lookup so
          // that only stacks already known to the app can be opened.
          final path = params['path'] as String?;
          if (path == null) {
            return {'ok': false, 'error': 'path is required'};
          }
          final stackDir = Directory(path);
          if (!await stackDir.exists()) {
            return {'ok': false, 'error': 'stack directory not found: $path'};
          }
          final metadataService = core_stack.StackMetadataService();
          final (info, settings) = await metadataService.loadMetadata(stackDir);
          if (info == null) {
            return {'ok': false, 'error': 'failed to load stack metadata: $path'};
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

        case 'switch_view':
          final view = params['view'] as String?;
          if (view == null) {
            return {'ok': false, 'error': 'view is required'};
          }
          if (view != 'graph' && view != 'table') {
            return {'ok': false, 'error': 'view must be "graph" or "table"'};
          }
          ref.read(viewToolbarStateProvider.notifier).setActiveView(view);
          return {'ok': true, 'view': view};

        case 'close_stack':
          ref.read(core_stack.activeStackProvider.notifier).clearStack();
          return {'ok': true};

        case 'navigate_to':
          final screen = params['screen'] as String?;
          if (screen == null) {
            return {'ok': false, 'error': 'screen is required'};
          }
          switch (screen) {
            case 'welcome':
              ref.read(core_stack.activeStackProvider.notifier).clearStack();
              return {'ok': true, 'screen': 'welcome'};
            case 'editor':
              final activeStack = ref.read(core_stack.activeStackProvider);
              if (activeStack == null) {
                return {
                  'ok': false,
                  'error': 'no stack is open; use open_stack first',
                };
              }
              ref
                  .read(selectedActivityItemProvider.notifier)
                  .state = AppActivityItemType.lens;
              return {'ok': true, 'screen': 'editor'};
            default:
              return {
                'ok': false,
                'error': 'screen must be "welcome" or "editor"',
              };
          }

        case 'run_search':
          final keyword = params['keyword'] as String?;
          if (keyword == null || keyword.trim().isEmpty) {
            return {'ok': false, 'error': 'keyword is required'};
          }
          final searchService = ref.read(searchExecutionServiceProvider);
          if (searchService == null) {
            return {'ok': false, 'error': 'no stack is open'};
          }
          ref.read(keywordSearchQueryProvider.notifier).setQuery(keyword);
          ref.read(keywordSearchExecutingProvider.notifier).start();
          try {
            final result = await searchService.executeKeywordSearch(
              keyword: keyword,
              options: const ExplorationOptions(maxResults: 200),
            );
            ref.read(keywordSearchResultProvider.notifier).setResult(result);
            ref.read(searchHighlightProvider.notifier).setIds(
              nodeIds: result.nodes.map((n) => n.id).toSet(),
              linkIds: result.links.map((l) => l.id).toSet(),
            );
            return {
              'ok': true,
              'node_count': result.nodes.length,
              'link_count': result.links.length,
            };
          } catch (e) {
            return {'ok': false, 'error': 'search failed: $e'};
          } finally {
            ref.read(keywordSearchExecutingProvider.notifier).stop();
          }

        case 'open_node':
          final id = params['id'] as String?;
          if (id == null) {
            return {'ok': false, 'error': 'id is required'};
          }
          final entityId = core_graph.EntityId.fromString(id);
          ref
              .read(selectionStateProvider.notifier)
              .selectEntity(entityId, source: SelectionSource.program);
          ref.read(screenBasedSecondarySidebarStateProvider.notifier).show();
          return {'ok': true, 'id': id};

        case 'focus_node':
          final id = params['id'] as String?;
          if (id == null) {
            return {'ok': false, 'error': 'id is required'};
          }
          ref
              .read(searchFocusTargetProvider.notifier)
              .focus(core_graph.EntityId.fromString(id));
          return {'ok': true, 'id': id};

        case 'highlight_nodes':
          final rawIds = params['ids'];
          if (rawIds == null) {
            return {'ok': false, 'error': 'ids is required'};
          }
          final List<dynamic> idList =
              rawIds is List ? rawIds : [rawIds];
          final nodeIds = idList
              .map((e) => core_graph.EntityId.fromString(e.toString()))
              .toSet()
              .cast<core_graph.EntityId>();
          ref.read(searchHighlightProvider.notifier).setIds(
            nodeIds: nodeIds,
            linkIds: const {},
          );
          return {'ok': true, 'count': nodeIds.length};

        default:
          return {'ok': false, 'error': 'unknown command: $command'};
      }
    };

    // Initialize the link between entity selection and the editor
    ref.watch(initializeEntitySelectionBridgeProvider);

    // Initialize activity bar change monitoring
    ref.watch(activityBarChangeListenerProvider);

    // Sync Riverpod secondary sidebar state to FondeSecondarySidebarController
    ref.listen<bool>(secondarySidebarStateProvider, (previous, next) {
      if (_secondarySidebarController.isVisible != next) {
        _secondarySidebarController.setVisible(next);
      }
    });

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
      commandLineArgs: widget.commandLineArgs,
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
        startupConfig.enableDevStacks || widget.enableDevStacks;

    debugPrint(
      'MainAppShell: enableDevStacks=$actualEnableDevStacks (config: ${startupConfig.enableDevStacks}, arg: ${widget.enableDevStacks}), devStacksImported=${shellState.devStacksImported}',
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
      return _buildStackManagementContent();
    }

    return widgets.Stack(
      children: [
        FondeScaffold(
          toolbar: FondeMainToolbar(
            trailing: const _SecondarySidebarToggleButton(),
          ),
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
          secondarySidebarController: _secondarySidebarController,
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

  Widget _buildStackManagementContent() {
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
          final navContext = widget.navigatorKey?.currentContext;
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

/// Button in the title bar to open the secondary sidebar (details panel).
///
/// Only shown when the secondary sidebar is closed. The close button lives
/// inside the secondary sidebar toolbar itself.
class _SecondarySidebarToggleButton extends ConsumerWidget {
  const _SecondarySidebarToggleButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(secondarySidebarStateProvider);

    // Hide button when sidebar is already open
    if (isVisible) return const SizedBox.shrink();

    final iconTheme = context.fondeIconTheme;
    final appColorScheme = context.fondeColorScheme;

    return ExcludeFocus(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: SizedBox(
          width: 28,
          height: 28,
          child: FondeIconButton(
            icon: iconTheme.panelRight,
            iconSize: 20,
            tooltip: 'Open Details Panel',
            iconColor: appColorScheme.base.foreground,
            onPressed: () {
              final controller =
                  FondeSidebarControllerScope.secondaryOf(context);
              controller?.show();
              ref
                  .read(screenBasedSecondarySidebarStateProvider.notifier)
                  .show();
            },
            padding: EdgeInsets.zero,
            hoverColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
