/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_foundation_flutter/core_foundation_flutter.dart';
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
        // Sample stack instantiation is handled by sampleStacksListProvider
      ],
  initialize: _initializeStartupSettings,
);

bool _startupInitializationDone = false;

/// Handle first launch flag at startup
void _initializeStartupSettings(WidgetRef ref) {
  if (_startupInitializationDone) return;
  _startupInitializationDone = true;

  Future.microtask(() async {
    try {
      final startupSettings = ref.read(startupSettingsSyncProvider);
      if (startupSettings.isFirstLaunch) {
        debugPrint(
          '[core_stack_initialization] Marking first launch as complete',
        );
        await ref
            .read(startupSettingsProvider.notifier)
            .markFirstLaunchComplete();
      }
    } catch (e) {
      debugPrint(
        '[core_stack_initialization] Error during startup initialization: $e',
      );
    }
  });
}
