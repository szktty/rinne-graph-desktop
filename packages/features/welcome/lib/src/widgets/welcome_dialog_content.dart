import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';
import 'package:features_stack_management/features_stack_management.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:core_samples/core_samples.dart';
import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/welcome_providers.dart';
import '../services/debug_stack_operations.dart';
import 'import_dialog.dart';
import 'stack_info_dialog.dart';
import 'welcome_models.dart';

import 'package:file_picker/file_picker.dart';

part 'parts/welcome_dialog_ui.dart';
part 'parts/welcome_dialog_stack_grid.dart';
part 'parts/welcome_dialog_actions.dart';
part 'parts/welcome_dialog_sample_actions.dart';
part 'parts/welcome_dialog_debug_actions.dart';

/// Function to display welcome dialog
void showWelcomeDialog(
  BuildContext context, {
  VoidCallback? onCreateNewStack,
  VoidCallback? onOpenStack,
  VoidCallback? onImportStack,
  ValueChanged<core_stack.Stack>? onStackSelected,
  VoidCallback? onGoToMainScreen,
  bool showCloseButton = false,
}) {
  showAppDialog(
    context: context,
    barrierDismissible: false,
    width: 900,
    height: 750,
    child: WelcomeDialogContent(
      onCreateNewStack: onCreateNewStack,
      onOpenStack: onOpenStack,
      onImportStack: onImportStack,
      onStackSelected: onStackSelected,
      onGoToMainScreen: onGoToMainScreen,
      showCloseButton: showCloseButton,
    ),
  );
}

/// Content of welcome dialog
class WelcomeDialogContent extends ConsumerStatefulWidget {
  final VoidCallback? onCreateNewStack;
  final VoidCallback? onOpenStack;
  final VoidCallback? onImportStack;
  final ValueChanged<core_stack.Stack>? onStackSelected;
  final VoidCallback? onGoToMainScreen;
  final bool showCloseButton;

  const WelcomeDialogContent({
    this.onCreateNewStack,
    this.onOpenStack,
    this.onImportStack,
    this.onStackSelected,
    this.onGoToMainScreen,
    this.showCloseButton = false,
    super.key,
  });

  @override
  ConsumerState<WelcomeDialogContent> createState() =>
      _WelcomeDialogContentState();
}

class _WelcomeDialogContentState extends ConsumerState<WelcomeDialogContent> {
  @override
  Widget build(BuildContext context) {
    // Get and display only user stacks (exclude stack templates as they are not operation targets)
    final stacksAsync = ref.watch(allAvailableStacksProvider);

    // TODO: Implement proper stack actions when stackActionsProvider is available

    // Manage state of selected stack
    final selectedStack = ref.watch(selectedWelcomeStackProvider);

    // Get appropriate color using core_themes package API
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    // Get text color
    final textColor = appColorScheme.uiAreas.sideBar.activeItemText;

    // Get color for sub text
    final subTextColor = appColorScheme.uiAreas.sideBar.inactiveItemText;

    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header section with version info (add 64px padding on left and right)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Version info at top right
                  Align(
                    alignment: Alignment.topRight,
                    child: _buildVersionInfo(this, appColorScheme),
                  ),
                  const SizedBox(height: 16),
                  // Header text
                  _buildHeader(this, textColor, subTextColor),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Grid area header (with action buttons) (add 64px padding on left and right)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: _buildGridHeader(this, context, appColorScheme),
            ),

            // Stack grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: _buildStackGrid(this, stacksAsync, selectedStack),
              ),
            ),

            // Close button (display only if showCloseButton is true)
            if (widget.showCloseButton)
              Padding(
                padding: const EdgeInsets.only(right: 64, bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton.cancel(
                      label: 'Close',
                      onPressed: () {
                        widget.onGoToMainScreen?.call();
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
