part of '../welcome_dialog_content.dart';

/// Display stack template installation confirmation dialog
void _showInstallConfirmationDialog(
  _WelcomeDialogContentState state,
  StackTemplateManifest manifest,
) {
  final colorScheme = state.ref.watch(effectiveColorSchemeProvider);

  showAppDialog<bool>(
    context: state.context,
    title: 'Install this stack template?',
    barrierDismissible: false,
    width: 450,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Template name: ${manifest.displayName}',
          variant: AppTextVariant.bodyText,
          color: colorScheme.base.foreground,
        ),
        AppSpacing.sm(),
        if (manifest.description != null &&
            manifest.description!.isNotEmpty) ...[
          AppText(
            manifest.description!,
            variant: AppTextVariant.captionText,
            color: colorScheme.base.foreground,
          ),
          AppSpacing.sm(),
        ],
        _buildWarningItem(state, 'A new stack will be created.', colorScheme),
        AppSpacing.sm(),
        _buildWarningItem(
          state,
          'After installation, it will appear in your active stacks list.',
          colorScheme,
        ),
      ],
    ),
    footer: _buildDialogFooter(
      state,
      colorScheme: colorScheme,
      cancelLabel: 'Cancel',
      confirmLabel: 'Install',
      onCancel: () => Navigator.of(state.context).pop(false),
      onConfirm: () => Navigator.of(state.context).pop(true),
    ),
  ).then((confirmed) {
    if (confirmed == true) {
      _installSampleStackTemplate(state, manifest);
    }
  });
}

/// Display installation success dialog
void _showInstallationSuccessDialog(
  _WelcomeDialogContentState state,
  StackTemplateManifest manifest,
) {
  final colorScheme = state.ref.watch(effectiveColorSchemeProvider);

  showAppDialog<void>(
    context: state.context,
    title: 'Installation complete',
    barrierDismissible: false,
    width: 400,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.check_circle,
              color: colorScheme.status.success,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppText(
                'Stack template installation completed.',
                variant: AppTextVariant.bodyText,
                color: colorScheme.base.foreground,
              ),
            ),
          ],
        ),
        AppSpacing.md(),
        AppText(
          'Installed stack: ${manifest.displayName}',
          variant: AppTextVariant.captionText,
          color: colorScheme.base.foreground,
        ),
        AppSpacing.md(),
        AppText(
          'It now appears in your active stacks list.',
          variant: AppTextVariant.captionText,
          color: colorScheme.base.foreground,
        ),
      ],
    ),
    footer: _buildDialogFooter(
      state,
      colorScheme: colorScheme,
      confirmLabel: 'OK',
      onConfirm: () => Navigator.of(state.context).pop(),
    ),
  );
}

/// Install sample stack template
Future<void> _installSampleStackTemplate(
  _WelcomeDialogContentState state,
  StackTemplateManifest manifest,
) async {
  try {
    debugPrint(
      '[WelcomeDialog] Starting installation of sample stack "${manifest.displayName}"',
    );
    final stackActions = state.ref.read(
      core_stack.stackActionsProvider.notifier,
    );
    final success = await stackActions.createSampleStackFromManifest(manifest);
    debugPrint('[WelcomeDialog] Installation result: $success');

    if (state.context.mounted) {
      if (success) {
        debugPrint('[WelcomeDialog] Triggering stack list update');
        // Explicitly update stack list
        state.ref
            .read(core_stack.stackActionsProvider.notifier)
            .triggerRefresh();

        debugPrint('[WelcomeDialog] Switching to active stacks display');
        // On success, switch to active stacks display
        state.ref.read(stackDisplayModeProvider.notifier).state =
            StackDisplayModeType.active;

        // Display installation success dialog
        _showInstallationSuccessDialog(state, manifest);
      } else {
        // Display error message
        AppSnackBar.showError(
          context: state.context,
          message: 'Failed to install sample stack',
        );
      }
    }
  } catch (e) {
    if (state.context.mounted) {
      AppSnackBar.showError(
        context: state.context,
        message: 'An error occurred: $e',
      );
    }
  }
}
