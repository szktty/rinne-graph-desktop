# Presentation Workflow

A Flutter package that provides workflow-related UI elements for the App application.

## Features

This package provides the following features:

- Modal dialog for displaying task progress
- Task state management with Riverpod
- Progress monitoring with Signals
- Task host widget

## Usage

### TaskProgressModal

To display a modal dialog showing task progress, use the `showTaskProgressModal` function as follows:

```dart
import 'package:core_workflow/core_workflow.dart';
import 'package:presentation_workflow/presentation_workflow.dart';

// Create a task
final task = Task<void>(
  name: 'Importing file...',
  executor: (context) async {
    // Task execution logic
    for (var i = 0; i < 10; i++) {
      // Update progress
      context.updateProgress(
        TaskProgress(
          value: i / 10.0,
          message: 'Processing...',
          currentStep: 'Step $i',
          totalSteps: 10,
          currentStepNumber: i + 1,
        ),
      );

      // Actual processing
      await Future.delayed(const Duration(milliseconds: 300));
    }
  },
);

// Start the task
task.start();

// Show progress modal
showTaskProgressModal(
  context: context,
  task: task,
);
```

### Riverpod Integration

To use task progress display functionality throughout the application, place the `TaskProgressHost` widget at the root of your app:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_workflow/presentation_workflow.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskProgressHost(
        child: HomePage(),
      ),
    );
  }
}
```

After that, you can display tasks from anywhere in the application:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_workflow/core_workflow.dart';
import 'package:presentation_workflow/presentation_workflow.dart';

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showTaskProgress = ref.watch(showTaskProgressProvider);

    return ElevatedButton(
      onPressed: () {
        final task = Task<void>(
          name: 'Processing data...',
          executor: _myTaskExecutor,
        );

        // Start the task
        task.start();

        // Show progress modal
        showTaskProgress(task);
      },
      child: const Text('Start Processing'),
    );
  }

  Future<void> _myTaskExecutor(TaskContext context) async {
    // Task execution logic
  }
}
```

## Sample

The package includes a sample widget called `TaskProgressDemo`. You can use it to display a demo of task progress display:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_workflow/presentation_workflow.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: TaskProgressDemo(),
      ),
    ),
  );
}
```

## Monitoring Progress with Signals

Task progress is monitored using Signals. TaskProgressModal internally uses the Signals `Watch` widget to automatically update the UI:

```dart
// Part of TaskProgressModal code
Widget build(BuildContext context) {
  return Watch((context) {
    final status = task.status.value;
    final progress = task.progress.value;

    // ...UI construction
  }, dependencies: [task.status, task.progress]);
}
```

This automatically updates the UI whenever the task state or progress changes.
