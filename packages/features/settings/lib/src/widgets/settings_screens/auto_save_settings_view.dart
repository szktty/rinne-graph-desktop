import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import '../../providers/auto_save_providers.dart';

/// Auto-save settings view
class AutoSaveSettingsView extends ConsumerWidget {
  const AutoSaveSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(autoSaveSettingsProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppPage(
        title: 'Auto-Save Settings',
        titleVariant: AppTextVariant.pageTitleSmall,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BodyText(
                'You can configure the automatic data saving feature.',
                color: Colors.black54,
              ),
              const SizedBox(height: 16),

              FormList(
                title: 'Auto-Save',
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
                                BodyText('Enable Auto-Save'),
                                SizedBox(height: 4),
                                BodyText(
                                  'Automatically saves data at the specified interval.',
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: settings.enabled,
                            onChanged: (value) {
                              ref
                                  .read(autoSaveSettingsProvider.notifier)
                                  .updateSettings(
                                    settings.copyWith(enabled: value),
                                  );
                            },
                          ),
                        ],
                      ),
                      if (settings.enabled) ...[
                        const SizedBox(height: 16),
                        const BodyText('Save Interval'),
                        const SizedBox(height: 8),
                        ..._buildIntervalOptions(ref, settings),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              FormList(
                title: 'About Auto-Save',
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
                          BodyText('Description of the Auto-Save Feature'),
                        ],
                      ),
                      SizedBox(height: 12),
                      BodyText(
                        '• Data is saved automatically when graph data changes.\n'
                        '• It periodically checks for saves at the set interval.\n'
                        '• Manual saving (Cmd+S) can also be used.\n'
                        '• Even if auto-save is disabled, a save confirmation will be displayed when the application is closed.',
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

  List<Widget> _buildIntervalOptions(WidgetRef ref, dynamic settings) {
    final intervals = [
      const Duration(minutes: 1),
      const Duration(minutes: 5),
      const Duration(minutes: 10),
      const Duration(minutes: 30),
    ];

    return intervals.map((duration) {
      final isSelected = settings.interval == duration;
      final title =
          duration.inMinutes == 1
              ? '${duration.inMinutes} min (Frequent)'
              : duration.inMinutes == 30
              ? '${duration.inMinutes} min (Power-saving)'
              : '${duration.inMinutes} min';

      return Container(
        margin: const EdgeInsets.only(bottom: 8),
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          title: BodyText(title),
          trailing: Radio<Duration>(
            value: duration,
            groupValue: settings.interval,
            onChanged: (Duration? newInterval) {
              if (newInterval != null) {
                ref
                    .read(autoSaveSettingsProvider.notifier)
                    .updateSettings(settings.copyWith(interval: newInterval));
              }
            },
          ),
          onTap: () {
            ref
                .read(autoSaveSettingsProvider.notifier)
                .updateSettings(settings.copyWith(interval: duration));
          },
        ),
      );
    }).toList();
  }
}
