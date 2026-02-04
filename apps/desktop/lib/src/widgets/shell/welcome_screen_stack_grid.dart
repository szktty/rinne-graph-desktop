import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:features_welcome/src/providers/welcome_providers.dart';
import 'package:core_samples/core_samples.dart';
import 'package:features_welcome/src/widgets/welcome_models.dart';

import 'package:desktop/src/widgets/shell/welcome_screen_helpers.dart';

/// Callback for when a stack action is performed.
typedef StackActionCallback = void Function(dynamic stackData, String action);

/// Stack grid section for the welcome screen.
class WelcomeScreenStackGrid extends ConsumerWidget {
  final AsyncValue<List<core_stack.Stack>> stacksAsync;
  final core_stack.Stack? selectedStack;
  final ValueChanged<core_stack.Stack>? onStackSelected;
  final ValueChanged<dynamic>? onStackDoubleClicked;
  final StackActionCallback onStackAction;

  const WelcomeScreenStackGrid({
    required this.stacksAsync,
    this.selectedStack,
    this.onStackSelected,
    this.onStackDoubleClicked,
    required this.onStackAction,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      AsyncData(:final value) => _buildStackGridWithData(
        context,
        ref,
        value,
        selectedStack,
      ),
      _ => const Center(child: Text('Unknown state')),
    };
  }

  /// Build stack grid using actual stack data
  Widget _buildStackGridWithData(
    BuildContext context,
    WidgetRef ref,
    List<core_stack.Stack> realStacks,
    core_stack.Stack? selectedStack,
  ) {
    final displayMode = ref.watch(stackDisplayModeProvider);

    List<dynamic> stackDataList;

    switch (displayMode) {
      case StackDisplayModeType.archived:
        // Display only archived stacks
        final archivedStacks =
            realStacks.where((stack) => isStackArchivedHelper(stack)).toList();
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
            realStacks.where((stack) => !isStackArchivedHelper(stack)).toList();
        debugPrint(
          '[WelcomeScreenContent] Active stacks display: showing ${activeStacks.length} out of ${realStacks.length} total',
        );
        for (final stack in realStacks) {
          debugPrint(
            '[WelcomeScreenContent] Stack "${stack.info.name}": archived=${isStackArchivedHelper(stack)}',
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
      stacks: stackDataList.map((e) => e as StackData).toList(),
      gridColumns: 3,
      gridRows: 2,
      gridPadding: EdgeInsets.zero,
      crossAxisSpacing: 20.0,
      mainAxisSpacing: 16.0,
      itemWidth: 160.0,
      itemHeight: 160.0,
      selectedStack:
          selectedStack != null ? CoreStackWrapper(selectedStack) : null,
      onStackSelected: (dynamic stackData) {
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
      onStackDoubleClicked: (dynamic stackData) {
        onStackDoubleClicked?.call(stackData);
      },
      onStackAction: (stackData, action) {
        onStackAction(stackData, action);
      },
      customActionItems: (dynamic stackData) {
        // For sample stack templates, return dedicated action menu
        if (stackData is StackTemplateWrapper) {
          return [
            AppPopupMenuItemEntry<String>(
              AppPopupMenuItem<String>(
                value: 'install',
                title: 'Install',
                icon: Icons.download_outlined,
                onSelected: () => onStackAction(stackData, 'install'),
              ),
            ),
          ];
        }

        // Get original stack from CoreStackWrapper and check archive status
        if (stackData is CoreStackWrapper) {
          final originalStack = stackData.originalStack;
          final isArchived = isStackArchivedHelper(originalStack);

          return [
            AppPopupMenuItemEntry<String>(
              AppPopupMenuItem<String>(
                value: 'open',
                title: 'Open',
                icon: AppIcons.folderOpen,
                onSelected: () => onStackAction(stackData, 'open'),
              ),
            ),
            AppPopupMenuItemEntry<String>(
              AppPopupMenuItem<String>(
                value: 'info',
                title: 'View info',
                icon: AppIcons.info,
                onSelected: () => onStackAction(stackData, 'info'),
              ),
            ),
            AppPopupMenuItemEntry<String>(
              AppPopupMenuItem<String>(
                value: 'show_in_finder',
                title: 'Show in Finder',
                icon: AppIcons.folder,
                onSelected: () => onStackAction(stackData, 'show_in_finder'),
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
                onSelected: () => onStackAction(stackData, 'archive'),
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
              onSelected: () => onStackAction(stackData, 'open'),
            ),
          ),
          AppPopupMenuItemEntry<String>(
            AppPopupMenuItem<String>(
              value: 'info',
              title: 'View info',
              icon: AppIcons.info,
              onSelected: () => onStackAction(stackData, 'info'),
            ),
          ),
          AppPopupMenuItemEntry<String>(
            AppPopupMenuItem<String>(
              value: 'show_in_finder',
              title: 'Show in Finder',
              icon: AppIcons.folder,
              onSelected: () => onStackAction(stackData, 'show_in_finder'),
            ),
          ),
          AppPopupMenuItemEntry<String>(
            AppPopupMenuItem<String>(
              value: 'archive',
              title: 'Archive',
              icon: Icons.archive_outlined,
              onSelected: () => onStackAction(stackData, 'archive'),
            ),
          ),
        ];
      },
      showNavigationButtons: true, // Display arrow navigation
      showPageIndicator: true, // Display page indicator
    );
  }
}
