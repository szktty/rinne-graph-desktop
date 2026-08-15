/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_themes/core_themes.dart';
import 'package:presentation_components/presentation_components.dart';

Future<String?> showCsvFilePickerDialog(BuildContext context) async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx'],
      dialogTitle: 'Select a spreadsheet or CSV file',
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final filePath = file.path;
      if (filePath != null) {
        return filePath;
      }
    }
    return null;
  } catch (e) {
    if (context.mounted) {
      showAppDialog(
        context: context,
        width: 400,
        height: 200,
        child: ColorScopeHelper.withDialogScope(
          child: _ErrorDialog(error: e.toString()),
        ),
      );
    }
    return null;
  }
}

class _ErrorDialog extends ConsumerWidget {
  final String error;

  const _ErrorDialog({required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = ref.watch(appColorSchemeProvider);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: colorScheme.status.error),
          const SizedBox(height: 16),
          AppText(
            'File Selection Error',
            variant: AppTextVariant.dialogTitleStandard,
          ),
          const SizedBox(height: 8),
          AppText(
            error,
            variant: AppTextVariant.bodyText,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: AppText('Close', variant: AppTextVariant.buttonLabel),
          ),
        ],
      ),
    );
  }
}
