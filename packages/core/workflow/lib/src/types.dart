/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:freezed_annotation/freezed_annotation.dart';

part 'types.freezed.dart';

/// Enumeration representing the execution status of a task
enum TaskStatus {
  /// The task has been created and has not yet been executed
  created,

  /// The task is currently running
  running,

  /// The task is paused
  paused,

  /// The task has been cancelled
  cancelled,

  /// The task has completed successfully
  completed,

  /// The task has failed with an error
  failed,
}

/// Class representing the progress of a task
@freezed
abstract class TaskProgress with _$TaskProgress {
  const factory TaskProgress({
    /// Progress rate (0.0 to 1.0)
    required double value,

    /// Message regarding progress (optional)
    String? message,

    /// Current step (optional)
    String? currentStep,

    /// Total number of steps (optional)
    int? totalSteps,

    /// Current step number (optional)
    int? currentStepNumber,
  }) = _TaskProgress;

  /// Default progress (0%)
  factory TaskProgress.zero() => const TaskProgress(value: 0.0);

  /// Completed progress (100%)
  factory TaskProgress.complete() => const TaskProgress(value: 1.0);
}

/// Task error information
@freezed
abstract class TaskError with _$TaskError {
  const factory TaskError({
    /// Error message
    required String message,

    /// Original error object (optional)
    Object? error,

    /// Stack trace (optional)
    StackTrace? stackTrace,
  }) = _TaskError;
}

/// Type of task result
@freezed
abstract class TaskResult<T> with _$TaskResult<T> {
  /// Successful task result
  const factory TaskResult.success({required T data}) = TaskSuccess<T>;

  /// Failed task result
  const factory TaskResult.failure({required TaskError error}) = TaskFailure<T>;

  /// Cancelled task
  const factory TaskResult.cancelled() = TaskCancelled<T>;
}

/// Type of task event
enum TaskEventType {
  /// Task registered
  registered,

  /// Task started
  started,

  /// Task progress updated
  progressUpdated,

  /// Task paused
  paused,

  /// Task resumed
  resumed,

  /// Task cancelled
  cancelled,

  /// Task completed
  completed,

  /// Task failed
  failed,
}

/// Class representing a task event
@freezed
abstract class TaskEvent with _$TaskEvent {
  const factory TaskEvent({
    /// Type of event
    required TaskEventType type,

    /// Task ID
    required String taskId,

    /// Time when the event occurred
    required DateTime timestamp,

    /// Task progress information (for progress update events)
    TaskProgress? progress,

    /// Task error information (for failure events)
    TaskError? error,

    /// Task result (for completion events)
    dynamic result,
  }) = _TaskEvent;
}

/// Enumeration representing the status of a workflow
enum WorkflowStatus {
  /// The workflow has been created and has not yet been executed
  created,

  /// The workflow is currently running
  running,

  /// The workflow is paused
  paused,

  /// The workflow has been cancelled
  cancelled,

  /// The workflow has completed successfully
  completed,

  /// The workflow has failed with an error
  failed,
}
