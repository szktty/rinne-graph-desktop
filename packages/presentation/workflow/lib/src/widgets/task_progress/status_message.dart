/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_workflow/core_workflow.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';

/// Status message widget
class StatusMessage extends ConsumerWidget {
  /// Constructor
  const StatusMessage({
    super.key,
    required this.status,
    required this.message,
    this.error,
  });

  /// Task status
  final TaskStatus status;

  /// Message
  final String message;

  /// Error
  final TaskError? error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Processing step information
        AppText(message, variant: AppTextVariant.bodyText),

        // Error message (displayed only when error occurs)
        if (status == TaskStatus.failed && error != null)
          _buildMessageContainer(
            ref: ref,
            icon: FondeIcons.error,
            message: error!.message,
          ),
      ],
    );
  }

  /// Build message container
  Widget _buildMessageContainer({
    required WidgetRef ref,
    required IconData icon,
    required String message,
  }) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: FondeRectangleBorder(
        cornerRadius: FondeBorderRadiusValues.small,
        color: appColorScheme.status.error.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              FondeIcon(
                icon,
                color: FondeIconColor.error,
                size: FondeIconSize.small,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppText(message, variant: AppTextVariant.bodyText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Action buttons widget
class ActionButtons extends ConsumerWidget {
  /// Constructor
  const ActionButtons({
    super.key,
    required this.status,
    required this.onCancel,
  });

  /// Task status
  final TaskStatus status;

  /// Callback on cancel
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Whether the task is running
    final isRunning =
        status == TaskStatus.running || status == TaskStatus.paused;

    // Whether the task is finished
    final isFinished =
        status == TaskStatus.completed ||
        status == TaskStatus.failed ||
        status == TaskStatus.cancelled;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Cancel button (displayed only while running)
        if (isRunning) FondeButton.cancel(label: 'Cancel', onPressed: onCancel),

        // OK button (displayed on completion/failure/cancellation)
        if (isFinished)
          FondeButton.primary(
            label: 'OK',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
      ],
    );
  }
}
