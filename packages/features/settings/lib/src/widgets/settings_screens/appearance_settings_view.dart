import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_settings/core_settings.dart';
import 'package:core_themes/core_themes.dart' as core_themes;
import 'package:presentation_components/presentation_components.dart';
import '../../providers/settings_providers.dart';

/// Appearance settings view.
class AppearanceSettingsView extends ConsumerWidget {
  const AppearanceSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfig = ref.watch(core_themes.activeThemeProvider);
    final currentThemeType = ref.watch(core_themes.themeColorTypeProvider);
    final appColorScheme = ref.watch(core_themes.effectiveColorSchemeProvider);

    return AppCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(24.0),
      borderSide: BorderSide.none,
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Appearance Settings',
            variant: AppTextVariant.pageTitleSmall,
            color: appColorScheme.base.foreground,
          ),
          const SizedBox(height: 8),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme mode settings
            FormList(
              title: 'Theme Mode',
              child: Row(
                children: [
                  Expanded(
                    child: _buildThemeModeOption(
                      context: context,
                      ref: ref,
                      themeConfig: themeConfig,
                      appColorScheme: appColorScheme,
                      mode: ThemeMode.system,
                      title: 'System',
                      icon: AppIcons.settings,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildThemeModeOption(
                      context: context,
                      ref: ref,
                      themeConfig: themeConfig,
                      appColorScheme: appColorScheme,
                      mode: ThemeMode.light,
                      title: 'Light',
                      icon: AppIcons.sun,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildThemeModeOption(
                      context: context,
                      ref: ref,
                      themeConfig: themeConfig,
                      appColorScheme: appColorScheme,
                      mode: ThemeMode.dark,
                      title: 'Dark',
                      icon: AppIcons.moon,
                    ),
                  ),
                ],
              ),
            ),

            const AppSpacing.xxxl(),

            // テーマカラー設定
            FormList(
              title: 'Theme Color',
              child: _buildThemeColorGrid(context, ref, currentThemeType),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeModeOption({
    required BuildContext context,
    required WidgetRef ref,
    required dynamic themeConfig,
    required core_themes.AppColorScheme appColorScheme,
    required ThemeMode mode,
    required String title,
    required IconData icon,
  }) {
    final isSelected = themeConfig.themeMode == mode;

    return GestureDetector(
      onTap: () {
        ref
            .read(core_themes.activeThemeProvider.notifier)
            .setTheme(themeConfig.copyWith(themeMode: mode));
      },
      child: Container(
        // Reduce margin by the amount border width increases when selected
        margin: EdgeInsets.all(isSelected ? 0 : 1),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? appColorScheme.interactive.list.selectedBackground
                  : appColorScheme.base.background,
          border: Border.all(
            color:
                isSelected
                    ? appColorScheme.theme.primaryColor
                    : appColorScheme.base.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(
              icon,
              size: AppIconSize.large,
              color: AppIconColor.onSurface,
            ),
            const SizedBox(height: 8),
            AppText(
              title,
              variant: AppTextVariant.bodyText,
              color: appColorScheme.base.foreground,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeColorGrid(
    BuildContext context,
    WidgetRef ref,
    core_themes.ThemeColorType currentThemeType,
  ) {
    final brightness = Theme.of(context).brightness;

    // Create a list of AppColorOption from ThemeColorType
    final colorOptions =
        core_themes.ThemeColorType.values.map((themeType) {
          final colorDef =
              core_themes.ThemeColorScheme.defaultColors[themeType]!;
          final displayColor =
              brightness == Brightness.light
                  ? colorDef.lightColor
                  : colorDef.darkColor;

          return AppColorOption<core_themes.ThemeColorType>(
            value: themeType,
            color: displayColor,
            name: _getThemeColorName(themeType),
          );
        }).toList();

    return AppColorPicker<core_themes.ThemeColorType>(
      options: colorOptions,
      selectedValue: currentThemeType,
      onChanged: (themeType) {
        // features_settings の設定管理システム経由でテーマカラーを更新
        ref
            .read(settingsManagerProvider.notifier)
            .updateThemeColorType(themeType.name);
      },
      spacing: 16.0,
      semanticLabel: 'Select Theme Color',
    );
  }

  /// Gets name corresponding to ThemeColorType.
  String _getThemeColorName(core_themes.ThemeColorType themeType) {
    switch (themeType) {
      case core_themes.ThemeColorType.red:
        return 'Red';
      case core_themes.ThemeColorType.orange:
        return 'Orange';
      case core_themes.ThemeColorType.yellow:
        return 'Yellow';
      case core_themes.ThemeColorType.green:
        return 'Green';
      case core_themes.ThemeColorType.blue:
        return 'Blue';
      case core_themes.ThemeColorType.indigo:
        return 'Indigo';
      case core_themes.ThemeColorType.violet:
        return 'Violet';
      case core_themes.ThemeColorType.pink:
        return 'Pink';
      case core_themes.ThemeColorType.graphite:
        return 'Graphite';
    }
  }
}
