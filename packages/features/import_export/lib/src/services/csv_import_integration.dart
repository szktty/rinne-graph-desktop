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
  static Future<void> handleCsvImport(
    BuildContext context,
    ProviderContainer container,
  ) async {
    try {
      // 1. Display file selection dialog
      final filePath = await showCsvFilePickerDialog(context);
      if (filePath == null || !context.mounted) return;

      // 2. Display stack name input dialog
      final stackName = await _showStackNameDialog(context, filePath);
      if (stackName == null || !context.mounted) return;

      // 3. Choose whether to display a progress dialog or start a background task
      final useBackgroundTask = await _showImportModeDialog(context);
      if (useBackgroundTask == null || !context.mounted) return;

      if (useBackgroundTask) {
        // Execute as a background task
        await _runBackgroundImportTask(context, container, filePath, stackName);
      } else {
        // Execute with progress dialog
        await _runForegroundImportTask(context, container, filePath, stackName);
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog(context, 'Import Error: $e');
      }
    }
  }

  static Future<String?> _showStackNameDialog(
    BuildContext context,
    String filePath,
  ) async {
    final fileName = filePath.split('/').last.replaceAll('.csv', '');
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

  static Future<bool?> _showImportModeDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Import Method'),
            content: const Text('How do you want to run the import process?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Progress Dialog'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Background'),
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
        _runBackgroundImportTask(context, container, filePath, stackName);
        completer.complete(true);
      },
    );

    // Execute import process
    try {
      await CsvImportService.importCsvToStack(
        filePath: filePath,
        stackName: stackName,
        container: container,
        onProgress: (progress) {
          if (!cancelled) {
            progressController.add(progress);
          }
        },
      );

      if (!cancelled) {
        progressController.add(1.0);
        if (context.mounted) {
          _showSuccessDialog(context, stackName);
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

  static Future<void> _runBackgroundImportTask(
    BuildContext context,
    ProviderContainer container,
    String filePath,
    String stackName,
  ) async {
    final taskRegistry = container.read(taskRegistryProvider.notifier);

    final task = Task<core_stack.Stack?>(
      name: 'CSV import: $stackName',
      description: 'Importing stack from CSV file...',
      executor: (taskContext) async {
        return await CsvImportService.importCsvToStack(
          filePath: filePath,
          stackName: stackName,
          container: container,
          onProgress: (progress) {
            taskContext.updateProgress(
              TaskProgress(value: progress, message: 'Importing...'),
            );
          },
        );
      },
      onCompleted: (task) {
        if (context.mounted) {
          _showSuccessDialog(context, stackName);
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

  static void _showSuccessDialog(BuildContext context, String stackName) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Import Complete'),
            content: Text('Import of stack "$stackName" completed.'),
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
