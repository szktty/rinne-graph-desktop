import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';

import '../providers/sidebar_state_providers.dart';
import '../widgets/app_icon_button.dart';
import '../icons/app_icons.dart';

/// Title bar for the secondary sidebar.
///
/// A toolbar displayed at the top of the secondary sidebar.
/// Includes a collapse button on the right edge.
class SecondarySidebarTitlebar extends ConsumerWidget {
  const SecondarySidebarTitlebar({this.actions = const [], super.key});

  /// List of action buttons to display on the left.
  final List<Widget> actions;

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
      child: Row(
        children: [
          // Left action button
          ...actions.map(
            (action) => Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: action,
            ),
          ),

          // Center space
          const Expanded(child: SizedBox()),

          // Right collapse button
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _buildCollapseButton(ref),
          ),
        ],
      ),
    );
  }

  /// Build the collapse button.
  Widget _buildCollapseButton(WidgetRef ref) {
    return AppIconButton(
      icon: AppIcons.panelRightClose,
      iconSize: 20,
      onPressed: () {
        // Hide the secondary sidebar
        // Note: This component is inside the presentation_components package, so
        // screenBasedSecondarySidebarStateProvider of apps/desktop cannot be used.
        ref.read(secondarySidebarStateProvider.notifier).hide();
      },
      tooltip: 'Close Details Panel',
      padding: EdgeInsets.zero,
      hoverColor: Colors.transparent,
    );
  }
}
