import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:features_welcome/src/providers/welcome_providers.dart';
import 'package:features_welcome/src/widgets/import_dialog.dart';

import 'package:desktop/src/widgets/shell/welcome_screen_helpers.dart';
import 'package:desktop/src/widgets/shell/welcome_screen_dialogs.dart';

/// Header section for the stack grid on the welcome screen.
class WelcomeScreenGridHeader extends ConsumerWidget {
  const WelcomeScreenGridHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayMode = ref.watch(stackDisplayModeProvider);
    final colorScheme = ref.watch(effectiveColorSchemeProvider);

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
            getDisplayModeTitleHelper(displayMode),
            variant: AppTextVariant.bodyText,
            color: colorScheme.base.foreground,
          ),

          // Right side: Action buttons
          Row(
            children: [
              // Create new stack (Now handled by WelcomeScreenActionButtons)
              // Open (Now handled by WelcomeScreenActionButtons)

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
                  if (isDebugModeHelper(ref)) ...[
                    const AppPopupMenuDividerEntry<String>(),
                    AppPopupMenuItemEntry<String>(
                      AppPopupMenuItem<String>(
                        value: 'debug_archive_all',
                        title: '[DEBUG] Archive all stacks',
                        icon: Icons.archive_outlined,
                        onSelected: () {
                          showDebugArchiveAllConfirmationHelper(context, ref);
                        },
                      ),
                    ),
                    AppPopupMenuItemEntry<String>(
                      AppPopupMenuItem<String>(
                        value: 'debug_delete_all',
                        title: '[DEBUG] Delete all stacks',
                        icon: Icons.delete_forever_outlined,
                        onSelected: () {
                          showDebugDeleteAllConfirmationHelper(context, ref);
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
}
