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
import 'package:core_stack_common/src/service/stack_metadata_service.dart';
import 'package:features_welcome/src/widgets/welcome_models.dart';

import 'package:features_welcome/src/providers/welcome_providers.dart';
import 'package:features_welcome/src/services/debug_stack_operations.dart';
import 'package:features_welcome/src/widgets/import_dialog.dart';
import 'package:features_welcome/src/widgets/stack_info_dialog.dart';

import 'package:file_picker/file_picker.dart';

/// Content for the welcome screen, displayed when no stack is active.
class WelcomeScreenContent extends ConsumerStatefulWidget {
  final VoidCallback? onCreateNewStack;
  final VoidCallback? onOpenStack;
  final VoidCallback? onImportStack;
  final ValueChanged<core_stack.Stack>? onStackSelected;
  final VoidCallback? onGoToMainScreen;

  const WelcomeScreenContent({
    this.onCreateNewStack,
    this.onOpenStack,
    this.onImportStack,
    this.onStackSelected,
    this.onGoToMainScreen,
    super.key,
  });

  @override
  ConsumerState<WelcomeScreenContent> createState() =>
      _WelcomeScreenContentState();
}

class _WelcomeScreenContentState extends ConsumerState<WelcomeScreenContent> {
  @override
  Widget build(BuildContext context) {
    final stacksAsync = ref.watch(allAvailableStacksProvider);
    final selectedStack = ref.watch(selectedWelcomeStackProvider);
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    final textColor = appColorScheme.uiAreas.sideBar.activeItemText;
    final subTextColor = appColorScheme.uiAreas.sideBar.inactiveItemText;

    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: _buildVersionInfo(appColorScheme),
                  ),
                  const SizedBox(height: 16),
                  _buildHeader(textColor, subTextColor),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 32.0),
                        child: _buildActionButtons(context, appColorScheme),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          _buildGridHeader(context, appColorScheme),
                          Expanded(
                            child: _buildStackGrid(stacksAsync, selectedStack),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build header section
  Widget _buildHeader(Color textColor, Color subTextColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Welcome to RinneGraph',
            variant: AppTextVariant.textHeading1,
            color: textColor,
          ),
          const SizedBox(height: 12),
          AppText(
            'Everything is linked',
            variant: AppTextVariant.textHeading4,
            color: textColor,
          ),
        ],
      ),
    );
  }

  /// Build grid header (action buttons)
  Widget _buildGridHeader(BuildContext context, AppColorScheme colorScheme) {
    final displayMode = ref.watch(stackDisplayModeProvider);

    return Padding(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 0.0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Display mode display
          AppText(
            _getDisplayModeTitle(displayMode),
            variant: AppTextVariant.bodyText,
            color: colorScheme.base.foreground,
          ),

          // Right side: Action buttons
          Row(
            children: [
              // Create new stack
              AppIconButton(
                onPressed: () => _showNewStackCreationDialog(context),
                icon: AppIcons.plus,
                iconSize: 24,
                tooltip: 'Create new stack',
              ),
              const SizedBox(width: 8),

              // Open
              AppIconButton(
                onPressed: () => _showOpenStackDialog(context),
                icon: Icons.folder_open,
                iconSize: 24,
                tooltip: 'Open stack',
              ),
              const SizedBox(width: 8),

              // Action menu (display mode switching, import, sample stacks)
              AppPopupMenu<String>.circleActionButton(
                icon: AppIcons.ellipsis,
                iconSize: 20,
                size: 32,
                backgroundColor: Colors.transparent,
                hoverColor: colorScheme.interactive.actionButton.background,
                tooltip: 'Actions',
                items: [
                  // When displaying sample stack templates, show only "display mode switch" not "add"
                  if (displayMode != StackDisplayModeType.sampleTemplate) ...[
                    AppPopupMenuItemEntry<String>(
                      AppPopupMenuItem<String>(
                        value: 'import',
                        title: 'Import data',
                        icon: AppIcons.import,
                        onSelected: () {
                          // Display import dialog directly
                          showImportDialog(context);
                        },
                      ),
                    ),
                    const AppPopupMenuDividerEntry<String>(),
                  ],
                  // Display mode switching menu
                  AppPopupMenuItemEntry<String>(
                    AppPopupMenuItem<String>(
                      value: 'show_active',
                      title: 'Active stacks',
                      icon: Icons.folder_outlined,
                      onSelected: () {
                        ref.read(stackDisplayModeProvider.notifier).state =
                            StackDisplayModeType.active;
                      },
                    ),
                  ),
                  AppPopupMenuItemEntry<String>(
                    AppPopupMenuItem<String>(
                      value: 'show_archived',
                      title: 'Archived',
                      icon: Icons.archive_outlined,
                      onSelected: () {
                        ref.read(stackDisplayModeProvider.notifier).state =
                            StackDisplayModeType.archived;
                      },
                    ),
                  ),
                  AppPopupMenuItemEntry<String>(
                    AppPopupMenuItem<String>(
                      value: 'show_templates',
                      title: 'Sample templates',
                      icon: AppIcons.stacks,
                      onSelected: () {
                        ref.read(stackDisplayModeProvider.notifier).state =
                            StackDisplayModeType.sampleTemplate;
                      },
                    ),
                  ),
                  // Add debug menu
                  if (_isDebugMode()) ...[
                    const AppPopupMenuDividerEntry<String>(),
                    AppPopupMenuItemEntry<String>(
                      AppPopupMenuItem<String>(
                        value: 'debug_archive_all',
                        title: '[DEBUG] Archive all stacks',
                        icon: Icons.archive_outlined,
                        onSelected: () {
                          _showDebugArchiveAllConfirmation(context);
                        },
                      ),
                    ),
                    AppPopupMenuItemEntry<String>(
                      AppPopupMenuItem<String>(
                        value: 'debug_delete_all',
                        title: '[DEBUG] Delete all stacks',
                        icon: Icons.delete_forever_outlined,
                        onSelected: () {
                          _showDebugDeleteAllConfirmation(context);
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build stack grid using StackGrid (with pagination)
  Widget _buildStackGrid(
    AsyncValue<List<core_stack.Stack>> stacksAsync,
    core_stack.Stack? selectedStack,
  ) {
    return switch (stacksAsync) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError(:final error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(AppIcons.info, size: 48),
            const SizedBox(height: 16),
            AppText('Error: $error', variant: AppTextVariant.bodyText),
          ],
        ),
      ),
      AsyncData(:final value) => _buildStackGridWithData(value, selectedStack),
      _ => const Center(child: Text('Unknown state')),
    };
  }

  Widget _buildActionButtons(BuildContext context, AppColorScheme colorScheme) {
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
          onPressed: () => _showNewStackCreationDialog(context),
        ),
        const SizedBox(height: 16),
        AppButton.normal(
          label: 'Open Existing Stack...',
          onPressed: () => _showOpenStackDialog(context),
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

  /// Build stack grid using actual stack data
  Widget _buildStackGridWithData(
    List<core_stack.Stack> realStacks,
    core_stack.Stack? selectedStack,
  ) {
    final displayMode = ref.watch(stackDisplayModeProvider);

    List<StackData> stackDataList;

    switch (displayMode) {
      case StackDisplayModeType.archived:
        // Display only archived stacks
        final archivedStacks =
            realStacks.where((stack) => _isStackArchived(stack)).toList();
        stackDataList =
            archivedStacks
                .map<StackData>((stack) => CoreStackWrapper(stack))
                .toList();
        break;
      case StackDisplayModeType.sampleTemplate:
        // Display only sample stack templates
        final sampleManifests = ref.watch(stackTemplateManifestsProvider);
        stackDataList =
            sampleManifests
                .map<StackData>((manifest) => StackTemplateWrapper(manifest))
                .toList();
        break;
      case StackDisplayModeType.active:
        // Display only active stacks
        final activeStacks =
            realStacks.where((stack) => !_isStackArchived(stack)).toList();
        debugPrint(
          '[WelcomeScreenContent] Active stacks display: showing ${activeStacks.length} out of ${realStacks.length} total',
        );
        for (final stack in realStacks) {
          debugPrint(
            '[WelcomeScreenContent] Stack "${stack.info.name}": archived=${_isStackArchived(stack)}',
          );
        }
        stackDataList =
            activeStacks
                .map<StackData>((stack) => CoreStackWrapper(stack))
                .toList();
        break;
      default: // Added default case for exhaustive switch
        stackDataList = [];
    }

    return AppStackGrid(
      stacks: stackDataList,
      gridColumns: 3,
      gridRows: 2,
      gridPadding: EdgeInsets.zero,
      crossAxisSpacing: 20.0,
      mainAxisSpacing: 16.0,
      itemWidth: 160.0,
      itemHeight: 160.0,
      selectedStack:
          selectedStack != null ? CoreStackWrapper(selectedStack) : null,
      onStackSelected: (stackData) {
        // Skip selection state management for sample stack templates
        if (stackData is StackTemplateWrapper) {
          return;
        }

        final coreStackWrapper = stackData as CoreStackWrapper;
        final stack = coreStackWrapper.originalStack;

        // Toggle selection state
        if (selectedStack == stack) {
          ref.read(selectedWelcomeStackProvider.notifier).clearSelection();
        } else {
          ref.read(selectedWelcomeStackProvider.notifier).selectStack(stack);
        }
      },
      onStackDoubleClicked: (stackData) {
        // For sample stack templates, display installation confirmation dialog
        if (stackData is StackTemplateWrapper) {
          _showInstallConfirmationDialog(stackData.templateManifest);
          return;
        }

        // For normal stacks
        final coreStackWrapper = stackData as CoreStackWrapper;
        final stack = coreStackWrapper.originalStack;

        // On double click, load stack and transition to graph navigation screen
        debugPrint('Loading stack from double tap: ${stack.info.name}');
        debugPrint('Stack path: ${stack.directory.path}');

        if (widget.onStackSelected != null) {
          // Execute stack selection (error handling is done by caller)
          debugPrint('Calling onStackSelected callback from double tap');
          widget.onStackSelected?.call(stack);
        } else {
          debugPrint('onStackSelected callback is null');
        }
      },
      onStackAction: (stackData, action) {
        _handleStackAction(stackData, action);
      },
      customActionItems: (stackData) {
        // For sample stack templates, return dedicated action menu
        if (stackData is StackTemplateWrapper) {
          return [
            AppPopupMenuItemEntry<String>(
              AppPopupMenuItem<String>(
                value: 'install',
                title: 'Install',
                icon: Icons.download_outlined,
                onSelected: () => _handleStackAction(stackData, 'install'),
              ),
            ),
          ];
        }

        // Get original stack from CoreStackWrapper and check archive status
        if (stackData is CoreStackWrapper) {
          final originalStack = stackData.originalStack;
          final isArchived = _isStackArchived(originalStack);

          return [
            AppPopupMenuItemEntry<String>(
              AppPopupMenuItem<String>(
                value: 'open',
                title: 'Open',
                icon: AppIcons.folderOpen,
                onSelected: () => _handleStackAction(stackData, 'open'),
              ),
            ),
            AppPopupMenuItemEntry<String>(
              AppPopupMenuItem<String>(
                value: 'info',
                title: 'View info',
                icon: AppIcons.info,
                onSelected: () => _handleStackAction(stackData, 'info'),
              ),
            ),
            AppPopupMenuItemEntry<String>(
              AppPopupMenuItem<String>(
                value: 'show_in_finder',
                title: 'Show in Finder',
                icon: AppIcons.folder,
                onSelected:
                    () => _handleStackAction(stackData, 'show_in_finder'),
              ),
            ),
            AppPopupMenuItemEntry<String>(
              AppPopupMenuItem<String>(
                value: 'archive',
                title: isArchived ? 'Restore' : 'Archive',
                icon:
                    isArchived
                        ? Icons.unarchive_outlined
                        : Icons.archive_outlined,
                onSelected: () => _handleStackAction(stackData, 'archive'),
              ),
            ),
          ];
        }

        // Default action menu
        return [
          AppPopupMenuItemEntry<String>(
            AppPopupMenuItem<String>(
              value: 'open',
              title: 'Open',
              icon: AppIcons.folderOpen,
              onSelected: () => _handleStackAction(stackData, 'open'),
            ),
          ),
          AppPopupMenuItemEntry<String>(
            AppPopupMenuItem<String>(
              value: 'info',
              title: 'View info',
              icon: AppIcons.info,
              onSelected: () => _handleStackAction(stackData, 'info'),
            ),
          ),
          AppPopupMenuItemEntry<String>(
            AppPopupMenuItem<String>(
              value: 'show_in_finder',
              title: 'Show in Finder',
              icon: AppIcons.folder,
              onSelected: () => _handleStackAction(stackData, 'show_in_finder'),
            ),
          ),
          AppPopupMenuItemEntry<String>(
            AppPopupMenuItem<String>(
              value: 'archive',
              title: 'Archive',
              icon: Icons.archive_outlined,
              onSelected: () => _handleStackAction(stackData, 'archive'),
            ),
          ),
        ];
      },
      showNavigationButtons: true, // Display arrow navigation
      showPageIndicator: true, // Display page indicator
    );
  }

  /// Display new stack creation dialog
  Future<void> _showNewStackCreationDialog(BuildContext context) async {
    final createdStack = await StackManagementService.createNewStack(context);

    if (createdStack != null && context.mounted) {
      // Open created stack and transition to graph navigation screen
      // Execute stack selection (error handling is done by caller)
      widget.onStackSelected?.call(createdStack);

      // Call external callback (if needed)
      widget.onCreateNewStack?.call();
    }
  }

  /// Display open stack dialog
  Future<void> _showOpenStackDialog(BuildContext context) async {
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

            widget.onStackSelected?.call(stack);
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
        widget.onOpenStack?.call(); // Original callback if needed
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
  void _handleStackAction(StackData stackData, String action) {
    debugPrint('Stack action: $action for ${stackData.name}');

    // For sample stack templates
    if (stackData is StackTemplateWrapper) {
      switch (action) {
        case 'install':
          _showInstallConfirmationDialog(stackData.templateManifest);
          break;
        default:
          debugPrint('Unknown template action: $action');
      }
      return;
    }

    // Get original stack from CoreStackWrapper and check archive status
    if (stackData is CoreStackWrapper) {
      final originalStack = stackData.originalStack;
      final isArchived = _isStackArchived(originalStack);

      switch (action) {
        case 'open':
          // Execute same process as double tap
          debugPrint('Opening stack from menu: ${originalStack.info.name}');
          debugPrint('Stack path: ${originalStack.directory.path}');
          if (widget.onStackSelected != null) {
            debugPrint('Calling onStackSelected callback');
            widget.onStackSelected?.call(originalStack);
          } else {
            debugPrint('onStackSelected callback is null');
          }
          break;
        case 'info':
          _showStackInfoDialog(originalStack);
          break;
        case 'show_in_finder':
          _showStackInFinder(originalStack);
          break;
        case 'archive':
          if (isArchived) {
            // For archived stacks, restore
            _restoreStack(stackData);
          } else {
            // For active stacks, show confirmation dialog before archiving
            _showArchiveConfirmationDialog(stackData);
          }
          break;
        case 'restore':
          _restoreStack(stackData);
          break;
        default:
          debugPrint('Unknown stack action: $action');
      }
    }
  }

  /// Display stack info dialog
  void _showStackInfoDialog(core_stack.Stack stack) {
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
  void _showStackInFinder(core_stack.Stack stack) async {
    try {
      final stackDirectory = stack.directory.parent;

      if (Platform.isMacOS) {
        // For macOS, use `open` command
        final result = await Process.run('open', [stackDirectory.path]);
        if (result.exitCode == 0) {
          debugPrint(
            'Opened stack directory in Finder: ${stackDirectory.path}',
          );
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
  void _showArchiveConfirmationDialog(StackData stackData) {
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
              _buildWarningItem(
                'Archived stacks will not appear in your stack collection.',
                colorScheme,
              ),
              AppSpacing.sm(),
              _buildWarningItem(
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
        _archiveStack(stackData);
      }
    });
  }

  /// Build warning item
  Widget _buildWarningItem(String text, AppColorScheme colorScheme) {
    return AppText(
      text,
      variant: AppTextVariant.bodyText,
      color: colorScheme.base.foreground.withValues(alpha: 0.8),
    );
  }

  /// Archive stack
  void _archiveStack(StackData stackData) async {
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

        await _saveStackSettings(originalStack, updatedSettings);
        debugPrint('Archived stack: ${originalStack.info.name}');

        // Update stack list
        ref.read(core_stack.stackActionsProvider.notifier).triggerRefresh();
      }
    } catch (e) {
      debugPrint('Error archiving stack: $e');
    }
  }

  /// Restore stack (unarchive)
  void _restoreStack(StackData stackData) async {
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

        await _saveStackSettings(originalStack, updatedSettings);
        debugPrint('Restored stack: ${originalStack.info.name}');

        // Update stack list
        ref.read(core_stack.stackActionsProvider.notifier).triggerRefresh();
      }
    } catch (e) {
      debugPrint('Error restoring stack: $e');
    }
  }

  /// Save stack settings to file
  Future<void> _saveStackSettings(
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
  bool _isStackArchived(core_stack.Stack stack) {
    return stack.isArchived;
  }

  /// Get display mode title
  String _getDisplayModeTitle(StackDisplayModeType displayMode) {
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

  /// Display stack template installation confirmation dialog
  void _showInstallConfirmationDialog(StackTemplateManifest manifest) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);

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
          _buildWarningItem('A new stack will be created.', colorScheme),
          AppSpacing.sm(),
          _buildWarningItem(
            'After installation, it will appear in your active stacks list.',
            colorScheme,
          ),
        ],
      ),
      footer: _buildDialogFooter(
        colorScheme: colorScheme,
        cancelLabel: 'Cancel',
        confirmLabel: 'Install',
        onCancel: () => Navigator.of(context).pop(false),
        onConfirm: () => Navigator.of(context).pop(true),
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        _installSampleStackTemplate(manifest);
      }
    });
  }

  /// Display installation success dialog
  void _showInstallationSuccessDialog(StackTemplateManifest manifest) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);

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
      footer: _buildDialogFooter(
        colorScheme: colorScheme,
        confirmLabel: 'OK',
        onConfirm: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Build dialog footer with optional cancel and confirm buttons
  Widget _buildDialogFooter({
    required AppColorScheme colorScheme,
    String? cancelLabel,
    String? confirmLabel,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.base.border, width: 1),
        ),
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
                  : AppButton.primary(
                    label: confirmLabel,
                    onPressed: onConfirm,
                  ),
          ],
        ),
      ),
    );
  }

  /// Install sample stack template
  Future<void> _installSampleStackTemplate(
    StackTemplateManifest manifest,
  ) async {
    try {
      debugPrint(
        '[WelcomeScreenContent] Starting installation of sample stack "${manifest.displayName}"',
      );
      final stackActions = ref.read(core_stack.stackActionsProvider.notifier);
      final success = await stackActions.createSampleStackFromManifest(
        manifest,
      );
      debugPrint('[WelcomeScreenContent] Installation result: $success');

      if (mounted) {
        if (success) {
          debugPrint('[WelcomeScreenContent] Triggering stack list update');
          // Explicitly update stack list
          ref.read(core_stack.stackActionsProvider.notifier).triggerRefresh();

          debugPrint(
            '[WelcomeScreenContent] Switching to active stacks display',
          );
          // On success, switch to active stacks display
          ref.read(stackDisplayModeProvider.notifier).state =
              StackDisplayModeType.active;

          // Display installation success dialog
          _showInstallationSuccessDialog(manifest);

          // Find the newly installed stack and activate it
          final allStacks = ref.read(allAvailableStacksProvider).value;
          final newlyInstalledStack = allStacks?.firstWhere(
            (s) =>
                s.info.name ==
                manifest.displayName, // Assuming unique display name
            orElse: () => throw StateError('Newly installed stack not found'),
          );

          if (newlyInstalledStack != null) {
            widget.onStackSelected?.call(newlyInstalledStack);
          }
        } else {
          // Display error message
          AppSnackBar.showError(
            context: context,
            message: 'Failed to install sample stack',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(
          context: context,
          message: 'An error occurred: $e',
        );
      }
    }
  }

  /// Determine if debug mode is enabled
  bool _isDebugMode() {
    try {
      final debugMode = ref.watch(debugModeProvider);
      return debugMode;
    } catch (e) {
      // Return false if provider is not available
      return false;
    }
  }

  /// Debug: Confirmation dialog to archive all stacks
  void _showDebugArchiveAllConfirmation(BuildContext context) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);

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
                'This operation will archive all active stacks.',
                colorScheme,
              ),
              AppSpacing.sm(),
              _buildWarningItem('Use for debug purposes only.', colorScheme),
              AppSpacing.sm(),
              _buildWarningItem(
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
        _executeDebugArchiveAll();
      }
    });
  }

  /// Debug: Confirmation dialog to delete all stacks
  void _showDebugDeleteAllConfirmation(BuildContext context) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);

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
                '⚠️ This operation will permanently delete all stacks.',
                colorScheme,
              ),
              AppSpacing.sm(),
              _buildWarningItem(
                '⚠️ This operation cannot be undone.',
                colorScheme,
              ),
              AppSpacing.sm(),
              _buildWarningItem('Use for debug purposes only.', colorScheme),
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
        _executeDebugDeleteAll();
      }
    });
  }

  /// Debug: Execute archive all stacks operation
  Future<void> _executeDebugArchiveAll() async {
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
  Future<void> _executeDebugDeleteAll() async {
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
  Widget _buildVersionInfo(AppColorScheme colorScheme) {
    final displayVersionAsync = ref.watch(displayVersionStringProvider);

    return displayVersionAsync.when(
      data:
          (version) => AppText(
            version,
            variant: AppTextVariant.bodyText,
            color: colorScheme.base.foreground.withAlpha(179),
          ),
      loading:
          () => AppText(
            'Loading...',
            variant: AppTextVariant.bodyText,
            color: colorScheme.base.foreground.withAlpha(179),
          ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}
