/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';

class ImportProgressDialog extends ConsumerStatefulWidget {
  final String fileName;
  final Stream<double> progressStream;
  final VoidCallback? onCancel;
  final VoidCallback? onBackground;
  final int? totalFiles;
  final int? currentFileIndex;
  final Duration? elapsedTime;
  final int? processedItems;

  const ImportProgressDialog({
    super.key,
    required this.fileName,
    required this.progressStream,
    this.onCancel,
    this.onBackground,
    this.totalFiles,
    this.currentFileIndex,
    this.elapsedTime,
    this.processedItems,
  });

  @override
  ConsumerState<ImportProgressDialog> createState() =>
      _ImportProgressDialogState();
}

class _ImportProgressDialogState extends ConsumerState<ImportProgressDialog> {
  double _progress = 0.0;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    widget.progressStream.listen(
      (progress) {
        if (mounted) {
          setState(() {
            _progress = progress;
            _isCompleted = progress >= 1.0;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isCompleted = true;
          });
        }
      },
      onDone: () {
        if (mounted) {
          setState(() {
            _isCompleted = true;
          });
        }
      },
    );
  }

  String _formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = ref.watch(effectiveColorSchemeProvider);
    return PopScope(
      canPop: _isCompleted,
      child: ColorScopeHelper.withDialogScope(
        child: AppPage(
          title: _isCompleted ? 'Import Complete' : 'Importing CSV File...',
          titleVariant: AppTextVariant.sectionTitlePrimary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isCompleted ? Icons.check_circle : Icons.upload_file,
                size: 48,
                color:
                    _isCompleted
                        ? appColorScheme.status.success
                        : appColorScheme.base.selection,
              ),
              const SizedBox(height: 16),
              AppText(
                widget.fileName,
                variant: AppTextVariant.bodyText,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // File progress information
              if (widget.totalFiles != null &&
                  widget.currentFileIndex != null) ...[
                AppText(
                  'File ${widget.currentFileIndex! + 1} of ${widget.totalFiles}',
                  variant: AppTextVariant.captionText,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],

              // Progress bar
              if (!_isCompleted) ...[
                SizedBox(
                  width: double.infinity,
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: appColorScheme.base.divider,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      appColorScheme.base.selection,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      '${(_progress * 100).toInt()}%',
                      variant: AppTextVariant.captionText,
                    ),
                    if (widget.elapsedTime != null)
                      AppText(
                        _formatDuration(widget.elapsedTime!),
                        variant: AppTextVariant.captionText,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (widget.processedItems != null)
                  AppText(
                    '${widget.processedItems} items processed',
                    variant: AppTextVariant.captionText,
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 24),
              ],

              // Button row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!_isCompleted && widget.onCancel != null)
                    TextButton(
                      onPressed: widget.onCancel,
                      child: AppText(
                        'Cancel',
                        variant: AppTextVariant.bodyText,
                      ),
                    ),

                  if (!_isCompleted && widget.onBackground != null)
                    TextButton(
                      onPressed: widget.onBackground,
                      child: AppText(
                        'Background',
                        variant: AppTextVariant.bodyText,
                      ),
                    ),

                  if (_isCompleted)
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: AppText('Done', variant: AppTextVariant.bodyText),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showImportProgressDialog({
  required BuildContext context,
  required String fileName,
  required Stream<double> progressStream,
  VoidCallback? onCancel,
  VoidCallback? onBackground,
  int? totalFiles,
  int? currentFileIndex,
  Duration? elapsedTime,
  int? processedItems,
}) {
  showAppDialog(
    context: context,
    barrierDismissible: false,
    width: 500,
    height: 400,
    child: ImportProgressDialog(
      fileName: fileName,
      progressStream: progressStream,
      onCancel: onCancel,
      onBackground: onBackground,
      totalFiles: totalFiles,
      currentFileIndex: currentFileIndex,
      elapsedTime: elapsedTime,
      processedItems: processedItems,
    ),
  );
}
