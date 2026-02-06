import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:features_welcome/src/providers/welcome_providers.dart';
import 'package:features_stack_management/features_stack_management.dart';
import 'package:features_welcome/src/widgets/import_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:core_stack_common/src/service/stack_metadata_service.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'dart:io';

/// Action buttons section for the welcome screen.
class WelcomeScreenActionButtons extends ConsumerWidget {
  final VoidCallback? onCreateNewStack;
  final ValueChanged<core_stack.Stack>? onStackSelected;
  final VoidCallback? onOpenStack;

  const WelcomeScreenActionButtons({
    this.onCreateNewStack,
    this.onStackSelected,
    this.onOpenStack,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          'Get Started',
          variant: AppTextVariant.textBody,
          color: colorScheme.base.foreground,
        ),
        const SizedBox(height: 16),
        AppButton.primary(
          label: 'Create New Stack...',
          onPressed: () => _showNewStackCreationDialog(context, ref),
        ),
        const SizedBox(height: 16),
        AppButton.normal(
          label: 'Open Existing Stack...',
          onPressed: () => _showOpenStackDialog(context, ref),
        ),
        const SizedBox(height: 16),
        AppButton.normal(
          label: 'Import Data...',
          onPressed: () {
            showImportDialog(context);
          },
        ),
        const SizedBox(height: 32),
        const AppDivider(),
        const SizedBox(height: 32),
        AppButton.normal(
          label: 'Install Sample Stacks...',
          onPressed: () {
            ref.read(stackDisplayModeProvider.notifier).state =
                StackDisplayModeType.sampleTemplate;
          },
        ),
      ],
    );
  }

  /// Display new stack creation dialog
  Future<void> _showNewStackCreationDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final createdStack = await StackManagementService.createNewStack(context);

    if (createdStack != null && context.mounted) {
      // Open created stack and transition to graph navigation screen
      // Execute stack selection (error handling is done by caller)
      onStackSelected?.call(createdStack);

      // Call external callback (if needed)
      onCreateNewStack?.call();
    }
  }

  /// Display open stack dialog
  Future<void> _showOpenStackDialog(BuildContext context, WidgetRef ref) async {
    try {
      // Select file or directory
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        dialogTitle: 'Select stack file (.rinne_graph_desktop) or stack folder',
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final String selectedPath = result.files.first.path!;
        debugPrint('Selected path: $selectedPath');

        try {
          final Directory stackDir;
          if (selectedPath.endsWith('.rinne_graph_desktop')) {
            // If a .rinne_graph_desktop file is selected, consider its parent directory as the stack directory
            stackDir = File(selectedPath).parent;
          } else {
            // Otherwise, assume the selected path is a stack directory
            stackDir = Directory(selectedPath);
          }

          // Validate if stackDir exists
          if (!await stackDir.exists()) {
            if (context.mounted) {
              AppSnackBar.showError(
                context: context,
                message: 'Invalid stack path: $selectedPath.',
              );
            }
            return;
          }

          // Load stack metadata
          final StackMetadataService metadataService = StackMetadataService();
          final (info, settings) = await metadataService.loadMetadata(stackDir);

          if (info != null) {
            final core_stack.Stack stack = core_stack.Stack(
              directory: stackDir,
              info: info,
              settings: settings ?? const core_stack.StackSettings(),
            );

            onStackSelected?.call(stack);
            ref.read(core_stack.stackActionsProvider.notifier).triggerRefresh();
          } else {
            debugPrint('Failed to load stack info from ${stackDir.path}');
            if (context.mounted) {
              AppSnackBar.showError(
                context: context,
                message:
                    'Failed to load stack info from ${stackDir.path}. '
                    'Ensure "info.json" is present and valid.',
              );
            }
          }
        } catch (e) {
          debugPrint('Error opening stack: $e');
          if (context.mounted) {
            AppSnackBar.showError(
              context: context,
              message: 'An error occurred while opening stack: $e',
            );
          }
        }
        onOpenStack?.call(); // Original callback if needed
      }
    } catch (e) {
      debugPrint('Error opening stack: $e');
      if (context.mounted) {
        AppSnackBar.showError(
          context: context,
          message: 'Failed to open stack: $e',
        );
      }
    }
  }
}
