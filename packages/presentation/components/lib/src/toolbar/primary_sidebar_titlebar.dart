import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';

/// Title bar for the primary sidebar.
///
/// A title bar placed at the top of the primary sidebar area, including a
/// sidebar collapse button.
class PrimarySidebarTitlebar extends ConsumerWidget {
  const PrimarySidebarTitlebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return Container(
      height: 50, // Same height as the main area title bar
      decoration: BoxDecoration(
        color: appColorScheme.uiAreas.titleBar.background,
        border: Border(
          bottom: BorderSide(
            color: appColorScheme.uiAreas.titleBar.border,
            width: 1.0,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // If available width is not sufficient, display only the collapse button
          final availableWidth = constraints.maxWidth;
          final minRequiredWidth =
              MacOSConstants.trafficLightButtonsWidth +
              40; // Considering button width

          if (availableWidth < minRequiredWidth) {
            return const SizedBox.shrink(); // Display nothing if width is insufficient
          }

          return Padding(
            padding:
                Platform.isMacOS
                    ? const EdgeInsets.only(top: 2.0)
                    : EdgeInsets.zero,
            child: Row(
              children: [
                // Sidebar collapse button to the right of the traffic light buttons
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: MacOSConstants.leftSafeArea,
                    ),
                    child: _buildPrimarySidebarToggle(ref),
                  ),
                ),
                // Remaining space (other buttons can be added in the future)
                const Expanded(child: SizedBox()),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build the primary sidebar collapse button.
  Widget _buildPrimarySidebarToggle(WidgetRef ref) {
    return AppIconButton(
      icon: AppIcons.panelLeftClose, // Collapse icon
      iconSize: 20,
      onPressed: () {
        // Hide the sidebar
        ref.read(primarySidebarStateProvider.notifier).hide();
      },
      tooltip: 'Close Sidebar',
      padding: EdgeInsets.zero,
      hoverColor: Colors.transparent,
    );
  }
}
