/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';
import 'dart:math' as math;
import 'progress_step.dart';

/// Standard progress bar widget
class TaskProgressBar extends ConsumerWidget {
  /// Constructor
  const TaskProgressBar({
    super.key,
    required this.progressValue,
    required this.progressBarColor,
    this.initialProgressValue = 0.0,
    this.animationDuration = const Duration(milliseconds: 500),
    this.isCancelled = false,
  });

  /// Progress value (0.0-1.0)
  final double progressValue;

  /// Progress bar color
  final Color progressBarColor;

  /// Initial progress value (0.0-1.0)
  final double initialProgressValue;

  /// Animation duration
  final Duration animationDuration;

  /// Whether it is in a cancelled state
  final bool isCancelled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double linearProgressHeight = 8.0;

    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    const borderRadius = FondeBorderRadiusValues.mediumRadius;

    // When cancelled, stop animation and maintain current value
    if (isCancelled) {
      return SizedBox(
        height: linearProgressHeight,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: LinearProgressIndicator(
            value: progressValue,
            backgroundColor: appColorScheme.base.divider,
            valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
          ),
        ),
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: initialProgressValue, end: progressValue),
      duration: animationDuration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        return SizedBox(
          height: linearProgressHeight,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: LinearProgressIndicator(
              value: animatedValue,
              backgroundColor: appColorScheme.base.divider,
              valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
            ),
          ),
        );
      },
    );
  }
}

/// Stepped progress bar widget
class SteppedProgressBar extends ConsumerWidget {
  /// Constructor
  const SteppedProgressBar({
    super.key,
    required this.progressValue,
    required this.steps,
    required this.currentStepIndex,
    required this.progressBarColor,
    this.initialProgressValue = 0.0,
    this.isCancelled = false,
  });

  /// Progress value (0.0-1.0)
  final double progressValue;

  /// Definition of progress steps
  final List<ProgressStep> steps;

  /// Current step index
  final int currentStepIndex;

  /// Progress bar color
  final Color progressBarColor;

  /// Initial progress value (0.0-1.0)
  final double initialProgressValue;

  /// Whether it is in a cancelled state
  final bool isCancelled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    // Get current step
    final currentStep = steps[currentStepIndex];

    // Target the end position of the current step
    final targetProgress = currentStep.range.$2;

    // Get animation duration
    final duration = currentStep.animationDuration;

    return Stack(
      children: [
        // Actual progress bar
        // When cancelled, stop animation and maintain current value
        isCancelled
            ? SizedBox(
              height: 15,
              child: LinearProgressIndicator(
                value: progressValue,
                backgroundColor: appColorScheme.base.divider,
                valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
              ),
            )
            : TweenAnimationBuilder<double>(
              // Animate to the end position of the current step
              tween: Tween<double>(
                begin: math.max(currentStep.range.$1, initialProgressValue),
                end: math.min(targetProgress, progressValue),
              ),
              duration: duration,
              curve: Curves.easeOutCubic,
              builder: (context, animatedValue, _) {
                return SizedBox(
                  height: 15,
                  child: LinearProgressIndicator(
                    value: animatedValue,
                    backgroundColor: appColorScheme.base.divider,
                    valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
                  ),
                );
              },
            ),

        // Step markers
        IgnorePointer(
          child: Row(
            children: [
              for (int i = 0; i < steps.length - 1; i++)
                Expanded(
                  flex: ((steps[i].range.$2 - steps[i].range.$1) * 100).round(),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 2,
                      height: 15,
                      color: appColorScheme.base.divider,
                    ),
                  ),
                ),
              Expanded(
                flex:
                    ((steps.last.range.$2 - steps.last.range.$1) * 100).round(),
                child: Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Step indicator widget
class StepIndicator extends StatelessWidget {
  /// Constructor
  const StepIndicator({
    super.key,
    required this.currentStepIndex,
    required this.steps,
  });

  /// Current step index
  final int currentStepIndex;

  /// Definition of progress steps
  final List<ProgressStep> steps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < steps.length; i++)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  i <= currentStepIndex
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Step ${i + 1}',
              style: theme.textTheme.bodySmall?.copyWith(
                color:
                    i <= currentStepIndex
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                fontWeight: i == currentStepIndex ? FontWeight.bold : null,
              ),
            ),
          ),
      ],
    );
  }
}
