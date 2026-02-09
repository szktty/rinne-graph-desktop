import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;

import 'import_models.dart';

/// インポートプログレスダイアログのコンテンツ
class ImportProgressDialogContent extends ConsumerStatefulWidget {
  final List<ImportFileInfo> files;
  final core_stack.Stack? targetStack;
  final ImportOptions options;

  const ImportProgressDialogContent({
    super.key,
    required this.files,
    this.targetStack,
    required this.options,
  });

  @override
  ConsumerState<ImportProgressDialogContent> createState() =>
      _ImportProgressDialogContentState();
}

class _ImportProgressDialogContentState
    extends ConsumerState<ImportProgressDialogContent> {
  bool _isImporting = true;
  bool _isCompleted = false;
  bool _isCancelled = false;
  double _currentProgress = 0.0;
  int _currentFileIndex = 0;
  String _currentFileName = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startImport();
  }

  void _startImport() async {
    try {
      for (int i = 0; i < widget.files.length; i++) {
        if (_isCancelled) break;

        final file = widget.files[i];
        setState(() {
          _currentFileIndex = i;
          _currentFileName = file.fileName;
          _currentProgress = 0.0;
        });

        // Simulate import progress for each file
        await _importFile(file);

        if (!_isCancelled) {
          setState(() {
            _currentProgress = 1.0;
          });

          // Small delay before next file
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      if (!_isCancelled) {
        setState(() {
          _isImporting = false;
          _isCompleted = true;
        });
      }
    } catch (e) {
      setState(() {
        _isImporting = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _importFile(ImportFileInfo file) async {
    // Simulate file import with progress updates
    for (int i = 0; i <= 100; i += 10) {
      if (_isCancelled) break;

      setState(() {
        _currentProgress = i / 100.0;
      });

      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void _cancelImport() {
    setState(() {
      _isCancelled = true;
      _isImporting = false;
    });
  }

  void _closeDialog() {
    Navigator.of(context).pop();

    // Navigate back to welcome screen
    if (_isCompleted) {
      // Show success message using maybeOf to handle cases where ScaffoldMessenger is not available
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
      if (scaffoldMessenger != null) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Import complete'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);
    final textColor = colorScheme.base.foreground;
    final subTextColor = colorScheme.base.foreground.withValues(alpha: 0.7);

    return AppPage(
      title: _isCompleted ? 'Import Complete' : 'Importing Files',
      titleVariant: AppTextVariant.pageTitleLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status Icon
          Center(
            child: Icon(
              _isCompleted
                  ? AppIcons.check
                  : _isCancelled
                  ? AppIcons.x
                  : AppIcons.import,
              size: 64,
              color:
                  _isCompleted
                      ? Colors.green
                      : _isCancelled
                      ? Colors.red
                      : colorScheme.base.foreground,
            ),
          ),
          const SizedBox(height: 24),

          // Current file info
          if (_isImporting || _isCompleted) ...[
            AppText(
              'File ${_currentFileIndex + 1} of ${widget.files.length}',
              variant: AppTextVariant.bodyText,
              color: subTextColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            AppText(
              _currentFileName,
              variant: AppTextVariant.bodyText,
              color: textColor,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
          ],

          // Progress bar
          if (_isImporting) ...[
            LinearProgressIndicator(
              value: _currentProgress,
              backgroundColor: colorScheme.base.border.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                colorScheme.base.foreground,
              ),
            ),
            const SizedBox(height: 8),
            AppText(
              '${(_currentProgress * 100).toInt()}%',
              variant: AppTextVariant.captionText,
              color: subTextColor,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],

          // Error message
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              child: AppText(
                _errorMessage!,
                variant: AppTextVariant.bodyText,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
          ],

          const Spacer(),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_isImporting)
                AppButton(
                  label: 'Cancel',
                  onPressed: _cancelImport,
                  textColor: colorScheme.base.foreground,
                ),
              if (_isCompleted || _isCancelled || _errorMessage != null)
                AppButton.primary(label: 'OK', onPressed: _closeDialog),
            ],
          ),
        ],
      ),
    );
  }
}
