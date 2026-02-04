import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:features_welcome/src/providers/welcome_providers.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:features_welcome/src/services/debug_stack_operations.dart';
import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';

/// Determine stack archive status
bool isStackArchivedHelper(dynamic stack) {
  return stack.isArchived;
}

/// Get display mode title
String getDisplayModeTitleHelper(dynamic displayMode) {
  switch (displayMode) {
    case StackDisplayModeType.archived:
      return 'Archived stacks';
    case StackDisplayModeType.sampleTemplate:
      return 'Sample stack templates';
    case StackDisplayModeType.active:
      return '';
    default: // Added default case for exhaustive switch
      return '';
  }
}

/// Determine if debug mode is enabled
bool isDebugModeHelper(WidgetRef ref) {
  try {
    final debugMode = ref.watch(debugModeProvider);
    return debugMode;
  } catch (e) {
    // Return false if provider is not available
    return false;
  }
}

/// Debug: Execute archive all stacks operation
Future<void> executeDebugArchiveAllHelper(
  BuildContext context,
  WidgetRef ref,
) async {
  try {
    final debugOps = DebugStackOperations(ref);
    final result = await debugOps.archiveAllStacks();

    if (context.mounted) {
      AppSnackBar.showInfo(context: context, message: result.message);
    }

    debugLog('Debug operation completed: ${result.toString()}');
  } catch (e) {
    debugLog('Error in debug archive operation: $e');
    if (context.mounted) {
      AppSnackBar.showError(
        context: context,
        message: 'Error during archive operation: $e',
      );
    }
  }
}

/// Debug: Execute delete all stacks operation
Future<void> executeDebugDeleteAllHelper(
  BuildContext context,
  WidgetRef ref,
) async {
  try {
    final debugOps = DebugStackOperations(ref);
    final result = await debugOps.deleteAllStacks();

    if (context.mounted) {
      AppSnackBar.showInfo(context: context, message: result.message);
    }

    debugLog('Debug operation completed: ${result.toString()}');
  } catch (e) {
    debugLog('Error in debug delete operation: $e');
    if (context.mounted) {
      AppSnackBar.showError(
        context: context,
        message: 'Error during delete operation: $e',
      );
    }
  }
}

/// Build version info widget for display in the top right
Widget buildVersionInfoHelper(WidgetRef ref) {
  final appColorScheme = ref.watch(effectiveColorSchemeProvider);
  final displayVersionAsync = ref.watch(displayVersionStringProvider);

  return displayVersionAsync.when(
    data:
        (version) => AppText(
          version,
          variant: AppTextVariant.bodyText,
          color: appColorScheme.base.foreground.withAlpha(179),
        ),
    loading:
        () => AppText(
          'Loading...',
          variant: AppTextVariant.bodyText,
          color: appColorScheme.base.foreground.withAlpha(179),
        ),
    error: (error, stack) => const SizedBox.shrink(),
  );
}
