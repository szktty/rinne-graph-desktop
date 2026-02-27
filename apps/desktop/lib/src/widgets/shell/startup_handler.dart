/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;

import '../../providers/open_stacks_providers.dart';
import '../../providers/app_state_providers.dart';
import '../../services/startup_manager.dart';
import '../../enums/activity_bar_index.dart';

/// Helper that performs automatic stack opening etc. after startup.
/// Behavior is equivalent to conventional MainAppShell internal logic (functionally invariant).
class StartupHandler {
  StartupHandler._();

  static bool _scheduled = false;

  /// Schedules startup processing to run after the first frame.
  /// - commandLineArgs: Command line arguments
  /// - context: Used for SnackBar display, etc.
  static void schedule({
    required WidgetRef ref,
    required BuildContext context,
    required List<String> commandLineArgs,
  }) {
    if (_scheduled) return;
    _scheduled = true;

    widgets.WidgetsBinding.instance.addPostFrameCallback((_) async {
      final startupManager = StartupManager(
        arguments: commandLineArgs,
        ref: ref,
      );

      final startupResult = await startupManager.determineStartupStack();
      if (!startupResult.hasStack) return;

      debugPrint('Loading startup stack: ${startupResult.stackPath}');
      final stack = await startupManager.openStack(startupResult.stackPath!);

      if (stack != null) {
        // Stack opened
        ref.read(core_stack.activeStackProvider.notifier).setStack(stack);
        ref.read(openStacksActionsProvider.notifier).addStack(stack);

        // Navigate to graph navigation screen
        ref
            .read(activityBarStateProvider.notifier)
            .setIndex(ActivityBarIndex.graphNavigation.value);
        return;
      }

      // Error handling when stack could not be opened
      if (startupResult.source == StartupStackSource.commandLine) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not open stack: ${startupResult.stackPath}'),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    });
  }
}
