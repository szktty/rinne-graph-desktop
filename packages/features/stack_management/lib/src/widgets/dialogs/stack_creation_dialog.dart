import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:file_picker/file_picker.dart';
import '../../providers/stack_creation_dialog_providers.dart';

/// Result of stack creation dialog
class StackCreationResult {
  final String name;
  final String savePath;

  const StackCreationResult({required this.name, required this.savePath});
}

/// New stack creation dialog
class StackCreationDialog extends ConsumerStatefulWidget {
  /// Callback when the create button is pressed
  final ValueChanged<StackCreationResult> onConfirm;

  /// Initial save path
  final String? initialSavePath;

  const StackCreationDialog({
    super.key,
    required this.onConfirm,
    this.initialSavePath,
  });

  @override
  ConsumerState<StackCreationDialog> createState() =>
      _StackCreationDialogState();
}

class _StackCreationDialogState extends ConsumerState<StackCreationDialog> {
  @override
  void initState() {
    super.initState();
    // Initial value setting
    if (widget.initialSavePath != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(formSavePathStateProvider.notifier)
            .setSavePath(widget.initialSavePath!);
      });
    }
  }

  /// Displays the directory selection dialog
  Future<void> _selectDirectory(Function(String) setSavePath) async {
    final selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select save folder',
    );

    if (selectedDirectory != null) {
      // Convert absolute path to relative path display
      final relativePath = _convertToRelativePath(selectedDirectory);
      setSavePath(relativePath);
    }
  }

  /// Converts absolute path to relative path display
  String _convertToRelativePath(String absolutePath) {
    final homeDir =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (homeDir != null && absolutePath.startsWith(homeDir)) {
      return absolutePath.replaceFirst(homeDir, '~');
    }
    return absolutePath;
  }

  @override
  Widget build(BuildContext context) {
    // Form state management
    final nameText = ref.watch(formNameStateProvider);
    final setNameText = ref.read(formNameStateProvider.notifier).setName;
    final savePathText = ref.watch(formSavePathStateProvider);
    final setSavePathText =
        ref.read(formSavePathStateProvider.notifier).setSavePath;

    // Validation
    final isValidName = nameText.trim().isNotEmpty;
    final isValidSavePath = savePathText.trim().isNotEmpty;
    final canCreate = isValidName && isValidSavePath;

    return AppPage(
      title: 'Create New Stack',
      titleVariant: AppTextVariant.pageTitleMedium,
      shrinkWrap: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Stack name input
          FormItemRow(
            label: 'Stack Name',
            labelWidth: 80,
            spacing: 12,
            child: AppTextField(
              hintText: 'Enter stack name',
              errorText:
                  nameText.trim().isEmpty && nameText.isNotEmpty
                      ? 'Stack name is required'
                      : null,
              onChanged: setNameText,
              autofocus: true,
            ),
          ),
          const AppSpacing.vertical(AppSpacingValues.lg),

          // Save location input
          FormItemRow(
            label: 'Save Location',
            labelWidth: 80,
            spacing: 12,
            child: AppTextField(
              controller: TextEditingController(text: savePathText),
              hintText: 'Select save folder',
              errorText:
                  savePathText.trim().isEmpty && savePathText.isNotEmpty
                      ? 'Save location is required'
                      : null,
              onChanged: setSavePathText,
              readOnly: true, // Prevent manual input
              suffixIcon: SizedBox(
                width:
                    24.0, // Field height 32px - top/bottom padding 8px = 24px
                height: 24.0,
                child: AppIconButton(
                  onPressed: () => _selectDirectory(setSavePathText),
                  icon: Icons.folder_open,
                  tooltip: 'Select folder',
                  alignment: Alignment.center,
                  padding: EdgeInsets.zero,
                  iconSize: 16.0, // Adjust icon size
                  cornerRadius: 12.0, // Set large value for circular shape
                  cornerSmoothing: 1.0, // Set to 1.0 for perfect circle
                ),
              ),
            ),
          ),
          const AppSpacing.vertical(AppSpacingValues.xxl),

          // Buttons (right-aligned)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton.cancel(
                label: 'Cancel',
                onPressed: () => Navigator.of(context).pop(null),
              ),
              const AppSpacing.horizontal(AppSpacingValues.lg),
              AppButton.primary(
                label: 'Create',
                enabled: canCreate,
                onPressed:
                    canCreate
                        ? () {
                          final result = StackCreationResult(
                            name: nameText.trim(),
                            savePath: savePathText.trim(),
                          );

                          Navigator.of(context).pop(result);
                          widget.onConfirm(result);
                        }
                        : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Function to display the new stack creation dialog
Future<StackCreationResult?> showStackCreationDialog({
  required BuildContext context,
  String? initialSavePath,
}) {
  return showAppDialog<StackCreationResult>(
    context: context,
    width: 450,
    child: StackCreationDialog(
      initialSavePath: initialSavePath,
      onConfirm: (result) {
        // Just return the result from the dialog
        Navigator.of(context).pop(result);
      },
    ),
    padding: const EdgeInsets.all(24),
  );
}
