# core_workflow

## Overview

core_workflow provides a workflow management system for App that handles background tasks with progress tracking. It enables sequential execution of tasks with support for cancellation, pausing, and comprehensive progress monitoring using Signals for reactive state management.

## Key Features

- **Task Management**: Individual task execution with lifecycle management
  - Task creation with custom executors
  - Status tracking (created, running, paused, cancelled, completed, failed)
  - Progress reporting with messages and step information
  - Error handling and result capture

- **Workflow Execution**: Sequential task execution
  - Multiple tasks in defined order
  - Workflow-level progress tracking
  - Cancellation and pause support
  - Completion callbacks

- **Progress Tracking**: Detailed progress information
  - Progress percentage (0.0 - 1.0)
  - Custom progress messages
  - Step-based progress (current/total)
  - Real-time updates via Signals

- **Cooperative Cancellation**: Safe task cancellation
  - Cancellation requests propagate to executors
  - Executors check cancellation status
  - Graceful shutdown support

- **Task Registry**: Central task management
  - Task registration and tracking
  - Query running tasks
  - Task lifecycle management

## Usage

### Creating and Running a Task

```dart
import 'package:core_workflow/core_workflow.dart';

final task = Task<String>(
  name: 'Data Processing',
  description: 'Process large dataset',
  executor: (context) async {
    for (var i = 0; i < 100; i++) {
      // Check for cancellation
      if (context.isCancelled()) {
        return 'Cancelled';
      }

      // Update progress
      context.updateProgress(
        TaskProgress(
          value: i / 100,
          message: 'Processing item $i',
          currentStepNumber: i,
          totalSteps: 100,
        ),
      );

      // Do work
      await processItem(i);
    }
    return 'Completed';
  },
  onCompleted: (task) {
    print('Task completed: ${task.result?.data}');
  },
);

// Start task
final result = await task.start();
```

### Creating a Workflow

```dart
final workflow = Workflow(
  name: 'Data Import Workflow',
  description: 'Import and process data',
  builder: (context) => [
    Task<void>(
      name: 'Validate Data',
      executor: (ctx) async { /* validation */ },
    ),
    Task<void>(
      name: 'Import Data',
      executor: (ctx) async { /* import */ },
    ),
    Task<void>(
      name: 'Generate Report',
      executor: (ctx) async { /* report */ },
    ),
  ],
  onCompleted: (workflow) {
    print('Workflow completed');
  },
);

// Start workflow
await workflow.start();
```

### Monitoring Progress

```dart
// Watch task progress
final progress = task.progress.watch();
print('Progress: ${progress.value * 100}%');
print('Message: ${progress.message}');

// Watch task status
final status = task.status.watch();
print('Status: $status');

// Watch workflow progress
final workflowProgress = workflow.progress.watch();
```

### Task Control

```dart
// Pause task
task.pause();

// Resume task
task.resume();

// Cancel task
task.cancel();

// Check status
print('Is running: ${task.isRunning}');
print('Is cancelled: ${task.isCancelled}');
print('Is completed: ${task.isCompleted}');
```

## Dependencies

- `flutter_riverpod`: State management
- `riverpod_annotation`: Provider annotations
- `uuid`: Unique ID generation
- `freezed_annotation`: Code generation
- `signals`: Reactive state management

## Related Documentation

- [Workflow Architecture](../../docs/architecture/workflow.md)
