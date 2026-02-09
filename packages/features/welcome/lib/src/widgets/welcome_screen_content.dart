import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:core_themes/core_themes.dart';
import 'package:features_welcome/src/providers/welcome_providers.dart';
import 'package:features_welcome/src/widgets/welcome_models.dart';
import 'package:core_stack_flutter/core_stack.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_samples/core_samples.dart';

import '../widgets/welcome_screen_header.dart';
import '../widgets/welcome_screen_action_buttons.dart';
import '../widgets/welcome_screen_grid_header.dart';
import '../widgets/welcome_screen_stack_grid.dart';
import '../widgets/welcome_screen_dialogs.dart';
import '../widgets/welcome_screen_helpers.dart';

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
    final stacksAsync = ref.watch(core_stack.allStacksListProvider);
    final selectedStack = ref.watch(selectedWelcomeStackProvider);

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
                children: [const WelcomeScreenHeader()],
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
                        child: WelcomeScreenActionButtons(
                          onCreateNewStack: widget.onCreateNewStack,
                          onOpenStack: widget.onOpenStack,
                          onStackSelected: widget.onStackSelected,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: () {
                        final hasUserStacks = stacksAsync.maybeWhen(
                          data: (stacks) => stacks.isNotEmpty,
                          orElse: () => true,
                        );
                        final initialTabId =
                            hasUserStacks ? 'my_stacks' : 'samples';
                        return AppTabView(
                          key: ValueKey('welcome_tab_$initialTabId'),
                          initialSelectedTabId: initialTabId,
                          tabs: const [
                            AppTab(id: 'my_stacks', label: 'My Stacks'),
                            AppTab(id: 'samples', label: 'Samples'),
                          ],
                        contents: [
                          AppTabContent(
                            id: 'my_stacks',
                            content: Column(
                              children: [
                                const WelcomeScreenGridHeader(),
                                Expanded(
                                  child: WelcomeScreenStackGrid(
                                    stacksAsync: stacksAsync,
                                    selectedStack: selectedStack,
                                    onStackSelected: (stack) {
                                      // Toggle selection state
                                      if (selectedStack == stack) {
                                        ref
                                            .read(
                                              selectedWelcomeStackProvider
                                                  .notifier,
                                            )
                                            .clearSelection();
                                      } else {
                                        ref
                                            .read(
                                              selectedWelcomeStackProvider
                                                  .notifier,
                                            )
                                            .selectStack(stack);
                                      }
                                    },
                                    onStackDoubleClicked:
                                        _onStackDoubleClicked,
                                    onStackAction: _handleStackAction,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppTabContent(
                            id: 'samples',
                            content: Consumer(
                              builder: (context, ref, _) {
                                final sampleStacksAsync =
                                    ref.watch(assetStackTemplatesProvider);
                                return Column(
                                  children: [
                                    const WelcomeScreenGridHeader(), // Can be adjusted if needed
                                    Expanded(
                                      child: WelcomeScreenStackGrid(
                                        stacksAsync:
                                            sampleStacksAsync, // Pass sample stacks
                                        selectedStack:
                                            selectedStack, // Share selection state
                                        onStackSelected: (stack) {
                                          if (selectedStack == stack) {
                                            ref
                                                .read(
                                                  selectedWelcomeStackProvider
                                                      .notifier,
                                                )
                                                .clearSelection();
                                          } else {
                                            ref
                                                .read(
                                                  selectedWelcomeStackProvider
                                                      .notifier,
                                                )
                                                .selectStack(stack);
                                          }
                                        },
                                        onStackDoubleClicked:
                                            _onStackDoubleClicked,
                                        onStackAction: _handleStackAction,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                        );
                      }(),
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

  /// Handle stack actions
  void _handleStackAction(dynamic stackData, String action) {
    debugPrint('Stack action: $action for ${stackData.name}');

    // For sample stack templates
    if (stackData is StackTemplateWrapper) {
      switch (action) {
        case 'install':
          showInstallConfirmationDialogHelper(
            context,
            ref,
            stackData.templateManifest,
            _installSampleStackTemplate,
          );
          break;
        default:
          debugPrint('Unknown template action: $action');
      }
      return;
    }

    // Get original stack from CoreStackWrapper and check archive status
    if (stackData is CoreStackWrapper) {
      final originalStack = stackData.originalStack;
      final isArchived = isStackArchivedHelper(originalStack);

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
          showStackInfoDialogHelper(context, originalStack);
          break;
        case 'show_in_finder':
          showStackInFinderHelper(context, originalStack);
          break;
        case 'archive':
          if (isArchived) {
            // For archived stacks, restore
            restoreStackHelper(ref, stackData);
          } else {
            // For active stacks, show confirmation dialog before archiving
            showArchiveConfirmationDialogHelper(
              context,
              ref,
              stackData,
              archiveStackHelper,
            );
          }
          break;
        case 'restore':
          restoreStackHelper(ref, stackData);
          break;
        default:
          debugPrint('Unknown stack action: $action');
      }
    }
  }

  void _onStackDoubleClicked(dynamic stackData) {
    // For sample stack templates, display installation confirmation dialog
    if (stackData is StackTemplateWrapper) {
      showInstallConfirmationDialogHelper(
        context,
        ref,
        stackData.templateManifest,
        _installSampleStackTemplate,
      );
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
  }

  /// Install sample stack template
  Future<void> _installSampleStackTemplate(dynamic manifest) async {
    await installSampleStackTemplateHelper(context, ref, manifest);

    // Find the newly installed stack and activate it
    final allStacks = ref.read(core_stack.allStacksListProvider).value;
    final newlyInstalledStack = allStacks?.firstWhere(
      (s) =>
          s.info.name == manifest.displayName, // Assuming unique display name
      orElse: () => throw StateError('Newly installed stack not found'),
    );

    if (newlyInstalledStack != null) {
      widget.onStackSelected?.call(newlyInstalledStack);
    }
  }
}
