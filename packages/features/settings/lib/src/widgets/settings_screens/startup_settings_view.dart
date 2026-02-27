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
import '../../providers/startup_providers.dart';

/// Startup settings view.
class StartupSettingsView extends ConsumerWidget {
  const StartupSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(startupSettingsProvider);

    return settingsAsync.when(
      data: (settings) => _buildContent(context, ref, settings),
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stack) =>
              Center(child: BodyText('Failed to load settings: $error')),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    StartupSettings settings,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppPage(
        title: 'Startup Settings',
        titleVariant: AppTextVariant.pageTitleSmall,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BodyText(
                'You can configure application startup behavior.',
                color: Colors.black54,
              ),
              const SizedBox(height: 16),

              // Auto-startup settings
              FormList(
                title: 'Auto-load Stack',
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BodyText(
                                  'Automatically open the last opened stack on startup',
                                ),
                                SizedBox(height: 4),
                                BodyText(
                                  'If enabled, the application will automatically load the previously used stack on startup',
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: settings.autoOpenLastStack,
                            onChanged: (value) {
                              ref
                                  .read(startupSettingsProvider.notifier)
                                  .toggleAutoOpen(value);
                            },
                          ),
                        ],
                      ),

                      if (settings.autoOpenLastStack) ...[
                        const SizedBox(height: 24),
                        const BodyText('最後に開いたスタック:'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                AppIcons.database,
                                size: 16,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: BodyText(
                                  settings.lastOpenedStackPath ??
                                      'No stack opened yet',
                                  color:
                                      settings.lastOpenedStackPath != null
                                          ? null
                                          : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Error behavior settings
              if (settings.autoOpenLastStack) ...[
                FormList(
                  title: 'Behavior when stack not found',
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildErrorBehaviorOption(
                          ref,
                          settings,
                          StartupErrorBehavior.showWelcome,
                          'Show welcome screen',
                          'Show welcome screen as usual (recommended)',
                        ),
                        const SizedBox(height: 12),
                        _buildErrorBehaviorOption(
                          ref,
                          settings,
                          StartupErrorBehavior.showError,
                          'Show error dialog',
                          'Display error details and manually select a stack',
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // 起動設定についての説明
              FormList(
                title: 'About Startup Settings',
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(AppIcons.info, size: 20, color: Colors.blue),
                          SizedBox(width: 12),
                          BodyText('Explanation of startup settings'),
                        ],
                      ),
                      SizedBox(height: 12),
                      BodyText(
                        '• コマンドライン引数で指定されたスタックは、この設定より優先されます\n'
                        '• Each time a stack is opened, it is automatically recorded as the "last opened stack"\n'
                        '• スタックファイルが移動または削除された場合は、エラーが発生します\n'
                        '• This setting takes effect immediately and will be active from the next startup',
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

  Widget _buildErrorBehaviorOption(
    WidgetRef ref,
    StartupSettings settings,
    StartupErrorBehavior behavior,
    String title,
    String subtitle,
  ) {
    final isSelected = settings.errorBehavior == behavior;

    return Container(
      decoration: BoxDecoration(
        border:
            isSelected
                ? Border.all(
                  color: Theme.of(ref.context).colorScheme.primary,
                  width: 2,
                )
                : Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: BodyText(title),
        subtitle: BodyText(subtitle, color: Colors.black54),
        trailing: Radio<StartupErrorBehavior>(
          value: behavior,
          groupValue: settings.errorBehavior,
          onChanged: (StartupErrorBehavior? newBehavior) {
            if (newBehavior != null) {
              ref
                  .read(startupSettingsProvider.notifier)
                  .updateSettings(
                    settings.copyWith(errorBehavior: newBehavior),
                  );
            }
          },
        ),
        onTap: () {
          ref
              .read(startupSettingsProvider.notifier)
              .updateSettings(settings.copyWith(errorBehavior: behavior));
        },
      ),
    );
  }
}
