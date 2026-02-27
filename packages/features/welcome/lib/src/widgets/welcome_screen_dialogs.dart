/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';
import 'package:features_welcome/src/widgets/stack_info_dialog.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:core_samples/core_samples.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:features_welcome/src/widgets/welcome_models.dart';
import 'package:features_welcome/src/providers/welcome_providers.dart';
import 'package:core_foundation_flutter/core_foundation_flutter.dart'; // debugLog, AppSnackBar のために追加
import 'package:features_welcome/src/services/debug_stack_operations.dart'; // DebugStackOperations のために追加

import '../widgets/welcome_screen_helpers.dart';

/// Display stack info dialog
void showStackInfoDialogHelper(BuildContext context, core_stack.Stack stack) {
  showStackInfoDialog(
    context: context,
    stack: stack,
    onStackNameChanged: (newName) {
      // Handle stack name change
      // TODO: Implement stack name update process
      debugPrint('Stack name changed to: $newName');
    },
  );
}

/// Show stack in Finder
Future<void> showStackInFinderHelper(
  BuildContext context,
  core_stack.Stack stack,
) async {
  try {
    final stackDirectory = stack.directory.parent;

    if (Platform.isMacOS) {
      // For macOS, use `open` command
      final result = await Process.run('open', [stackDirectory.path]);
      if (result.exitCode == 0) {
        debugPrint('Opened stack directory in Finder: ${stackDirectory.path}');
      } else {
        debugPrint('Failed to open Finder: ${result.stderr}');
        if (context.mounted) {
          AppSnackBar.showError(
            context: context,
            message: 'Failed to open folder in Finder',
          );
        }
      }
    } else {
      // For other platforms, use url_launcher
      final uri = Uri.file(stackDirectory.path);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        debugPrint('Opened stack directory: ${stackDirectory.path}');
      } else {
        debugPrint(
          'Cannot launch file manager for path: ${stackDirectory.path}',
        );
        if (context.mounted) {
          AppSnackBar.showError(
            context: context,
            message: 'Failed to open folder in file manager',
          );
        }
      }
    }
  } catch (e) {
    debugPrint('Error opening stack in file manager: $e');
    if (context.mounted) {
      AppSnackBar.showError(
        context: context,
        message: 'Error opening folder: $e',
      );
    }
  }
}

/// Display archive confirmation dialog
void showArchiveConfirmationDialogHelper(
  BuildContext context,
  WidgetRef ref,
  dynamic stackData,
  Function(WidgetRef, dynamic) archiveStackCallback,
) {
  showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      final colorScheme = ref.read(effectiveColorSchemeProvider);

      return AlertDialog(
        backgroundColor: colorScheme.base.background,
        title: AppText(
          'Archive this stack?',
          variant: AppTextVariant.dialogTitleStandard,
          color: colorScheme.base.foreground,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildWarningItemHelper(
              'Archived stacks will not appear in your stack collection.',
              colorScheme,
            ),
            AppSpacing.sm(),
            buildWarningItemHelper(
              'You can restore this change at any time.',
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
            label: 'Archive',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  ).then((confirmed) {
    if (confirmed == true) {
      archiveStackCallback(ref, stackData);
    }
  });
}

/// Archive stack
Future<void> archiveStackHelper(WidgetRef ref, dynamic stackData) async {
  try {
    // Get original stack from CoreStackWrapper
    if (stackData is CoreStackWrapper) {
      final originalStack = stackData.originalStack;

      // Save stack settings to file
      final updatedSettings = originalStack.settings.copyWith(
        customFields: {
          ...originalStack.settings.customFields,
          'isArchived': true,
        },
      );
      await saveStackSettingsHelper(originalStack, updatedSettings);
      debugPrint('Archived stack: ${originalStack.info.name}');

      // Update stack list
      ref.read(core_stack.stackActionsProvider.notifier).triggerRefresh();
    }
  } catch (e) {
    debugPrint('Error archiving stack: $e');
  }
}

/// Restore stack (unarchive)
Future<void> restoreStackHelper(WidgetRef ref, dynamic stackData) async {
  try {
    // Get original stack from CoreStackWrapper
    if (stackData is CoreStackWrapper) {
      final originalStack = stackData.originalStack;

      // Save stack settings to file
      final updatedSettings = originalStack.settings.copyWith(
        customFields: {
          ...originalStack.settings.customFields,
          'isArchived': false,
        },
      );

      await saveStackSettingsHelper(originalStack, updatedSettings);
      debugPrint('Restored stack: ${originalStack.info.name}');

      // Update stack list
      ref.read(core_stack.stackActionsProvider.notifier).triggerRefresh();
    }
  } catch (e) {
    debugPrint('Error restoring stack: $e');
  }
}

/// Display stack template installation confirmation dialog
void showInstallConfirmationDialogHelper(
  BuildContext context,
  WidgetRef ref,
  dynamic manifest,
  Function(dynamic) installSampleStackTemplateCallback,
) {
  final colorScheme = ref.read(effectiveColorSchemeProvider);

  showAppDialog<bool>(
    context: context,
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
        buildWarningItemHelper('A new stack will be created.', colorScheme),
        AppSpacing.sm(),
        buildWarningItemHelper(
          'After installation, it will appear in your active stacks list.',
          colorScheme,
        ),
      ],
    ),
    footer: buildDialogFooterHelper(
      colorScheme: colorScheme,
      cancelLabel: 'Cancel',
      confirmLabel: 'Install',
      onCancel: () => Navigator.of(context).pop(false),
      onConfirm: () => Navigator.of(context).pop(true),
    ),
  ).then((confirmed) {
    if (confirmed == true) {
      installSampleStackTemplateCallback(manifest);
    }
  });
}

/// Install sample stack template
Future<void> installSampleStackTemplateHelper(
  BuildContext context,
  WidgetRef ref,
  dynamic manifest,
) async {
  try {
    debugPrint(
      '[WelcomeScreenContent] Starting installation of sample stack "${manifest.displayName}"',
    );
    final stackActions = ref.read(core_stack.stackActionsProvider.notifier);
    final success = await stackActions.createSampleStackFromManifest(manifest);
    debugPrint('[WelcomeScreenContent] Installation result: $success');

    if (context.mounted) {
      if (success) {
        debugPrint('[WelcomeScreenContent] Triggering stack list update');
        // Explicitly update stack list
        ref.read(core_stack.stackActionsProvider.notifier).triggerRefresh();

        debugPrint('[WelcomeScreenContent] Switching to active stacks display');
        ref.read(stackDisplayModeProvider.notifier).state =
            StackDisplayModeType.active;

        // Display installation success dialog
        showInstallationSuccessDialogHelper(context, ref, manifest);
        // Find the newly installed stack and activate it
        final allStacks = ref.read(allAvailableStacksProvider).value;
        final newlyInstalledStack = allStacks?.firstWhere(
          (s) =>
              s.info.name ==
              manifest.displayName, // Assuming unique display name
          orElse: () => throw StateError('Newly installed stack not found'),
        );

        // TODO: onStackSelectedCallback is null here
        // if (newlyInstalledStack != null && onStackSelectedCallback != null) {
        //   onStackSelectedCallback(newlyInstalledStack);
        // }
      } else {
        // Display error message
        AppSnackBar.showError(
          context: context,
          message: 'Failed to install sample stack',
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      AppSnackBar.showError(context: context, message: 'An error occurred: $e');
    }
  }
}

/// Save stack settings to file
Future<void> saveStackSettingsHelper(
  core_stack.Stack stack,
  core_stack.StackSettings settings,
) async {
  try {
    final settingsFile = File('${stack.directory.path}/meta/settings.json');

    // Create meta directory if it doesn't exist
    final metaDir = Directory('${stack.directory.path}/meta');
    if (!await metaDir.exists()) {
      await metaDir.create(recursive: true);
    }

    // Save settings as JSON
    final jsonString = const JsonEncoder.withIndent(
      '  ',
    ).convert(settings.toJson());
    await settingsFile.writeAsString(jsonString);

    debugPrint('Stack settings saved to: ${settingsFile.path}');
  } catch (e) {
    debugPrint('Error saving stack settings: $e');
    rethrow;
  }
}

/// Display installation success dialog
void showInstallationSuccessDialogHelper(
  BuildContext context,
  WidgetRef ref,
  dynamic manifest,
) {
  final colorScheme = ref.read(effectiveColorSchemeProvider);

  showAppDialog<void>(
    context: context,
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
    footer: buildDialogFooterHelper(
      colorScheme: colorScheme,
      confirmLabel: 'OK',
      onConfirm: () => Navigator.of(context).pop(),
    ),
  );
}

/// Build dialog footer with optional cancel and confirm buttons
Widget buildDialogFooterHelper({
  required AppColorScheme colorScheme,
  String? cancelLabel,
  String? confirmLabel,
  VoidCallback? onCancel,
  VoidCallback? onConfirm,
  bool isDestructive = false,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: colorScheme.base.border, width: 1)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(AppSpacingValues.xl),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (cancelLabel != null && onCancel != null) ...[
            AppButton.cancel(label: cancelLabel, onPressed: onCancel),
            const SizedBox(width: 12),
          ],
          if (confirmLabel != null && onConfirm != null)
            isDestructive
                ? AppButton.destructive(
                  label: confirmLabel,
                  onPressed: onConfirm,
                )
                : AppButton.primary(label: confirmLabel, onPressed: onConfirm),
        ],
      ), // Row を閉じる
    ), // Padding を閉じる (ここが欠けていた)
  ); // Container を閉じる
}

/// Build warning item
Widget buildWarningItemHelper(String text, AppColorScheme colorScheme) {
  return AppText(
    text,
    variant: AppTextVariant.bodyText,
    color: colorScheme.base.foreground.withValues(alpha: 0.8),
  );
}

// Debug helper functions moved from welcome_screen_grid_header.dart
/// Debug: Confirmation dialog to archive all stacks
void showDebugArchiveAllConfirmationHelper(
  BuildContext context,
  WidgetRef ref,
) {
  final colorScheme = ref.read(effectiveColorSchemeProvider);

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
            buildWarningItemHelper(
              'This operation will archive all active stacks.',
              colorScheme,
            ),
            AppSpacing.sm(),
            buildWarningItemHelper('Use for debug purposes only.', colorScheme),
            AppSpacing.sm(),
            buildWarningItemHelper(
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
      executeDebugArchiveAllHelper(context, ref);
    }
  });
}

/// Debug: Confirmation dialog to delete all stacks
void showDebugDeleteAllConfirmationHelper(BuildContext context, WidgetRef ref) {
  final colorScheme = ref.read(effectiveColorSchemeProvider);

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
            buildWarningItemHelper(
              '⚠️ This operation will permanently delete all stacks.',
              colorScheme,
            ),
            AppSpacing.sm(),
            buildWarningItemHelper(
              '⚠️ This operation cannot be undone.',
              colorScheme,
            ),
            AppSpacing.sm(),
            buildWarningItemHelper('Use for debug purposes only.', colorScheme),
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
      executeDebugDeleteAllHelper(context, ref);
    }
  });
}
