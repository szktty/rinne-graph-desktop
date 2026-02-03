import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:features_pathfinder/pathfinder.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;

/// Title bar for the main area.
///
/// A title bar placed within the main area, including a pathfinder and
/// sidebar toggle button.
class MainAreaTitlebar extends ConsumerWidget {
  const MainAreaTitlebar({
    this.activeStack,
    this.selectedActivityIndex = 0,
    super.key,
  });

  final core_stack.Stack? activeStack;
  final int selectedActivityIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final sidebarVisible = ref.watch(primarySidebarStateProvider);

    return Container(
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
      child: Padding(
        padding:
            Platform.isMacOS
                ? const EdgeInsets.only(top: 2.0)
                : EdgeInsets.zero,
        child: Row(
          children: [
            // Left padding (if sidebar is visible)
            if (sidebarVisible) const SizedBox(width: 24.0),

            // Sidebar display button (only visible when the sidebar is hidden)
            if (!sidebarVisible)
              Padding(
                padding: const EdgeInsets.only(
                  left:
                      MacOSConstants
                          .leftSafeArea, // Safe area considering traffic light buttons
                  right: 8.0,
                ),
                child: _buildPrimarySidebarToggle(ref),
              ),

            // Center area (pathfinder)
            Expanded(child: _buildPathfinderField(context, ref, activeStack)),

            // Right area (secondary sidebar toggle button)
            if (_shouldShowDetailsPaneToggle(selectedActivityIndex))
              _buildSecondarySidebarToggleArea(ref),
          ],
        ),
      ),
    );
  }

  /// Build the primary sidebar toggle button.
  Widget _buildPrimarySidebarToggle(WidgetRef ref) {
    return AppIconButton(
      icon: AppIcons.panelLeft,
      iconSize: 20,
      onPressed: () {
        // Show secondary sidebar
        ref.read(primarySidebarStateProvider.notifier).show();
      },
      tooltip: 'Show Sidebar',
      padding: EdgeInsets.zero,
    );
  }

  /// Build the secondary sidebar toggle area.
  Widget _buildSecondarySidebarToggleArea(WidgetRef ref) {
    final isSecondarySidebarVisible = ref.watch(secondarySidebarStateProvider);

    // Do not display the button if the secondary sidebar is visible.
    if (isSecondarySidebarVisible) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: _buildSecondarySidebarToggle(ref),
    );
  }

  /// Build the secondary sidebar toggle button.
  Widget _buildSecondarySidebarToggle(WidgetRef ref) {
    return AppIconButton(
      icon: AppIcons.panelRight,
      iconSize: 20,
      onPressed: () {
        // Show secondary sidebar
        // Note: This component is inside the presentation_components package, so
        // screenBasedSecondarySidebarStateProvider of apps/desktop cannot be used.
        ref.read(secondarySidebarStateProvider.notifier).show();
      },
      tooltip: 'Open Details Panel',
      padding: EdgeInsets.zero,
      splashRadius: 20,
      hoverColor: Colors.transparent,
    );
  }

  /// Whether the details panel toggle button should be displayed.
  bool _shouldShowDetailsPaneToggle(int selectedActivityIndex) {
    // List of screen indices where the details panel can be displayed
    const detailsPaneEnabledScreens = [0, 10]; // Graph Navigation, Table View
    return detailsPaneEnabledScreens.contains(selectedActivityIndex);
  }

  /// Build the pathfinder field.
  Widget _buildPathfinderField(
    BuildContext context,
    WidgetRef ref,
    core_stack.Stack? activeStack,
  ) {
    return PathfinderField(
      // Enable only when a stack is selected
      isEnabled: activeStack != null,
      onSubmitted: (value) {
        // TODO: Implement search processing
        debugPrint('Search: $value');
      },
    );
  }
}
