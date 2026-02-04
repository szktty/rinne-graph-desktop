part of '../welcome_dialog_content.dart';

/// Display new stack creation dialog
Future<void> _showNewStackCreationDialog(
  _WelcomeDialogContentState state,
  BuildContext context,
) async {
  final createdStack = await StackManagementService.createNewStack(context);

  if (createdStack != null && context.mounted) {
    // Open created stack and transition to graph navigation screen
    // Execute stack selection (error handling is done by caller)
    state.widget.onStackSelected?.call(createdStack);

    // Whether to close dialog is delegated to onStackSelected implementation
    // If error occurs, caller controls to not close dialog

    // Call external callback (if needed)
    state.widget.onCreateNewStack?.call();
  }
}

/// Display open stack dialog
Future<void> _showOpenStackDialog(
  _WelcomeDialogContentState state,
  BuildContext context,
) async {
  try {
    // Select file or directory
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      dialogTitle: 'Select stack file (.rinne_graph_desktop) or stack folder',
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (file.path != null) {
        // TODO: Implement stack opening process
        debugPrint('Selected stack path: ${file.path}');

        // Close welcome dialog
        if (context.mounted) {
          Navigator.of(context).pop();
        }

        // Call external callback
        state.widget.onOpenStack?.call();
      }
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

/// Handle stack actions
void _handleStackAction(
  _WelcomeDialogContentState state,
  StackData stackData,
  String action,
) {
  debugPrint('Stack action: $action for ${stackData.name}');

  // For sample stack templates
  if (stackData is StackTemplateWrapper) {
    switch (action) {
      case 'install':
        _showInstallConfirmationDialog(state, stackData.templateManifest);
        break;
      default:
        debugPrint('Unknown template action: $action');
    }
    return;
  }

  // Get original stack from CoreStackWrapper and check archive status
  if (stackData is CoreStackWrapper) {
    final originalStack = stackData.originalStack;
    final isArchived = _isStackArchived(state, originalStack);

    switch (action) {
      case 'open':
        // Execute same process as double tap
        debugPrint('Opening stack from menu: ${originalStack.info.name}');
        debugPrint('Stack path: ${originalStack.directory.path}');
        if (state.widget.onStackSelected != null) {
          debugPrint('Calling onStackSelected callback');
          state.widget.onStackSelected?.call(originalStack);
        } else {
          debugPrint('onStackSelected callback is null');
        }
        break;
      case 'info':
        _showStackInfoDialog(state, originalStack);
        break;
      case 'show_in_finder':
        _showStackInFinder(state, originalStack);
        break;
      case 'archive':
        if (isArchived) {
          // For archived stacks, restore
          _restoreStack(state, stackData);
        } else {
          // For active stacks, show confirmation dialog before archiving
          _showArchiveConfirmationDialog(state, stackData);
        }
        break;
      case 'restore':
        _restoreStack(state, stackData);
        break;
      default:
        debugPrint('Unknown stack action: $action');
    }
  }
}

/// Display stack info dialog
void _showStackInfoDialog(
  _WelcomeDialogContentState state,
  core_stack.Stack stack,
) {
  showStackInfoDialog(
    context: state.context,
    stack: stack,
    onStackNameChanged: (newName) {
      // Handle stack name change
      // TODO: Implement stack name update process
      debugPrint('Stack name changed to: $newName');
    },
  );
}

/// Show stack in Finder
void _showStackInFinder(
  _WelcomeDialogContentState state,
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
        if (state.context.mounted) {
          AppSnackBar.showError(
            context: state.context,
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
        if (state.context.mounted) {
          AppSnackBar.showError(
            context: state.context,
            message: 'Failed to open folder in file manager',
          );
        }
      }
    }
  } catch (e) {
    debugPrint('Error opening stack in file manager: $e');
    if (state.context.mounted) {
      AppSnackBar.showError(
        context: state.context,
        message: 'Error opening folder: $e',
      );
    }
  }
}

/// Display archive confirmation dialog
void _showArchiveConfirmationDialog(
  _WelcomeDialogContentState state,
  StackData stackData,
) {
  showDialog<bool>(
    context: state.context,
    builder: (BuildContext context) {
      final colorScheme = state.ref.read(effectiveColorSchemeProvider);

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
            _buildWarningItem(
              state,
              'Archived stacks will not appear in your stack collection.',
              colorScheme,
            ),
            AppSpacing.sm(),
            _buildWarningItem(
              state,
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
      _archiveStack(state, stackData);
    }
  });
}

/// Archive stack
void _archiveStack(
  _WelcomeDialogContentState state,
  StackData stackData,
) async {
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

      await _saveStackSettings(state, originalStack, updatedSettings);
      debugPrint('Archived stack: ${originalStack.info.name}');

      // Update stack list
      state.ref.read(core_stack.stackActionsProvider.notifier).triggerRefresh();
    }
  } catch (e) {
    debugPrint('Error archiving stack: $e');
  }
}

/// Restore stack (unarchive)
void _restoreStack(
  _WelcomeDialogContentState state,
  StackData stackData,
) async {
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

      await _saveStackSettings(state, originalStack, updatedSettings);
      debugPrint('Restored stack: ${originalStack.info.name}');

      // Update stack list
      state.ref.read(core_stack.stackActionsProvider.notifier).triggerRefresh();
    }
  } catch (e) {
    debugPrint('Error restoring stack: $e');
  }
}

/// Save stack settings to file
Future<void> _saveStackSettings(
  _WelcomeDialogContentState state,
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

/// Determine stack archive status
bool _isStackArchived(
  _WelcomeDialogContentState state,
  core_stack.Stack stack,
) {
  return stack.isArchived;
}
