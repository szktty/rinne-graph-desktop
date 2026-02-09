import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation_components/presentation_components.dart';
import 'package:core_themes/core_themes.dart';
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:path/path.dart' as path;
import 'package:features_import_export/features_import_export.dart';

import 'import_models.dart';
import 'import_progress_dialog.dart';
import 'target_selection_dialog.dart';

/// Function to show import dialog
void showImportDialog(BuildContext context) {
  final contentKey = GlobalKey<_ImportDialogContentState>();

  showAppDialog(
    context: context,
    title: 'Import',
    subtitle: 'Import data from CSV files, JSON files, or stacks.',
    barrierDismissible: true,
    width: 800,
    height: 800,
    padding: const EdgeInsets.all(32),
    child: ColorScopeHelper.withDialogScope(
      child: ImportDialogContent(key: contentKey, showFooterButtons: false),
    ),
    footer: Consumer(
      builder: (context, ref, _) {
        final colorScheme = ref.watch(effectiveColorSchemeProvider);
        return _ImportDialogFooter(
          colorScheme: colorScheme,
          contentKey: contentKey,
        );
      },
    ),
  );
}

/// Import dialog content
class ImportDialogContent extends ConsumerStatefulWidget {
  /// Whether to show footer buttons (default: true for backward compatibility)
  final bool showFooterButtons;

  const ImportDialogContent({super.key, this.showFooterButtons = true});

  @override
  ConsumerState<ImportDialogContent> createState() =>
      _ImportDialogContentState();
}

class _ImportDialogContentState extends ConsumerState<ImportDialogContent> {
  final List<ImportFileInfo> _selectedFiles = [];
  final ScrollController _scrollController = ScrollController();
  String? _duplicateMessage; // Duplicate file message
  ImportPreview? _importPreview; // Import preview
  bool _isAnalyzing = false; // File analysis flag

  // Target selection
  core_stack.Stack? _targetStack;

  // Import options
  ImportOptions _options = const ImportOptions();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ref.watch(effectiveColorSchemeProvider);
    final textColor = colorScheme.base.foreground;
    final subTextColor = colorScheme.base.foreground.withValues(alpha: 0.7);
    final borderColor = colorScheme.base.border;
    final backgroundColor = colorScheme.uiAreas.dialog.background.withValues(
      alpha: 0.5,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Source -> Target section
        _buildSourceTargetSection(
          colorScheme,
          textColor,
          subTextColor,
          borderColor,
          backgroundColor,
        ),
        const SizedBox(height: 16),

        // Divider
        AppDivider(),

        // Options section
        Expanded(
          child: AppScrollView(
            controller: _scrollController,
            child: Section(
              showDividers: false,
              children: [
                _buildOptionsSection(
                  colorScheme,
                  textColor,
                  subTextColor,
                  borderColor,
                  backgroundColor,
                ),
              ],
            ),
          ),
        ),

        // Buttons (only if showFooterButtons is true)
        if (widget.showFooterButtons) _buildActionButtons(context, colorScheme),
      ],
    );
  }

  Widget _buildSourceTargetSection(
    AppColorScheme colorScheme,
    Color textColor,
    Color subTextColor,
    Color borderColor,
    Color backgroundColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Source
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Sources',
                variant: AppTextVariant.bodyText,
                color: textColor,
              ),
              const SizedBox(height: 8),
              Container(
                height: 170, // Return to fixed height
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount:
                      _selectedFiles.isEmpty ? 1 : _selectedFiles.length + 1,
                  itemBuilder: (context, index) {
                    // If empty or last item, show "Add file" item
                    if (_selectedFiles.isEmpty ||
                        index == _selectedFiles.length) {
                      return _buildAddFileItem(textColor, subTextColor);
                    }

                    // Show normal file item
                    final file = _selectedFiles[index];
                    return _buildFileItem(file, index, textColor, subTextColor);
                  },
                ),
              ),
              // Duplicate file message
              if (_duplicateMessage != null) ...[
                const SizedBox(height: 8),
                _buildDuplicateMessage(textColor, subTextColor),
              ],
            ],
          ),
        ),

        // Arrow with import mode controls
        SizedBox(
          width: 160,
          child: Column(
            mainAxisSize: MainAxisSize.min, // Limit to minimum size
            children: [
              // Space to align with the center of source and target views
              const SizedBox(
                height: 32,
              ), // "Sources"/"Target" text height + spacing
              const SizedBox(
                height: 85,
              ), // Half of container height (170/2) to center the arrow
              // Import mode controls
              Stack(
                children: [
                  Center(
                    child: AppDropdownMenu<String>(
                      initialSelection: _getImportModeString(
                        _options.importMode,
                      ),
                      onSelected:
                          (value) => setState(() {
                            _options = _options.copyWith(
                              importMode: _parseImportMode(value!),
                            );
                          }),
                      disableZoom: false, // Enable zoom support

                      dropdownMenuEntries: [
                        DropdownMenuEntry<String>(
                          value: 'Add',
                          label: 'Add',
                          leadingIcon: Icon(
                            AppIcons.importAdd,
                            size: 16,
                            color: textColor,
                          ),
                        ),
                        DropdownMenuEntry<String>(
                          value: 'Update',
                          label: 'Update',
                          leadingIcon: Icon(
                            AppIcons.importUpdate,
                            size: 16,
                            color: textColor,
                          ),
                        ),
                        DropdownMenuEntry<String>(
                          value: 'Replace',
                          label: 'Replace',
                          leadingIcon: Icon(
                            AppIcons.importReplace,
                            size: 16,
                            color: textColor,
                          ),
                        ),
                        DropdownMenuEntry<String>(
                          value: 'Skip',
                          label: 'Skip',
                          leadingIcon: Icon(
                            AppIcons.x,
                            size: 16,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -4,
                    right: 16,
                    child: IconButton(
                      icon: Icon(
                        AppIcons.info,
                        size: 14,
                        color: textColor.withValues(alpha: 0.7),
                      ),
                      onPressed:
                          () => _showImportModeInfo(
                            context,
                            colorScheme,
                            textColor,
                          ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              AppArrowLine(
                width: 120.0, // Match dropdown menu width
                color: subTextColor,
                direction: ArrowDirection.right,
              ),
            ],
          ),
        ),

        // Target
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'Target',
                variant: AppTextVariant.bodyText,
                color: textColor,
              ),
              const SizedBox(height: 8),
              Container(
                height: 170, // Adjust to same height as source view
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildStackCard(colorScheme, textColor, subTextColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsSection(
    AppColorScheme colorScheme,
    Color textColor,
    Color subTextColor,
    Color borderColor,
    Color backgroundColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildAdvancedOptionsSection(
          colorScheme,
          textColor,
          subTextColor,
          borderColor,
          backgroundColor,
        ),
      ],
    );
  }

  Widget _buildAdvancedOptionsSection(
    AppColorScheme colorScheme,
    Color textColor,
    Color subTextColor,
    Color borderColor,
    Color backgroundColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // CSV Format Options Section
        FormList(
          title: 'CSV Options',
          labelWidth: 150,
          children: [
            FormItemRow(
              label: 'Character Set',
              labelWidth: 150,
              child: AppDropdownMenu<String>(
                initialSelection: _options.characterEncoding,
                onSelected:
                    (value) => setState(() {
                      _options = _options.copyWith(characterEncoding: value!);
                    }),
                dropdownMenuEntries:
                    ['Auto-detect', 'UTF-8', 'Shift-JIS', 'EUC-JP'].map((
                      option,
                    ) {
                      return DropdownMenuEntry<String>(
                        value: option,
                        label: option,
                      );
                    }).toList(),
              ),
            ),
            FormItemRow(
              label: 'Delimiter',
              labelWidth: 150,
              child: AppDropdownMenu<String>(
                initialSelection: _options.csvDelimiter,
                onSelected:
                    (value) => setState(() {
                      _options = _options.copyWith(csvDelimiter: value!);
                    }),
                dropdownMenuEntries:
                    ['Comma', 'Tab', 'Semicolon', 'Pipe'].map((option) {
                      return DropdownMenuEntry<String>(
                        value: option,
                        label: option,
                      );
                    }).toList(),
              ),
            ),
            FormItemRow(
              label: 'CSV Header',
              labelWidth: 150,
              child: Row(
                children: [
                  AppCheckbox(
                    value: _options.firstRowIsHeader,
                    onChanged:
                        (value) => setState(() {
                          _options = _options.copyWith(
                            firstRowIsHeader: value ?? true,
                          );
                        }),
                  ),
                  const SizedBox(width: 8),
                  AppText(
                    'First row contains headers',
                    variant: AppTextVariant.bodyText,
                    color: textColor,
                  ),
                ],
              ),
            ),
          ],
        ),

        AppDivider(),

        // Error Handling Section
        FormList(
          title: 'Error Handling',
          labelWidth: 150,
          children: [
            FormItemRow(
              label: 'Error Handling',
              labelWidth: 150,
              child: AppDropdownMenu<String>(
                initialSelection: _getErrorHandlingString(
                  _options.errorHandling,
                ),
                onSelected:
                    (value) => setState(() {
                      _options = _options.copyWith(
                        errorHandling: _parseErrorHandling(value!),
                      );
                    }),
                dropdownMenuEntries:
                    ['Skip and Continue', 'Stop on Error'].map((option) {
                      return DropdownMenuEntry<String>(
                        value: option,
                        label: option,
                      );
                    }).toList(),
              ),
            ),
          ],
        ),

        AppDivider(),

        // Binary File Options Section
        FormList(
          title: 'Binary File Options',
          labelWidth: 150,
          children: [
            FormItemRow(
              label: 'File Processing',
              labelWidth: 150,
              child: AppDropdownMenu<String>(
                initialSelection: _getBinaryFileModeString(
                  _options.binaryFileMode,
                ),
                onSelected:
                    (value) => setState(() {
                      _options = _options.copyWith(
                        binaryFileMode: _parseBinaryFileMode(value!),
                      );
                    }),
                dropdownMenuEntries:
                    ['Copy', 'Link', 'Ignore'].map((option) {
                      return DropdownMenuEntry<String>(
                        value: option,
                        label: option,
                      );
                    }).toList(),
              ),
            ),
            FormItemRow(
              label: 'Max File Size',
              labelWidth: 150,
              child: AppDropdownMenu<String>(
                initialSelection: '${_options.maxFileSizeMB}MB',
                onSelected:
                    (value) => setState(() {
                      final sizeStr = value!.replaceAll('MB', '');
                      if (sizeStr == 'Unlimited') {
                        _options = _options.copyWith(maxFileSizeMB: -1);
                      } else {
                        _options = _options.copyWith(
                          maxFileSizeMB: int.parse(sizeStr),
                        );
                      }
                    }),
                dropdownMenuEntries:
                    ['10MB', '50MB', '100MB', 'Unlimited'].map((option) {
                      return DropdownMenuEntry<String>(
                        value: option,
                        label: option,
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStackCard(
    AppColorScheme colorScheme,
    Color textColor,
    Color subTextColor, {
    bool showDescription = false,
    bool showStats = false,
  }) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => _showTargetSelectionDialog(),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.uiAreas.sideBar.background,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: colorScheme.base.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.uiAreas.sideBar.activeItemBackground
                      .withValues(alpha: 0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(AppIcons.stacks, size: 20, color: textColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppText(
                        _targetStack?.info.name ?? 'Select stack...',
                        variant: AppTextVariant.bodyText,
                        color:
                            _targetStack != null
                                ? textColor
                                : colorScheme.uiAreas.sideBar.inactiveItemText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      AppIcons.chevronDown,
                      size: 16,
                      color: colorScheme.uiAreas.sideBar.inactiveItemText,
                    ),
                  ],
                ),
              ),
              // Content section (optional)
              if (showDescription || showStats)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showDescription) ...[
                        AppText(
                          'Personal Knowledge Base',
                          variant: AppTextVariant.captionText,
                          color: subTextColor,
                        ),
                        const SizedBox(height: 4),
                      ],
                      if (showStats) ...[
                        AppText(
                          '1,234 nodes • 567 links',
                          variant: AppTextVariant.captionText,
                          color: subTextColor,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildStatChip('Entities', '1,234', colorScheme),
                            const SizedBox(width: 8),
                            _buildStatChip('Links', '567', colorScheme),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTargetSelectionDialog() {
    showTargetSelectionDialog(
      context,
      onStackSelected: (stack) {
        setState(() {
          _targetStack = stack;
        });
      },
      onNewStackSelected: () {
        // Handle new stack creation
        final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
        if (scaffoldMessenger != null) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('New stack creation feature is under development'),
            ),
          );
        }
      },
    );
  }

  Widget _buildStatChip(
    String label,
    String value,
    AppColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.base.border.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            value,
            variant: AppTextVariant.captionText,
            color: colorScheme.base.foreground,
          ),
          AppText(
            label,
            variant: AppTextVariant.captionText,
            color: colorScheme.base.foreground.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AppColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppButton.cancel(
          label: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: 16),
        AppButton.primary(
          label: 'Import',
          onPressed: _selectedFiles.isEmpty ? null : handleImport,
        ),
      ],
    );
  }

  /// Build duplicate file message
  Widget _buildDuplicateMessage(Color textColor, Color subTextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(
            AppIcons.info,
            size: 14,
            color: subTextColor.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: AppText(
              _duplicateMessage!,
              variant: AppTextVariant.bodyText,
              color: subTextColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Build add file item
  Widget _buildAddFileItem(Color textColor, Color subTextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: _DragDropArea(
        onTap: _addFiles,
        onFilesDropped: _handleFilesDropped,
        child:
            (isHovered, isDragOver) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      isDragOver
                          ? textColor.withValues(alpha: 0.6)
                          : isHovered
                          ? subTextColor.withValues(alpha: 0.5)
                          : subTextColor.withValues(alpha: 0.3),
                  width: isDragOver ? 2 : 1,
                  style: BorderStyle.solid,
                ),
                color:
                    isDragOver
                        ? textColor.withValues(alpha: 0.05)
                        : isHovered
                        ? subTextColor.withValues(alpha: 0.02)
                        : null,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    AppIcons.import,
                    size: 18,
                    color:
                        isDragOver
                            ? textColor.withValues(alpha: 0.8)
                            : subTextColor.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    AppIcons.plus,
                    size: 16,
                    color:
                        isDragOver
                            ? textColor.withValues(alpha: 0.8)
                            : subTextColor.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppText(
                      _selectedFiles.isEmpty
                          ? 'Drag files here or click to add'
                          : 'Drag more files here or click to add',
                      variant: AppTextVariant.bodyText,
                      color:
                          isDragOver
                              ? textColor.withValues(alpha: 0.8)
                              : subTextColor.withValues(alpha: 0.8),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  /// Build file item
  Widget _buildFileItem(
    ImportFileInfo file,
    int index,
    Color textColor,
    Color subTextColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(_getFileIcon(file.type), size: 16, color: subTextColor),
          const SizedBox(width: 8),
          Expanded(
            child: AppText(
              file.fileName,
              variant: AppTextVariant.bodyText,
              color: textColor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          AppText(
            '(${file.sizeDisplay})',
            variant: AppTextVariant.captionText,
            color: subTextColor,
          ),
          const SizedBox(width: 8),
          AppIconButton(
            onPressed: () {
              setState(() {
                _selectedFiles.removeAt(index);
              });
            },
            icon: AppIcons.x,
            iconSize: 16,
            iconColor: subTextColor,
            tooltip: 'Remove file',
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(ImportFileType type) {
    switch (type) {
      case ImportFileType.csv:
        return AppIcons.table;
      case ImportFileType.json:
        return AppIcons.fileText;
      case ImportFileType.stack:
        return AppIcons.stacks;
      case ImportFileType.manifest:
        return AppIcons.settings;
    }
  }

  /// Process single file
  Future<void> _processFile(File file, String fileName) async {
    try {
      final fileStat = await file.stat();
      final extension = path.extension(file.path).toLowerCase();

      ImportFileType fileType;
      switch (extension) {
        case '.csv':
          fileType = ImportFileType.csv;
          break;
        case '.json':
          fileType = ImportFileType.json;
          break;
        case '.rinne_graph_desktop':
          fileType = ImportFileType.stack;
          break;
        default:
          return; // Skip unsupported files
      }

      // Duplicate check: ignore if file with same path already exists
      final isDuplicate = _selectedFiles.any(
        (existingFile) => existingFile.filePath == file.path,
      );

      if (!isDuplicate) {
        final fileInfo = ImportFileInfo(
          fileName: fileName,
          filePath: file.path,
          sizeInBytes: fileStat.size,
          type: fileType,
        );

        setState(() {
          _selectedFiles.add(fileInfo);
          _duplicateMessage = null; // Clear message on success
        });
      } else {
        // Show duplicate file message (only for single file)
        // For multiple files, show combined message in _handleDroppedFiles
        if (_duplicateMessage?.contains('file(s)') != true) {
          setState(() {
            _duplicateMessage = 'File "$fileName" is already added';
          });
        }
      }
    } catch (e) {
      // Ignore errors (e.g., file cannot be read)
    }
  }

  void _addFiles() async {
    // Clear message when showing file dialog
    setState(() {
      _duplicateMessage = null;
    });

    try {
      final result = await file_picker.FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: file_picker.FileType.custom,
        allowedExtensions: ['csv', 'json', 'rinne_graph_desktop'],
        dialogTitle:
            'Select files to import\n\nSupported files:\n• CSV files (.csv) - Import data in table format\n• JSON files (.json) - Import structured data\n• App stack files (.rinne_graph_desktop) - Import existing stacks',
      );

      if (result != null && result.files.isNotEmpty) {
        for (final platformFile in result.files) {
          if (platformFile.path != null) {
            final file = File(platformFile.path!);
            await _processFile(file, platformFile.name);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
        if (scaffoldMessenger != null) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('File selection error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showImportModeInfo(
    BuildContext context,
    AppColorScheme colorScheme,
    Color textColor,
  ) {
    showAppDialog(
      context: context,
      width: 600,
      height: 400,
      child: _ImportModeInfoDialog(
        colorScheme: colorScheme,
        textColor: textColor,
      ),
    );
  }

  // Helper methods for enum conversions
  String _getImportModeString(ImportMode mode) {
    switch (mode) {
      case ImportMode.add:
        return 'Add';
      case ImportMode.update:
        return 'Update';
      case ImportMode.replace:
        return 'Replace';
      case ImportMode.skip:
        return 'Skip';
    }
  }

  ImportMode _parseImportMode(String value) {
    switch (value) {
      case 'Add':
        return ImportMode.add;
      case 'Update':
        return ImportMode.update;
      case 'Replace':
        return ImportMode.replace;
      case 'Skip':
        return ImportMode.skip;
      default:
        return ImportMode.add;
    }
  }

  String _getErrorHandlingString(ErrorHandlingMode handling) {
    switch (handling) {
      case ErrorHandlingMode.skipAndContinue:
        return 'Skip and Continue';
      case ErrorHandlingMode.stopOnError:
        return 'Stop on Error';
    }
  }

  ErrorHandlingMode _parseErrorHandling(String value) {
    switch (value) {
      case 'Skip and Continue':
        return ErrorHandlingMode.skipAndContinue;
      case 'Stop on Error':
        return ErrorHandlingMode.stopOnError;
      default:
        return ErrorHandlingMode.skipAndContinue;
    }
  }

  String _getBinaryFileModeString(BinaryFileMode mode) {
    switch (mode) {
      case BinaryFileMode.copy:
        return 'Copy';
      case BinaryFileMode.link:
        return 'Link';
      case BinaryFileMode.ignore:
        return 'Ignore';
    }
  }

  BinaryFileMode _parseBinaryFileMode(String value) {
    switch (value) {
      case 'Copy':
        return BinaryFileMode.copy;
      case 'Link':
        return BinaryFileMode.link;
      case 'Ignore':
        return BinaryFileMode.ignore;
      default:
        return BinaryFileMode.copy;
    }
  }

  /// Handle import action (public for access from footer)
  void handleImport() async {
    if (_selectedFiles.isEmpty) return;

    // Close the import dialog first
    Navigator.of(context).pop();

    try {
      // Show progress dialog
      _showImportProgressDialog();
    } catch (e) {
      if (mounted) {
        final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
        if (scaffoldMessenger != null) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Import error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showImportProgressDialog() {
    showAppDialog(
      context: context,
      barrierDismissible: false,
      width: 500,
      height: 400,
      child: ImportProgressDialogContent(
        files: _selectedFiles,
        targetStack: _targetStack,
        options: _options,
      ),
    );
  }

  /// ファイルドロップ処理（新しいサービスを使用）
  Future<void> _handleFilesDropped(List<XFile> files) async {
    if (files.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
      _importPreview = null;
    });

    try {
      // ファイルを解析
      final analysis = await FileDropService.analyzeDroppedFiles(files);

      if (!analysis.hasProcessableFiles) {
        setState(() {
          _isAnalyzing = false;
        });
        _showErrorDialog('No processable files found.');
        return;
      }

      // インポートプレビューを生成
      ImportPreview preview;
      switch (analysis.importMethod) {
        case ImportMethod.manifest:
          preview = await FileDropService.generateManifestPreview(
            analysis.manifestFiles.first,
          );
          break;
        case ImportMethod.csv:
          preview = await FileDropService.generateCsvPreview(analysis.csvFiles);
          break;
        default:
          preview = ImportPreview.error('Unsupported file format');
      }

      setState(() {
        _importPreview = preview;
        _isAnalyzing = false;
      });

      // エラーがある場合は表示
      if (preview.hasError) {
        _showErrorDialog(preview.error!);
      } else if (preview.hasWarnings) {
        _showWarningDialog(preview.warnings);
      }
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      _showErrorDialog('An error occurred during file analysis: $e');
    }
  }

  /// エラーダイアログを表示
  void _showErrorDialog(String message) {
    showAppDialog(
      context: context,
      title: 'Error',
      subtitle: message,
      barrierDismissible: true,
      child: const SizedBox.shrink(),
    );
  }

  /// 警告ダイアログを表示
  void _showWarningDialog(List<String> warnings) {
    showAppDialog(
      context: context,
      title: 'Warning',
      subtitle: '以下の警告があります：\n${warnings.join('\n')}',
      barrierDismissible: true,
      child: const SizedBox.shrink(),
    );
  }
}

class _ImportModeInfoDialog extends StatelessWidget {
  final AppColorScheme colorScheme;
  final Color textColor;

  const _ImportModeInfoDialog({
    required this.colorScheme,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText(
            'About Import Mode (Custom ID Duplication Handling)',
            variant: AppTextVariant.sectionTitlePrimary,
            color: textColor,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModeExplanation(
                    icon: AppIcons.importAdd,
                    title: '追加 (Add)',
                    description: 'Add all data as new data',
                    details: [
                      'Even if custom IDs are duplicated, new system IDs are automatically assigned and created',
                      'Existing data remains as is',
                      'Used when you want to add new information to the stack',
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildModeExplanation(
                    icon: AppIcons.importUpdate,
                    title: '更新 (Update)',
                    description:
                        'Update existing data. Unspecified properties are maintained',
                    details: [
                      'Partially update properties of existing data',
                      'If custom ID does not exist, add as new',
                      'Unspecified properties are maintained',
                      'Suitable for partial updates of existing data',
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildModeExplanation(
                    icon: AppIcons.importReplace,
                    title: '置換 (Replace)',
                    description:
                        'Replace existing data. Unspecified properties are deleted',
                    details: [
                      'Completely replace properties of existing data',
                      'If custom ID does not exist, add as new',
                      '指定されていないプロパティは削除される',
                      'Caution: Original data will be lost',
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildModeExplanation(
                    icon: AppIcons.x,
                    title: 'スキップ (Skip)',
                    description: 'Do not update if existing data is present',
                    details: [
                      'Skip import if custom ID is duplicated',
                      'Add new only if custom ID does not exist',
                      'Used when you want to protect existing data',
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton.primary(
                label: 'Close',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeExplanation({
    required IconData icon,
    required String title,
    required String description,
    required List<String> details,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.uiAreas.dialog.background,
        border: Border.all(color: colorScheme.base.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: textColor),
              const SizedBox(width: 12),
              AppText(
                title,
                variant: AppTextVariant.itemTitle,
                color: textColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppText(
            description,
            variant: AppTextVariant.bodyText,
            color: textColor,
          ),
          const SizedBox(height: 12),
          ...details.map(
            (detail) => Padding(
              padding: const EdgeInsets.only(left: 36, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    '• ',
                    variant: AppTextVariant.bodyText,
                    color: textColor.withValues(alpha: 0.7),
                  ),
                  Expanded(
                    child: AppText(
                      detail,
                      variant: AppTextVariant.bodyText,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ドラッグ&ドロップエリアウィジェット
class _DragDropArea extends StatefulWidget {
  final VoidCallback onTap;
  final Widget Function(bool isHovered, bool isDragOver) child;
  final Function(List<XFile>)? onFilesDropped;

  const _DragDropArea({
    required this.onTap,
    required this.child,
    this.onFilesDropped,
  });

  @override
  State<_DragDropArea> createState() => _DragDropAreaState();
}

class _DragDropAreaState extends State<_DragDropArea> {
  bool _isHovered = false;
  bool _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) {
        setState(() => _isDragOver = false);
        if (widget.onFilesDropped != null) {
          widget.onFilesDropped!(detail.files);
        }
      },
      onDragEntered: (detail) {
        setState(() => _isDragOver = true);
      },
      onDragExited: (detail) {
        setState(() => _isDragOver = false);
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: widget.child(_isHovered, _isDragOver),
        ),
      ),
    );
  }
}

/// Footer widget for import dialog
class _ImportDialogFooter extends ConsumerWidget {
  final AppColorScheme colorScheme;
  final GlobalKey<_ImportDialogContentState> contentKey;

  const _ImportDialogFooter({
    required this.colorScheme,
    required this.contentKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.base.border, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacingValues.xl), // 20px
            child: AppButton.cancel(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacingValues.xl,
              right: AppSpacingValues.xl,
              bottom: AppSpacingValues.xl,
            ),
            child: AppButton.primary(
              label: 'Import',
              onPressed: () {
                // Access the state through GlobalKey and trigger import
                contentKey.currentState?.handleImport();
              },
            ),
          ),
        ],
      ),
    );
  }
}
