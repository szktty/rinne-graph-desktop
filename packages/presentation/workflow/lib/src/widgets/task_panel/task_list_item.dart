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
import 'package:core_themes/core_themes.dart';
import 'package:signals/signals.dart';

/// A widget that displays a single item in a task list
class TaskListItem extends ConsumerStatefulWidget {
  const TaskListItem({
    super.key,
    required this.task,
    this.onTap,
    this.onCancel,
  });

  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  @override
  ConsumerState<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends ConsumerState<TaskListItem> {
  double? _cancelledProgressValue;
  bool _isCancelled = false;
  late Timer _timer;
  late StreamSubscription _progressSubscription;

  @override
  void initState() {
    super.initState();
    // Initialize the state based on the initial task status.
    _isCancelled = widget.task.isCancelled;
    if (_isCancelled) {
      _cancelledProgressValue = widget.task.progress.value.value;
    }

    // Periodic timer for indicator updates (1-second interval)
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _needsUpdateIndicator = true;
          _previousProgressValue = widget.task.progress.value.value;
        });
      }
    });

    // Real-time update of progress messages
    _progressSubscription = widget.task.progress.toStream().listen((_) {
      if (mounted) {
        setState(() {
          _needsUpdateIndicator = false;
        });
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
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);

    final status = widget.task.status.value;
    final progress = widget.task.progress.value;
    final error = widget.task.error.value;

    // Save the progress value when cancelled
    if (status == TaskStatus.cancelled && !_isCancelled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _cancelledProgressValue = progress.value;
            _isCancelled = true;
          });
        }
      });
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, appColorScheme, status),
              const SizedBox(height: 8),
              _buildProgressSection(context, appColorScheme, status, progress),
              if (error != null && status == TaskStatus.failed) ...[
                const SizedBox(height: 8),
                _buildErrorSection(context, error.message),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppColorScheme appColorScheme,
    TaskStatus status,
  ) {
    return Row(
      children: [
        _buildStatusIcon(appColorScheme, status),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            widget.task.name,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (status == TaskStatus.running && widget.onCancel != null)
          IconButton(
            onPressed: widget.onCancel,
            icon: const Icon(Icons.stop),
            iconSize: 16,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            tooltip: 'Cancel',
          ),
      ],
    );
  }

  Widget _buildStatusIcon(AppColorScheme appColorScheme, TaskStatus status) {
    switch (status) {
      case TaskStatus.created:
        return Icon(
          Icons.schedule,
          size: 16,
          color: appColorScheme.base.foreground.withValues(alpha: 0.6),
        );
      case TaskStatus.running:
        return SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: appColorScheme.status.info,
          ),
        );
      case TaskStatus.completed:
        return Icon(
          Icons.check_circle,
          size: 16,
          color: appColorScheme.status.success,
        );
      case TaskStatus.failed:
        return Icon(Icons.error, size: 16, color: appColorScheme.status.error);
      case TaskStatus.cancelled:
        return Icon(
          Icons.cancel,
          size: 16,
          color: appColorScheme.base.foreground.withValues(alpha: 0.6),
        );
      case TaskStatus.paused:
        return Icon(
          Icons.pause_circle,
          size: 16,
          color: appColorScheme.status.warning,
        );
    }
  }

  var _needsUpdateIndicator = false;
  double _previousProgressValue = 0.0;

  Widget _buildProgressSection(
    BuildContext context,
    AppColorScheme appColorScheme,
    TaskStatus status,
    TaskProgress progress,
  ) {
    if (status == TaskStatus.completed ||
        status == TaskStatus.failed ||
        status == TaskStatus.cancelled) {
      return _buildStatusMessage(context, appColorScheme, status);
    }

    final progressValue =
        _isCancelled
            ? (_cancelledProgressValue ?? progress.value)
            : progress.value;
    final message =
        _isCancelled
            ? 'Cancelling...'
            : (progress.message ?? progress.currentStep ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.isNotEmpty) ...[
          Text(
            message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
        ],
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: 0, //_previousProgressValue,
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _isCancelled
                      ? Colors.grey
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${(progressValue * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusMessage(
    BuildContext context,
    AppColorScheme appColorScheme,
    TaskStatus status,
  ) {
    String message;
    Color color;

    switch (status) {
      case TaskStatus.completed:
        message = 'Completed';
        color = appColorScheme.status.success;
        break;
      case TaskStatus.failed:
        message = 'Error';
        color = appColorScheme.status.error;
        break;
      case TaskStatus.cancelled:
        message = 'Cancelled';
        color = appColorScheme.base.foreground.withValues(alpha: 0.6);
        break;
      default:
        message = '';
        color = appColorScheme.base.foreground.withValues(alpha: 0.6);
    }

    return Text(
      message,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildErrorSection(BuildContext context, String error) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
