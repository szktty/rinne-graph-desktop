import 'package:core_themes/core_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';

import 'settings_panel.dart';
import 'settings_screens/appearance_settings_view.dart';
// Keyboard shortcut customization feature to be implemented in the future
import 'settings_screens/accessibility_settings_view.dart';
import '../models/settings_item.dart';

/// Function to display settings in a dialog.
Future<bool?> showSettingsDialog(BuildContext context) async {
  return await showAppDialog<bool>(
    context: context,
    barrierDismissible: false, // Cannot be closed without pressing a button
    title: 'Settings',
    width: 1000,
    heightRatio: 0.8, // 80% of window height
    padding: const EdgeInsets.fromLTRB(
      AppSpacingValues.xxxl, // Left: 32px
      0, // Top: 0px (no space between header and main area)
      AppSpacingValues.xxxl, // Right: 32px
      0, // Bottom: 0px (space between action area is managed by AppDialog)
    ),
    headerBottomSpacing: AppSpacingValues.xl, // 20px
    dividerHorizontalPadding: 0.0,
    footer: _SettingsDialogFooter(
      onCancel: () => Navigator.of(context).pop(false),
      onOk: () {
        _saveSettings();
        Navigator.of(context).pop(true);
      },
    ),
    child: const SettingsDialogContent(),
  );
}

/// Footer of the settings dialog.
class _SettingsDialogFooter extends ConsumerWidget {
  final VoidCallback onCancel;
  final VoidCallback onOk;

  const _SettingsDialogFooter({required this.onCancel, required this.onOk});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.base.border, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacingValues.xl, // Vertical: 20px
          horizontal: AppSpacingValues.xxxl, // Horizontal: 32px
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppButton(label: 'Cancel', onPressed: onCancel),
            const AppSpacing.md(),
            AppButton.primary(label: 'OK', onPressed: onOk),
          ],
        ),
      ),
    );
  }
}

/// Content widget for the settings dialog.
class SettingsDialogContent extends ConsumerWidget {
  const SettingsDialogContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsPanel(
      items: _defaultSettingsItems,
      initialSelectedId: 'appearance', // Select appearance menu by default
      searchable: false,
      emptySelectionBuilder:
          (context) => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppIcon(
                  AppIcons.settings,
                  size: AppIconSize.xlarge,
                  color: AppIconColor.onSurfaceVariant,
                ),
                AppSpacing.lg(),
                AppText(
                  '左側のメニューから設定項目を選択してください',
                  variant: AppTextVariant.bodyText,
                ),
              ],
            ),
          ),
    );
  }

  /// Default settings item list
  static final List<SettingsItem> _defaultSettingsItems = [
    SettingsItem(
      id: 'appearance',
      icon: AppIcons.appearance,
      title: 'Appearance',
      builder: () => const AppearanceSettingsView(),
      keywords: const [
        'Appearance',
        'Theme',
        'Appearance',
        'Color',
        'Light',
        'Dark',
        'System',
        'Animation',
        'Motion',
        'Effects',
      ],
    ),
    SettingsItem(
      id: 'accessibility',
      icon: AppIcons.accessibility,
      title: 'Accessibility',
      builder: () => const AccessibilitySettingsView(),
      keywords: const ['Accessibility', 'Zoom', 'Animation'],
    ),
  ];
}

/// Saves settings (actual implementation performs appropriate saving process).
void _saveSettings() {
  // TODO: Implement settings saving process
  debugPrint('Settings saved');
}
