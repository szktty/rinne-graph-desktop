part of '../welcome_dialog_content.dart';

/// Determine if debug mode is enabled
bool _isDebugMode(_WelcomeDialogContentState state) {
  try {
    final debugMode = state.ref.watch(debugModeProvider);
    return debugMode;
  } catch (e) {
    // Return false if provider is not available
    return false;
  }
}

/// Debug: Confirmation dialog to archive all stacks
void _showDebugArchiveAllConfirmation(
  _WelcomeDialogContentState state,
  BuildContext context,
) {
  final colorScheme = state.ref.read(effectiveColorSchemeProvider);

  showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: colorScheme.base.background,
        title: AppText(
          '[DEBUG] Archive all stacks?',
          variant: AppTextVariant.dialogTitleStandard,
          color: colorScheme.base.foreground,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWarningItem(
              state,
              'This operation will archive all active stacks.',
              colorScheme,
            ),
            AppSpacing.sm(),
            _buildWarningItem(
              state,
              'Use for debug purposes only.',
              colorScheme,
            ),
            AppSpacing.sm(),
            _buildWarningItem(
              state,
              'You can restore these changes individually.',
              colorScheme,
            ),
          ],
        ),
        actions: [
          AppButton.cancel(
            label: 'Cancel',
            onPressed: () => Navigator.of(context).pop(false),
          ),
          const SizedBox(width: 12),
          AppButton.destructive(
            label: 'Archive all',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  ).then((confirmed) {
    if (confirmed == true) {
      _executeDebugArchiveAll(state);
    }
  });
}

/// Debug: Confirmation dialog to delete all stacks
void _showDebugDeleteAllConfirmation(
  _WelcomeDialogContentState state,
  BuildContext context,
) {
  final colorScheme = state.ref.read(effectiveColorSchemeProvider);

  showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: colorScheme.base.background,
        title: AppText(
          '[DEBUG] Delete all stacks?',
          variant: AppTextVariant.dialogTitleStandard,
          color: colorScheme.base.foreground,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWarningItem(
              state,
              '⚠️ This operation will permanently delete all stacks.',
              colorScheme,
            ),
            AppSpacing.sm(),
            _buildWarningItem(
              state,
              '⚠️ This operation cannot be undone.',
              colorScheme,
            ),
            AppSpacing.sm(),
            _buildWarningItem(
              state,
              'Use for debug purposes only.',
              colorScheme,
            ),
          ],
        ),
        actions: [
          AppButton.cancel(
            label: 'Cancel',
            onPressed: () => Navigator.of(context).pop(false),
          ),
          const SizedBox(width: 12),
          AppButton.destructive(
            label: 'Delete all',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  ).then((confirmed) {
    if (confirmed == true) {
      _executeDebugDeleteAll(state);
    }
  });
}

/// Debug: Execute archive all stacks operation
Future<void> _executeDebugArchiveAll(_WelcomeDialogContentState state) async {
  try {
    final debugOps = DebugStackOperations(state.ref);
    final result = await debugOps.archiveAllStacks();

    if (state.context.mounted) {
      AppSnackBar.showInfo(context: state.context, message: result.message);
    }

    debugLog('Debug operation completed: ${result.toString()}');
  } catch (e) {
    debugLog('Error in debug archive operation: $e');
    if (state.context.mounted) {
      AppSnackBar.showError(
        context: state.context,
        message: 'Error during archive operation: $e',
      );
    }
  }
}

/// Debug: Execute delete all stacks operation
Future<void> _executeDebugDeleteAll(_WelcomeDialogContentState state) async {
  try {
    final debugOps = DebugStackOperations(state.ref);
    final result = await debugOps.deleteAllStacks();

    if (state.context.mounted) {
      AppSnackBar.showInfo(context: state.context, message: result.message);
    }

    debugLog('Debug operation completed: ${result.toString()}');
  } catch (e) {
    debugLog('Error in debug delete operation: $e');
    if (state.context.mounted) {
      AppSnackBar.showError(
        context: state.context,
        message: 'Error during delete operation: $e',
      );
    }
  }
}
