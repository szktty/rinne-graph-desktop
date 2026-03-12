/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:features_pathfinder/pathfinder.dart';
import 'package:presentation_components/presentation_components.dart'
    hide FondeSidebar;
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:core_graph_flutter/core_graph.dart' as core_graph;

import '../providers/app_state_providers.dart';
// Command registry feature planned for future implementation

/// Title bar toolbar for the application
///
/// Cross-platform toolbar displayed in the application's window title bar.
/// Consists of left area, navigation area, center area, and right area.
class Titlebar extends ConsumerWidget {
  const Titlebar({required this.content, super.key});

  /// Main content
  final Widget content;

  // Flag indicating whether commands are registered
  static bool commandsRegistered = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedActivityIndex = ref.watch(selectedActivityIndexProvider);

    // Do not display the toolbar on the welcome screen (index 11)
    if (selectedActivityIndex == 11) {
      return content;
    }

    // Get theme settings
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    // Get currently selected stack
    final activeStack = ref.watch(core_stack.activeStackProvider);

    // FondeSidebar visibility status
    final isPrimarySidebarVisible = ref.watch(fondePrimarySidebarStateProvider);
    final isSecondarySidebarVisible = ref.watch(fondeSecondarySidebarStateProvider);

    // Register commands
    if (!commandsRegistered) {
      // Execute only once
      commandsRegistered = true;

      // Command registry feature planned for future implementation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // TODO: Implement command registry feature
      });
    }

    // The toolbar is composed directly with a Column instead of a Stack to place it within the main area
    return Column(
      children: [
        // Custom toolbar
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: appColorScheme.uiAreas.titleBar.background,
            border: Border(
              bottom: BorderSide(
                color: appColorScheme.uiAreas.titleBar.border,
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            children: [
              // Left area (sidebar toggle button)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: FondeIconButton(
                  iconSize: 20,
                  icon:
                      isPrimarySidebarVisible
                          ? FondeIcons.panelLeftClose
                          : FondeIcons.panelLeft,
                  onPressed: () {
                    ref.read(fondePrimarySidebarStateProvider.notifier).toggle();
                  },
                  tooltip:
                      isPrimarySidebarVisible
                          ? 'Close sidebar'
                          : 'Open sidebar',
                ),
              ),
              const SizedBox(width: 4),

              // Center area (Pathfinder)
              Expanded(child: _buildPathfinderField(context, ref, activeStack)),

              // Right area (secondary sidebar toggle button)
              if (_shouldShowDetailsPaneToggle(selectedActivityIndex))
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: Icon(
                      isSecondarySidebarVisible
                          ? FondeIcons.panelRightClose
                          : FondeIcons.panelRight,
                      size: 20,
                    ),
                    onPressed:
                        () =>
                            ref
                                .read(
                                  screenBasedSecondarySidebarStateProvider
                                      .notifier,
                                )
                                .toggle(),
                    tooltip:
                        isSecondarySidebarVisible
                            ? 'Close details panel'
                            : 'Open details panel',
                    splashRadius: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Main content
        Expanded(child: content),
      ],
    );
  }

  /// Whether the details panel toggle button should be displayed
  bool _shouldShowDetailsPaneToggle(int selectedActivityIndex) {
    // Index list of screens where the details panel can be displayed
    const detailsPaneEnabledScreens = [0, 10]; // Graph Navigation, Table View
    return detailsPaneEnabledScreens.contains(selectedActivityIndex);
  }

  /// Builds the pathfinder field
  Widget _buildPathfinderField(
    BuildContext context,
    WidgetRef ref,
    core_stack.Stack? activeStack,
  ) {
    // Get current graph data
    final activeGraph = ref.watch(core_graph.activeGraphProvider);

    // Get pathfinder state
    final pathfinderState = ref.watch(pathfinderStateProvider);

    final graph = activeGraph;

    // Set graph data for pathfinder (only when necessary)
    if (pathfinderState.activeGraph != graph) {
      Future(() {
        ref.read(pathfinderStateProvider.notifier).setActiveGraph(graph);
      });
    }

    return PathfinderField(
      // Enable only when a stack is selected
      isEnabled: activeStack != null,
      onSubmitted: (value) {
        debugPrint('Search: $value');
        if (graph != null && value.isNotEmpty) {
          final results = ref
              .read(pathfinderStateProvider.notifier)
              .searchEntities(value);
          debugPrint('Search results: ${results.length} items');
          if (results.isNotEmpty) {
            ref
                .read(pathfinderStateProvider.notifier)
                .addRecentItem(results.first);
          }
        }
      },
    );
  }
}
