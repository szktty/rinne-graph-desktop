/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_workflow/core_workflow.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';
import 'package:signals/signals.dart';

import 'progress_step.dart';
import 'progress_bar.dart';
import 'status_message.dart';

/// A widget that displays a task progress modal dialog
class TaskProgressModal extends ConsumerStatefulWidget {
  /// Constructor
  const TaskProgressModal({
    super.key,
    required this.task,
    this.useSteppedAnimation = false,
    this.progressSteps,
    this.initialProgressValue = 0.0,
  });

  /// Task to display progress for
  final Task task;

  /// Whether to use stepped animation
  final bool useSteppedAnimation;

  /// Definition of progress steps
  /// Used only if useSteppedAnimation is true
  /// Default value is used if not specified
  final List<ProgressStep>? progressSteps;

  /// Initial progress value (0.0-1.0)
  /// Used for initial display of the progress bar
  final double initialProgressValue;

  @override
  ConsumerState<TaskProgressModal> createState() => _TaskProgressModalState();
}

class _TaskProgressModalState extends ConsumerState<TaskProgressModal> {
  bool _userCancelled = false;
  late Timer _timer;
  late StreamSubscription _progressSubscription;
  late double _indicatorProgressValue;

  @override
  void initState() {
    super.initState();

    _indicatorProgressValue = widget.task.progress.value.value;

    // Periodic timer for indicator updates (1-second interval)
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          if (_userCancelled) {
            return;
          }
          _indicatorProgressValue = widget.task.progress.value.value;
        });
      }
    });

    // Real-time update of progress messages
    _progressSubscription = widget.task.progress.toStream().listen((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _progressSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final appColorScheme = ref.watch(appColorSchemeProvider);

    final status = widget.task.status.value;
    final progress = widget.task.progress.value;
    final error = widget.task.error.value;

    final progressValue = progress.value;

    // Variables for stepped animation
    final actualSteps =
        widget.progressSteps ??
        [
          ProgressStep(
            range: (0.0, 0.3),
            animationDuration: const Duration(milliseconds: 800),
            label: 'Initializing...',
          ),
          ProgressStep(
            range: (0.3, 0.6),
            animationDuration: const Duration(milliseconds: 1200),
            label: 'Processing data...',
          ),
          ProgressStep(
            range: (0.6, 1.0),
            animationDuration: const Duration(milliseconds: 1500),
            label: 'Finalizing...',
          ),
        ];

    // Determine current step
    int currentStepIndex = 0;
    if (widget.useSteppedAnimation) {
      for (int i = 0; i < actualSteps.length; i++) {
        final step = actualSteps[i];
        if (progressValue >= step.range.$1 && progressValue <= step.range.$2) {
          currentStepIndex = i;
          break;
        } else if (progressValue > step.range.$2 &&
            i < actualSteps.length - 1) {
          continue;
        }
      }
    }

    // Build progress message
    String message = '';

    // Set in-progress message
    if (progress.message?.isNotEmpty ?? false) {
      // Use message provided by API
      message = progress.message!;
    } else if (widget.useSteppedAnimation &&
        currentStepIndex < actualSteps.length &&
        actualSteps[currentStepIndex].label != null) {
      // Use step label
      message = actualSteps[currentStepIndex].label!;
    } else if (progress.currentStep != null) {
      // Build step information
      message = progress.currentStep!;

      // Add if step number and total steps are available
      if (progress.currentStepNumber != null && progress.totalSteps != null) {
        message += ' (${progress.currentStepNumber}/${progress.totalSteps})';
      }
    }

    // Set progress bar color based on status
    Color progressBarColor;
    if (status == TaskStatus.failed) {
      progressBarColor = appColorScheme.status.error;
    } else if (status == TaskStatus.completed) {
      progressBarColor = appColorScheme.theme.primaryColor;
    } else if (status == TaskStatus.cancelled) {
      progressBarColor = appColorScheme.base.foreground;
    } else {
      progressBarColor = appColorScheme.theme.primaryColor;
    }

    // For percentage display
    final percentText = '${(progressValue * 100).toInt()}%';

    return AppDialog(
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task name
          AppText(widget.task.name, variant: AppTextVariant.itemTitle),

          const SizedBox(height: 20),

          // Progress bar and progress percentage
          Row(
            children: [
              // Progress bar
              Expanded(
                child: AppRectangleBorder(
                  cornerRadius: AppBorderRadiusValues.small,
                  child:
                      widget.useSteppedAnimation
                          ? SteppedProgressBar(
                            progressValue: _indicatorProgressValue,
                            steps: actualSteps,
                            currentStepIndex: currentStepIndex,
                            progressBarColor: progressBarColor,
                            initialProgressValue: widget.initialProgressValue,
                            isCancelled: status == TaskStatus.cancelled,
                          )
                          : TaskProgressBar(
                            progressValue: _indicatorProgressValue,
                            progressBarColor: progressBarColor,
                            initialProgressValue: widget.initialProgressValue,
                            isCancelled: status == TaskStatus.cancelled,
                          ),
                ),
              ),

              // Display percentage outside the bar
              const SizedBox(width: 8),
              AppText(percentText, variant: AppTextVariant.captionText),
            ],
          ),

          const SizedBox(height: 16),

          // Step indicator (displayed only when stepped animation is used)
          if (widget.useSteppedAnimation)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: StepIndicator(
                currentStepIndex: currentStepIndex,
                steps: actualSteps,
              ),
            ),

          // Status message
          StatusMessage(status: status, message: message, error: error),

          const SizedBox(height: 20),

          // Action buttons
          Align(
            alignment: Alignment.centerRight,
            child: ActionButtons(
              status: status,
              onCancel: () {
                if (!_userCancelled) {
                  _userCancelled = true;
                }
                // Actual task cancellation process
                widget.task.cancel();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Function to display the task progress modal dialog
Future<void> showTaskProgressModal({
  required BuildContext context,
  required Task task,
  bool useSteppedAnimation = false,
  List<ProgressStep>? progressSteps,
  double initialProgressValue = 0.0,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by tap
    builder:
        (context) => TaskProgressModal(
          task: task,
          useSteppedAnimation: useSteppedAnimation,
          progressSteps: progressSteps,
          initialProgressValue: initialProgressValue,
        ),
  );
}
