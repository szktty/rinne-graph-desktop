/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:core_workflow/core_workflow.dart';
import '../movable_panel/movable_panel_container.dart';
import 'task_list_view.dart';

/// Panel for displaying background tasks
class TaskPanel extends StatelessWidget {
  const TaskPanel({
    super.key,
    required this.tasks,
    this.initialPosition = const Offset(100, 100),
    this.initialSize = const Size(320, 240),
    this.onPositionChanged,
    this.onSizeChanged,
    this.onClose,
    this.onTaskTap,
    this.onTaskCancel,
    this.showCompletedTasks = true,
  });

  final List<Task> tasks;
  final Offset initialPosition;
  final Size initialSize;
  final void Function(Offset)? onPositionChanged;
  final void Function(Size)? onSizeChanged;
  final VoidCallback? onClose;
  final void Function(Task)? onTaskTap;
  final void Function(Task)? onTaskCancel;
  final bool showCompletedTasks;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      initialPosition: initialPosition,
      initialSize: initialSize,
      onPositionChanged: onPositionChanged,
      onSizeChanged: onSizeChanged,
      onClose: onClose,
      title: 'Background Tasks',
      child: Column(
        children: [
          _buildToolbar(context),
          Expanded(
            child: TaskListView(
              tasks: tasks,
              onTaskTap: onTaskTap,
              onTaskCancel: onTaskCancel,
              showCompletedTasks: showCompletedTasks,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    final runningTasksCount =
        tasks.where((task) => task.status.value == TaskStatus.running).length;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.task_alt,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            '$runningTasksCount running',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // TODO: Cancel all tasks
            },
            icon: const Icon(Icons.stop_circle_outlined),
            iconSize: 16,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            tooltip: 'Cancel all',
          ),
        ],
      ),
    );
  }
}
