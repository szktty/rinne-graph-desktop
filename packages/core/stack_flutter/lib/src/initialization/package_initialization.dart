import 'package:core_foundation_flutter/core_foundation_flutter.dart';
import 'package:core_stack_flutter/src/providers/stack_providers.dart';
import 'package:features_settings/features_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Initialization definition for core_stack package
class CoreStackPackageInitialization implements PackageInitialization {
  const CoreStackPackageInitialization({
    required this.warmUps,
    this.initialize,
  });

  @override
  final List<AsyncValue<dynamic>> Function(WidgetRef ref) warmUps;

  @override
  final void Function(WidgetRef ref)? initialize;
}

/// Default initialization for core_stack package
final coreStackInitialization = CoreStackPackageInitialization(
  warmUps:
      (ref) => [
        // Asset stack loading is excluded from warmUps to avoid blocking UI display
        // Instead, load as needed in the stack management screen
      ],
  initialize: _initializeSampleStackAutoGeneration,
);

/// Initialization of sample stack auto-generation
void _initializeSampleStackAutoGeneration(WidgetRef ref) {
  debugPrint(
    '[core_stack_initialization] Starting sample stack auto-generation initialization',
  );

  // Check for sample stack existence in the background and generate if necessary
  Future.microtask(() async {
    try {
      debugPrint('[core_stack_initialization] Checking startup settings...');

      // 起動設定を取得
      final startupSettings = ref.read(startupSettingsProvider);

      debugPrint(
        '[core_stack_initialization] First launch: ${startupSettings.isFirstLaunch}',
      );
      debugPrint(
        '[core_stack_initialization] Auto-generation flag: ${startupSettings.enableSampleStackAutoGeneration}',
      );

      // Condition check: only on first launch or if auto-generation flag is enabled
      final shouldCheckForGeneration =
          startupSettings.isFirstLaunch ||
          startupSettings.enableSampleStackAutoGeneration;

      if (!shouldCheckForGeneration) {
        debugPrint(
          '[core_stack_initialization] Skipping auto-generation due to unmet conditions',
        );
        return;
      }

      debugPrint('[core_stack_initialization] Checking for existing stacks...');

      // 既存のスタックがあるかチェック
      final stacks = await ref.read(availableStacksListProvider.future);

      debugPrint(
        '[core_stack_initialization] Number of existing stacks: ${stacks.length}',
      );
      for (final stack in stacks) {
        debugPrint(
          '[core_stack_initialization] Existing stack: ${stack.info.name} @ ${stack.directory.path}',
        );
      }

      if (stacks.isEmpty) {
        debugPrint(
          '[core_stack_initialization] No existing stacks. Considering auto-generation to meet conditions.',
        );
        // If it's the first launch, update the first launch flag
        if (startupSettings.isFirstLaunch) {
          debugPrint(
            '[core_stack_initialization] Marking first launch as complete',
          );
          await ref
              .read(startupSettingsNotifierProvider.notifier)
              .markFirstLaunchComplete();
        }
      } else {
        debugPrint(
          '[core_stack_initialization] Existing stacks found (${stacks.length} items), skipping sample stack auto-generation',
        );

        // If it's the first launch, update the first launch flag
        if (startupSettings.isFirstLaunch) {
          debugPrint(
            '[core_stack_initialization] Marking first launch as complete',
          );
          await ref
              .read(startupSettingsNotifierProvider.notifier)
              .markFirstLaunchComplete();
        }
      }
    } catch (e) {
      debugPrint(
        '[core_stack_initialization] Error during sample stack auto-generation check: $e',
      );
    }
  });
}
