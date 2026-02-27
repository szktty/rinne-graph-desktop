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
import '../../providers/settings_providers.dart';

class LanguageSettingsView extends ConsumerWidget {
  const LanguageSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsManagerProvider);
    final settingsNotifier = ref.read(settingsManagerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppPage(
        title: 'Language & Region Settings',
        titleVariant: AppTextVariant.pageTitleSmall,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BodyText(
                'Please select the display language and region settings for the application.',
                color: Colors.black54,
              ),
              const SizedBox(height: 16),

              FormList(
                title: 'Display Language',
                child: Column(
                  children: [
                    _buildLanguageOption(
                      context: context,
                      ref: ref,
                      settingsData: settings,
                      settingsNotifier: settingsNotifier,
                      languageCode: 'ja',
                      countryCode: 'JP',
                      title: 'Japanese',
                      subtitle: 'Japanese',
                    ),
                    const SizedBox(height: 8),
                    _buildLanguageOption(
                      context: context,
                      ref: ref,
                      settingsData: settings,
                      settingsNotifier: settingsNotifier,
                      languageCode: 'en',
                      countryCode: 'US',
                      title: 'English',
                      subtitle: 'English (United States)',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              FormList(
                title: 'Applying Language Settings',
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(AppIcons.info, size: 20, color: Colors.blue),
                      SizedBox(width: 12),
                      Expanded(
                        child: BodyText(
                          'Changes to language settings will take effect after restarting the application.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required WidgetRef ref,
    required dynamic settingsData,
    required dynamic settingsNotifier,
    required String languageCode,
    required String countryCode,
    required String title,
    required String subtitle,
  }) {
    final locale = Locale(languageCode, countryCode);
    final isSelected = settingsData.locale == locale;

    return Container(
      decoration: BoxDecoration(
        border:
            isSelected
                ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                )
                : Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Radio<Locale>(
          value: locale,
          groupValue: settingsData.locale,
          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              settingsNotifier.updateSettings(
                settingsData.copyWith(
                  language: languageCode,
                  locale: newLocale,
                ),
              );
            }
          },
        ),
        title: BodyText(title),
        subtitle: BodyText(subtitle, color: Colors.black54),
        onTap: () {
          settingsNotifier.updateSettings(
            settingsData.copyWith(language: languageCode, locale: locale),
          );
        },
      ),
    );
  }
}
