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
import 'package:core_stack_flutter/core_stack.dart' as core_stack;

import '../dialogs/csv_import_dialog.dart';
import '../dialogs/import_progress_dialog.dart';
import 'csv_import_service.dart';

class CsvImportIntegration {
  /// Runs the import the File menu offers: pick a file, say where it goes,
  /// watch it run.
  ///
  /// Handles CSV and .xlsx alike — [CsvImportService.importFileToStack] picks
  /// the reader from the extension.
  static Future<void> handleCsvImport(
    BuildContext context,
    ProviderContainer container,
  ) async {
    try {
      final filePath = await showCsvFilePickerDialog(context);
      if (filePath == null || !context.mounted) return;

      // Adding to the open stack is only offered when one is open.
      final openStack = container.read(core_stack.activeStackProvider);
      core_stack.Stack? targetStack;
      if (openStack != null) {
        final addToOpen = await _showDestinationDialog(context, openStack);
        if (addToOpen == null || !context.mounted) return;
        targetStack = addToOpen ? openStack : null;
      }

      // A new stack needs a name; adding to one that exists does not.
      var stackName = targetStack?.info.name ?? '';
      if (targetStack == null) {
        final chosen = await _showStackNameDialog(context, filePath);
        if (chosen == null || !context.mounted) return;
        stackName = chosen;
      }

      await _runForegroundImportTask(
        context,
        container,
        filePath,
        stackName,
        targetStack,
      );
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog(context, 'Import Error: $e');
      }
    }
  }

  /// Asks whether the file joins the open stack or starts a new one.
  ///
  /// Returns true to add to [openStack], false to create, null if cancelled.
  static Future<bool?> _showDestinationDialog(
    BuildContext context,
    core_stack.Stack openStack,
  ) async {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Where should this go?'),
            content: Text(
              'Add the file to the open stack "${openStack.info.name}", or '
              'import it into a new one?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('New stack'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Add to open stack'),
              ),
            ],
          ),
    );
  }

  static Future<String?> _showStackNameDialog(
    BuildContext context,
    String filePath,
  ) async {
    final fileName = filePath
        .split('/')
        .last
        .replaceAll(RegExp(r'\.(csv|xlsx)$', caseSensitive: false), '');
    final controller = TextEditingController(text: fileName);

    return showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Enter Stack Name'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Stack Name',
                hintText: 'Enter the name of the stack to import',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = controller.text.trim();
                  if (name.isNotEmpty) {
                    Navigator.of(context).pop(name);
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  static Future<void> _runForegroundImportTask(
    BuildContext context,
    ProviderContainer container,
    String filePath,
    String stackName,
    core_stack.Stack? targetStack,
  ) async {
    final progressController = StreamController<double>.broadcast();

    // 進行ダイアログを表示
    final completer = Completer<bool>();
    bool cancelled = false;

    showImportProgressDialog(
      context: context,
      fileName: filePath.split('/').last,
      progressStream: progressController.stream,
      onCancel: () {
        cancelled = true;
        Navigator.of(context).pop();
        completer.complete(false);
      },
      onBackground: () {
        Navigator.of(context).pop();
        _runBackgroundImportTask(
          context,
          container,
          filePath,
          stackName,
          targetStack,
        );
        completer.complete(true);
      },
    );

    // Execute import process
    try {
      final outcome = await CsvImportService.importFileToStack(
        filePath: filePath,
        stackName: stackName,
        container: container,
        targetStack: targetStack,
        onProgress: (progress) {
          if (!cancelled) {
            progressController.add(progress);
          }
        },
      );

      if (!cancelled) {
        progressController.add(1.0);
        if (context.mounted) {
          // The progress dialog does not close itself when the work finishes.
          Navigator.of(context).pop();
          _showSuccessDialog(context, outcome);
        }
      }
    } catch (e) {
      if (!cancelled && context.mounted) {
        Navigator.of(context).pop();
        _showErrorDialog(context, 'Import Error: $e');
      }
    } finally {
      progressController.close();
    }
  }

  /// Runs the import as a background task, for files big enough that the user
  /// would rather carry on working. Reached from the progress dialog.
  static Future<void> _runBackgroundImportTask(
    BuildContext context,
    ProviderContainer container,
    String filePath,
    String stackName,
    core_stack.Stack? targetStack,
  ) async {
    final taskRegistry = container.read(taskRegistryProvider.notifier);

    final task = Task<ImportOutcome>(
      name: 'Import: $stackName',
      description: 'Importing ${filePath.split('/').last}...',
      executor: (taskContext) async {
        return await CsvImportService.importFileToStack(
          filePath: filePath,
          stackName: stackName,
          container: container,
          targetStack: targetStack,
          onProgress: (progress) {
            taskContext.updateProgress(
              TaskProgress(value: progress, message: 'Importing...'),
            );
          },
        );
      },
      onCompleted: (task) {
        final result = task.result.value;
        if (context.mounted && result is TaskSuccess<ImportOutcome>) {
          _showSuccessDialog(context, result.data);
        }
      },
      onFailed: (task) {
        if (context.mounted) {
          _showErrorDialog(context, 'Import failed: ${task.error}');
        }
      },
    );

    taskRegistry.registerTask(task);
    task.start();
  }

  /// Reports what the import did.
  ///
  /// The skipped counts are spelled out rather than folded into the totals: a
  /// row that was dropped for already being in the graph looks exactly like
  /// one that was imported unless it is named, and someone re-importing an
  /// edited spreadsheet needs to know which happened.
  static void _showSuccessDialog(BuildContext context, ImportOutcome outcome) {
    final lines = <String>[
      'Imported into "${outcome.stack.info.name}".',
      '',
      '${outcome.nodeRows} node rows, ${outcome.linkRows} link rows read.',
    ];
    if (outcome.skippedNodeRows > 0) {
      lines.add(
        '${outcome.skippedNodeRows} nodes were already in the stack and were '
        'left as they were.',
      );
    }
    if (outcome.skippedLinkRows > 0) {
      lines.add(
        '${outcome.skippedLinkRows} links were already in the stack and were '
        'left as they were.',
      );
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Import Complete'),
            content: Text(lines.join('\n')),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  static void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(error),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
