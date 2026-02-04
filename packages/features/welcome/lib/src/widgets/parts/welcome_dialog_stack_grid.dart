part of '../welcome_dialog_content.dart';

/// Build stack grid using StackGrid (with pagination)
Widget _buildStackGrid(
  _WelcomeDialogContentState state,
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
    AsyncData(:final value) => _buildStackGridWithData(
      state,
      value,
      selectedStack,
    ),
    _ => const Center(child: Text('Unknown state')),
  };
}

/// Build stack grid using actual stack data
Widget _buildStackGridWithData(
  _WelcomeDialogContentState state,
  List<core_stack.Stack> realStacks,
  core_stack.Stack? selectedStack,
) {
  final displayMode = state.ref.watch(stackDisplayModeProvider);

  List<StackData> stackDataList;

  switch (displayMode) {
    case StackDisplayModeType.archived:
      // Display only archived stacks
      final archivedStacks =
          realStacks.where((stack) => _isStackArchived(state, stack)).toList();
      stackDataList =
          archivedStacks.map((stack) => CoreStackWrapper(stack)).toList();
      break;
    case StackDisplayModeType.sampleTemplate:
      // Display only sample stack templates
      final sampleManifests = state.ref.watch(stackTemplateManifestsProvider);
      stackDataList =
          sampleManifests
              .map((manifest) => StackTemplateWrapper(manifest))
              .toList();
      break;
    case StackDisplayModeType.active:
      // Display only active stacks
      final activeStacks =
          realStacks.where((stack) => !_isStackArchived(state, stack)).toList();
      debugPrint(
        '[WelcomeDialog] Active stacks display: showing ${activeStacks.length} out of ${realStacks.length} total',
      );
      for (final stack in realStacks) {
        debugPrint(
          '[WelcomeDialog] Stack "${stack.info.name}": archived=${_isStackArchived(state, stack)}',
        );
      }
      stackDataList =
          activeStacks.map((stack) => CoreStackWrapper(stack)).toList();
      break;
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
        state.ref.read(selectedWelcomeStackProvider.notifier).clearSelection();
      } else {
        state.ref
            .read(selectedWelcomeStackProvider.notifier)
            .selectStack(stack);
      }
    },
    onStackDoubleClicked: (stackData) {
      // For sample stack templates, display installation confirmation dialog
      if (stackData is StackTemplateWrapper) {
        _showInstallConfirmationDialog(state, stackData.templateManifest);
        return;
      }

      // For normal stacks
      final coreStackWrapper = stackData as CoreStackWrapper;
      final stack = coreStackWrapper.originalStack;

      // On double click, load stack and transition to graph navigation screen
      debugPrint('Loading stack from double tap: ${stack.info.name}');
      debugPrint('Stack path: ${stack.directory.path}');

      if (state.widget.onStackSelected != null) {
        // Execute stack selection (error handling is done by caller)
        debugPrint('Calling onStackSelected callback from double tap');
        state.widget.onStackSelected?.call(stack);

        // Whether to close dialog is delegated to onStackSelected implementation
        // If error occurs, caller controls to not close dialog
      } else {
        debugPrint('onStackSelected callback is null');
      }
    },
    onStackAction: (stackData, action) {
      _handleStackAction(state, stackData, action);
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
              onSelected: () => _handleStackAction(state, stackData, 'install'),
            ),
          ),
        ];
      }

      // Get original stack from CoreStackWrapper and check archive status
      if (stackData is CoreStackWrapper) {
        final originalStack = stackData.originalStack;
        final isArchived = _isStackArchived(state, originalStack);

        return [
          AppPopupMenuItemEntry<String>(
            AppPopupMenuItem<String>(
              value: 'open',
              title: 'Open',
              icon: AppIcons.folderOpen,
              onSelected: () => _handleStackAction(state, stackData, 'open'),
            ),
          ),
          AppPopupMenuItemEntry<String>(
            AppPopupMenuItem<String>(
              value: 'info',
              title: 'View info',
              icon: AppIcons.info,
              onSelected: () => _handleStackAction(state, stackData, 'info'),
            ),
          ),
          AppPopupMenuItemEntry<String>(
            AppPopupMenuItem<String>(
              value: 'show_in_finder',
              title: 'Show in Finder',
              icon: AppIcons.folder,
              onSelected:
                  () => _handleStackAction(state, stackData, 'show_in_finder'),
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
              onSelected: () => _handleStackAction(state, stackData, 'archive'),
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
            onSelected: () => _handleStackAction(state, stackData, 'open'),
          ),
        ),
        AppPopupMenuItemEntry<String>(
          AppPopupMenuItem<String>(
            value: 'info',
            title: 'View info',
            icon: AppIcons.info,
            onSelected: () => _handleStackAction(state, stackData, 'info'),
          ),
        ),
        AppPopupMenuItemEntry<String>(
          AppPopupMenuItem<String>(
            value: 'show_in_finder',
            title: 'Show in Finder',
            icon: AppIcons.folder,
            onSelected:
                () => _handleStackAction(state, stackData, 'show_in_finder'),
          ),
        ),
        AppPopupMenuItemEntry<String>(
          AppPopupMenuItem<String>(
            value: 'archive',
            title: 'Archive',
            icon: Icons.archive_outlined,
            onSelected: () => _handleStackAction(state, stackData, 'archive'),
          ),
        ),
      ];
    },
    showNavigationButtons: true, // Display arrow navigation
    showPageIndicator: true, // Display page indicator
  );
}
