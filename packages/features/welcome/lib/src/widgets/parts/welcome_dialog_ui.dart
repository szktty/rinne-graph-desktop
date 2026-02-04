part of '../welcome_dialog_content.dart';

/// Build header section
Widget _buildHeader(
  _WelcomeDialogContentState state,
  Color textColor,
  Color subTextColor,
) {
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
Widget _buildGridHeader(
  _WelcomeDialogContentState state,
  BuildContext context,
  AppColorScheme colorScheme,
) {
  final displayMode = state.ref.watch(stackDisplayModeProvider);

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
          _getDisplayModeTitle(state, displayMode),
          variant: AppTextVariant.bodyText,
          color: colorScheme.base.foreground,
        ),

        // Right side: Action buttons
        Row(
          children: [
            // Create new stack
            AppIconButton(
              onPressed: () => _showNewStackCreationDialog(state, context),
              icon: AppIcons.plus,
              iconSize: 24,
              tooltip: 'Create new stack',
            ),
            const SizedBox(width: 8),

            // Open
            AppIconButton(
              onPressed: () => _showOpenStackDialog(state, context),
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
                      state.ref.read(stackDisplayModeProvider.notifier).state =
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
                      state.ref.read(stackDisplayModeProvider.notifier).state =
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
                      state.ref.read(stackDisplayModeProvider.notifier).state =
                          StackDisplayModeType.sampleTemplate;
                    },
                  ),
                ),
                // Add debug menu
                if (_isDebugMode(state)) ...[
                  const AppPopupMenuDividerEntry<String>(),
                  AppPopupMenuItemEntry<String>(
                    AppPopupMenuItem<String>(
                      value: 'debug_archive_all',
                      title: '[DEBUG] Archive all stacks',
                      icon: Icons.archive_outlined,
                      onSelected: () {
                        _showDebugArchiveAllConfirmation(state, context);
                      },
                    ),
                  ),
                  AppPopupMenuItemEntry<String>(
                    AppPopupMenuItem<String>(
                      value: 'debug_delete_all',
                      title: '[DEBUG] Delete all stacks',
                      icon: Icons.delete_forever_outlined,
                      onSelected: () {
                        _showDebugDeleteAllConfirmation(state, context);
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

/// Build warning item
Widget _buildWarningItem(
  _WelcomeDialogContentState state,
  String text,
  AppColorScheme colorScheme,
) {
  return AppText(
    text,
    variant: AppTextVariant.bodyText,
    color: colorScheme.base.foreground.withValues(alpha: 0.8),
  );
}

/// Build dialog footer with optional cancel and confirm buttons
Widget _buildDialogFooter(
  _WelcomeDialogContentState state, {
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
      ),
    ),
  );
}

/// Get display mode title
String _getDisplayModeTitle(
  _WelcomeDialogContentState state,
  StackDisplayModeType displayMode,
) {
  switch (displayMode) {
    case StackDisplayModeType.archived:
      return 'Archived stacks';
    case StackDisplayModeType.sampleTemplate:
      return 'Sample stack templates';
    case StackDisplayModeType.active:
      return '';
  }
}

/// Build version info widget for display in the top right
Widget _buildVersionInfo(
  _WelcomeDialogContentState state,
  AppColorScheme colorScheme,
) {
  final displayVersionAsync = state.ref.watch(displayVersionStringProvider);

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
