/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;

import '../models/stack_data_impl.dart';
import 'package:features_stack_management/features_stack_management.dart';
import '../providers/target_selection_dialog_providers.dart';

/// Target selection dialog for import operations
void showTargetSelectionDialog(
  BuildContext context, {
  ValueChanged<core_stack.Stack>? onStackSelected,
  VoidCallback? onNewStackSelected,
}) {
  final container = ProviderScope.containerOf(context, listen: false);
  container.read(targetSelectionDialogShowingProvider.notifier).state = true;
  final future = showAppDialog(
    context: context,
    barrierDismissible: true,
    width: 800,
    height: 600,
    padding: const EdgeInsets.all(24),
    child: TargetSelectionDialogContent(
      onStackSelected: onStackSelected,
      onNewStackSelected: onNewStackSelected,
    ),
  );
  future.whenComplete(() {
    container.read(targetSelectionDialogShowingProvider.notifier).state = false;
  });
}

/// Target selection dialog content
class TargetSelectionDialogContent extends ConsumerStatefulWidget {
  final ValueChanged<core_stack.Stack>? onStackSelected;
  final VoidCallback? onNewStackSelected;

  const TargetSelectionDialogContent({
    super.key,
    this.onStackSelected,
    this.onNewStackSelected,
  });

  @override
  ConsumerState<TargetSelectionDialogContent> createState() =>
      _TargetSelectionDialogContentState();
}

class _TargetSelectionDialogContentState
    extends ConsumerState<TargetSelectionDialogContent> {
  core_stack.Stack? _selectedStack;

  @override
  void initState() {
    super.initState();
    // Inject UI test actions
    // Execute after the widget tree is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _installTestActions();
    });
  }

  void _installTestActions() {
    try {
      ref
          .read(targetSelectionDialogTestActionsProvider.notifier)
          .state = TargetSelectionDialogTestActions(
        selectIndex: (index) {
          final stacksAsync = ref.read(core_stack.availableStacksListProvider);
          stacksAsync.whenOrNull(
            data: (list) {
              if (index >= 0 && index < list.length) {
                if (mounted) {
                  setState(() {
                    _selectedStack = list[index];
                  });
                }
              }
            },
          );
        },
        confirm: () {
          if (_selectedStack != null) {
            _handleStackSelection(_selectedStack!);
          }
        },
        cancel: () {
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
      );
    } catch (e) {
      debugPrint('[TargetSelectionDialog] Error installing test actions: $e');
    }
  }

  @override
  void dispose() {
    // Clear UI test actions
    try {
      ref.read(targetSelectionDialogTestActionsProvider.notifier).state =
          const TargetSelectionDialogTestActions();
    } catch (e) {
      debugPrint('[TargetSelectionDialog] Error clearing test actions: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);
    final textColor = colorScheme.uiAreas.sideBar.activeItemText;
    final primaryColor = colorScheme.status.info;
    final stacksAsync = ref.watch(core_stack.availableStacksListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title
        AppText(
          'Select Import Destination',
          variant: AppTextVariant.pageTitle,
          color: textColor,
        ),
        const SizedBox(height: 8),
        AppText(
          'Select a stack to import data into or create a new stack',
          variant: AppTextVariant.bodyText,
          color: colorScheme.uiAreas.sideBar.inactiveItemText,
        ),
        const SizedBox(height: 24),

        // Stack Selection Panel
        Expanded(child: _buildStackSelectionPanel(stacksAsync)),

        const SizedBox(height: 16),

        // New Stack Creation Button
        Row(
          children: [
            Expanded(
              child: FondeButton(
                label: 'Create New Stack',
                leadingIcon: Icon(FondeIcons.plus, size: 16),
                onPressed: () => _showNewStackCreationPanel(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Selected stack info
        if (_selectedStack != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, color: primaryColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'Selected Stack:',
                        variant: AppTextVariant.captionText,
                        color: colorScheme.uiAreas.sideBar.inactiveItemText,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        _selectedStack!.info.name,
                        variant: AppTextVariant.bodyText,
                        color: textColor,
                      ),
                      if (_selectedStack!.info.description != null) ...[
                        const SizedBox(height: 2),
                        AppText(
                          _selectedStack!.info.description!,
                          variant: AppTextVariant.captionText,
                          color: colorScheme.uiAreas.sideBar.inactiveItemText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FondeButton(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 16),
            FondeButton.primary(
              label: 'Select',
              enabled: _selectedStack != null,
              onPressed:
                  _selectedStack != null
                      ? () => _handleStackSelection(_selectedStack!)
                      : null,
            ),
          ],
        ),
      ],
    );
  }

  void _handleStackSelection(core_stack.Stack stack) {
    widget.onStackSelected?.call(stack);
    Navigator.of(context).pop();
  }

  /// Build stack selection panel using new StackSelectionPanel.
  Widget _buildStackSelectionPanel(
    AsyncValue<List<core_stack.Stack>> stacksAsync,
  ) {
    return switch (stacksAsync) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError(:final error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FondeIcons.info, size: 48),
            const SizedBox(height: 16),
            AppText('Error: $error', variant: AppTextVariant.bodyText),
          ],
        ),
      ),
      AsyncData(:final value) => _buildStackSelectionPanelWithData(value),
      _ => const Center(child: Text('Unknown state')),
    };
  }

  /// Build StackSelectionPanel using actual stack data.
  Widget _buildStackSelectionPanelWithData(List<core_stack.Stack> realStacks) {
    return StackSelectionPanel<core_stack.Stack>(
      stacks: realStacks,
      stackDataConverter: (stack) => CoreStackWrapper(stack),
      selectedStack: _selectedStack,
      onStackSelected: (stack) {
        setState(() {
          _selectedStack = stack;
        });
      },
      onStackDoubleClicked: (stack) {
        _handleStackSelection(stack);
      },
      gridColumns: 3,
      gridRows: 2,
      gridPadding: EdgeInsets.zero,
      crossAxisSpacing: 24.0,
      mainAxisSpacing: 20.0,
      showPageIndicator: true,
      showNavigationButtons: true,
      forceShowPagination: true, // テスト用に強制表示
      enableSearch: true, // Enable search function
      searchFilter: (stack, query) {
        // Search by stack name
        return stack.info.name.toLowerCase().contains(query.toLowerCase());
      },
      emptyWidget: _buildEmptyState(),
    );
  }

  /// Build empty state widget.
  Widget _buildEmptyState() {
    return Consumer(
      builder: (context, ref, child) {
        final colorScheme = ref.watch(effectiveColorSchemeProvider);
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FondeIcons.stacks,
                size: 64,
                color: colorScheme.uiAreas.sideBar.inactiveItemText.withValues(
                  alpha: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              AppText(
                'No stacks available',
                variant: AppTextVariant.bodyText,
                color: colorScheme.uiAreas.sideBar.activeItemText,
              ),
              const SizedBox(height: 8),
              AppText(
                'Create a new stack',
                variant: AppTextVariant.smallText,
                color: colorScheme.uiAreas.sideBar.inactiveItemText,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Display new stack creation panel.
  Future<void> _showNewStackCreationPanel() async {
    final createdStack = await StackManagementService.createNewStack(context);

    if (createdStack != null) {
      setState(() {
        _selectedStack = createdStack;
      });
      widget.onStackSelected?.call(createdStack);
    }
  }
}
