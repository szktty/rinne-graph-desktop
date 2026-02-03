import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';

import '../providers/pathfinder_providers.dart';
import 'pathfinder_dialog.dart';

/// Pathfinder field widget
///
/// Search field displayed in the title bar and pathfinder display button
class PathfinderField extends ConsumerWidget {
  /// Constructor
  const PathfinderField({
    super.key,
    this.hintText,
    this.onSubmitted,
    this.isEnabled = true,
  });

  /// Hint text (optional, defaults to 'Search path... (Ctrl+P)')
  final String? hintText;

  /// Whether the field is enabled
  final bool isEnabled;

  /// Callback when search query is submitted
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get App color scheme
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final displayHintText = hintText ?? 'Search path... (Ctrl+P)';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        color: Colors.transparent,
        child: AppTextField(
          enabled: isEnabled,
          hintText: displayHintText,
          prefixIcon: Icon(
            AppIcons.search,
            size: 18,
            color:
                isEnabled
                    ? appColorScheme.interactive.quickInput.iconColor
                    : appColorScheme.interactive.quickInput.iconColor.withAlpha(
                      102,
                    ), // 0.4 opacity
          ),
          backgroundColor:
              isEnabled
                  ? appColorScheme.interactive.quickInput.fieldBackground
                  : appColorScheme.interactive.quickInput.fieldBackground
                      .withAlpha(64), // 0.25 opacity
          borderColor: appColorScheme.interactive.quickInput.fieldBorder,
          activeBorderColor:
              appColorScheme.interactive.quickInput.fieldActiveBorder,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          style: TextStyle(
            fontSize: 13,
            color:
                isEnabled
                    ? appColorScheme.interactive.quickInput.inputText
                    : appColorScheme.interactive.quickInput.inputText.withAlpha(
                      128,
                    ), // 0.5 opacity
          ),
          onSubmitted:
              isEnabled
                  ? (value) {
                    if (value.isEmpty) {
                      // Display pathfinder dialog
                      showPathfinderDialog(context, ref);
                    } else {
                      // Normal search processing
                      onSubmitted?.call(value);
                    }
                  }
                  : null,
          onTap:
              isEnabled
                  ? () {
                    // Display pathfinder dialog when field is tapped
                    showPathfinderDialog(context, ref);
                  }
                  : null,
        ),
      ),
    );
  }
}

/// Display pathfinder dialog
Future<void> showPathfinderDialog(BuildContext context, WidgetRef ref) async {
  // Reset search query
  ref.read(pathfinderSearchQueryProvider.notifier).clearQuery();

  // Open pathfinder
  ref.read(pathfinderOpenProvider.notifier).setIsOpen(true);

  // Note: Selected entity processing is done within the pathfinder dialog.
  // Selected entities in the pathfinder dialog are stored in selectedEntityProvider,
  // and other components reference it for processing.

  // Display dialog
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => const PathfinderDialog(),
  );

  // Close pathfinder when dialog is closed
  ref.read(pathfinderOpenProvider.notifier).setIsOpen(false);
}
