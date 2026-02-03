import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';

/// Card component exclusively for settings screens.
///
/// A card for grouping and displaying setting items.
/// Based on AppCard, it applies styling suitable for settings screens.
class SettingsCard extends ConsumerWidget {
  /// The header part of the card.
  final Widget? header;

  /// The main content of the card.
  final Widget content;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  /// Inner padding.
  final EdgeInsetsGeometry? padding;

  /// The width of the card.
  final double? width;

  /// The height of the card.
  final double? height;

  const SettingsCard({
    super.key,
    this.header,
    required this.content,
    this.margin,
    this.padding,
    this.width,
    this.height,
  });

  /// Settings card with a header.
  SettingsCard.withHeader({
    super.key,
    required String title,
    String? subtitle,
    Widget? trailing,
    required this.content,
    this.margin,
    this.padding,
    this.width,
    this.height,
  }) : header = _SettingsCardHeader(
         title: title,
         subtitle: subtitle,
         trailing: trailing,
       );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      header: header,
      content: content,
      margin: margin ?? const EdgeInsets.only(bottom: 16.0),
      padding: padding ?? const EdgeInsets.all(20.0),
      width: width,
      height: height,
    );
  }
}

/// Header component for the settings card.
class _SettingsCardHeader extends ConsumerWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const _SettingsCardHeader({
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(title, variant: AppTextVariant.itemTitle),
              if (subtitle != null) ...[
                const SizedBox(height: 4.0),
                AppText(subtitle!, variant: AppTextVariant.captionText),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 16.0), trailing!],
      ],
    );
  }
}

/// Card for a list of setting items.
class SettingsListCard extends ConsumerWidget {
  /// The title of the card.
  final String title;

  /// The description of the card.
  final String? description;

  /// List of setting items.
  final List<Widget> children;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  const SettingsListCard({
    super.key,
    required this.title,
    this.description,
    required this.children,
    this.margin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsCard.withHeader(
      title: title,
      subtitle: description,
      margin: margin,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) const SizedBox(height: 12.0),
          ],
        ],
      ),
    );
  }
}

/// Card for a settings form.
class SettingsFormCard extends ConsumerWidget {
  /// The title of the card.
  final String title;

  /// The description of the card.
  final String? description;

  /// The content of the form.
  final Widget form;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  const SettingsFormCard({
    super.key,
    required this.title,
    this.description,
    required this.form,
    this.margin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsCard.withHeader(
      title: title,
      subtitle: description,
      margin: margin,
      content: form,
    );
  }
}

/// Card for a settings section (no border, only background).
class SettingsSectionCard extends ConsumerWidget {
  /// The title of the section.
  final String title;

  /// The description of the section.
  final String? description;

  /// The content of the section.
  final Widget content;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  const SettingsSectionCard({
    super.key,
    required this.title,
    this.description,
    required this.content,
    this.margin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);

    return AppCard(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(title, variant: AppTextVariant.sectionTitlePrimary),
          if (description != null) ...[
            const SizedBox(height: 8.0),
            AppText(description!, variant: AppTextVariant.bodyText),
          ],
          const SizedBox(height: 20.0),
          content,
        ],
      ),
      margin: margin ?? const EdgeInsets.only(bottom: 24.0),
      padding: const EdgeInsets.all(24.0),
      backgroundColor: colorScheme.base.background,
      borderSide: BorderSide.none, // No border
    );
  }
}
