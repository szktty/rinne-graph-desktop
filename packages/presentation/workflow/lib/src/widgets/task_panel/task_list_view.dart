import 'package:flutter/material.dart';
import 'package:core_workflow/core_workflow.dart';
import 'task_list_item.dart';

/// A widget that displays a list of tasks
class TaskListView extends StatelessWidget {
  const TaskListView({
    super.key,
    required this.tasks,
    this.onTaskTap,
    this.onTaskCancel,
    this.showCompletedTasks = true,
  });

  final List<Task> tasks;
  final void Function(Task)? onTaskTap;
  final void Function(Task)? onTaskCancel;
  final bool showCompletedTasks;

  @override
  Widget build(BuildContext context) {
    // Filter tasks
    final filteredTasks =
        tasks.where((task) {
          if (!showCompletedTasks &&
              task.status.value == TaskStatus.completed) {
            return false;
          }
          return true;
        }).toList();

    if (filteredTasks.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: filteredTasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return TaskListItem(
          task: task,
          onTap: () => onTaskTap?.call(task),
          onCancel: () => onTaskCancel?.call(task),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
