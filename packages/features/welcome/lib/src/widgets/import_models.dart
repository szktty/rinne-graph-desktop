/// Import mode (handling of custom ID duplicates)
enum ImportMode { add, update, replace, skip }

/// File selection method
enum FileSelectionMode { individual, directory }

/// Validation level
enum ValidationLevel { standard, strict, loose, skip }

/// Error handling policy
enum ErrorHandlingMode { skipAndContinue, stopOnError }

/// Warning display level
enum WarningLevel { all, important, none }

/// Binary file handling method
enum BinaryFileMode { copy, link, ignore }

/// Missing file handling
enum MissingFileMode { warnAndContinue, error, ignore }

/// Duplicate ID handling (Error Options)
enum DuplicateIdHandling { rename, skip, error }

/// Memory usage limit
enum MemoryMode { standard, lowMemory, highSpeed }

/// Property merge method
enum PropertyMergeMode { addToExisting, overwriteExisting }

/// Label merge method
enum LabelMergeMode { merge, replace }

/// File information model
class ImportFileInfo {
  final String fileName;
  final String filePath;
  final int sizeInBytes;
  final ImportFileType type;

  ImportFileInfo({
    required this.fileName,
    required this.filePath,
    required this.sizeInBytes,
    required this.type,
  });

  String get sizeDisplay {
    if (sizeInBytes < 1024) return '$sizeInBytes B';
    if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

enum ImportFileType { csv, json, stack, manifest }

/// Import options configuration
class ImportOptions {
  // Basic settings
  final FileSelectionMode fileSelectionMode;
  final String characterEncoding;
  final String csvDelimiter;
  final bool firstRowIsHeader;

  // Import mode
  final ImportMode importMode;

  // Validation and error handling
  final ValidationLevel validationLevel;
  final ErrorHandlingMode errorHandling;
  final WarningLevel warningLevel;
  final DuplicateIdHandling duplicateIdHandling;

  // Data type handling
  final bool enableTypeConversion;
  final bool typeConversionFailAsError;

  // Binary file handling
  final BinaryFileMode binaryFileMode;
  final List<String> allowedMimeTypes;
  final int maxFileSizeMB;
  final MissingFileMode missingFileMode;
  final bool createPlaceholders;

  // Advanced options
  final MemoryMode memoryMode;
  final PropertyMergeMode propertyMergeMode;
  final LabelMergeMode labelMergeMode;

  // Preview and confirmation
  final bool enableDataPreview;
  final bool showProcessingPlan;

  const ImportOptions({
    this.fileSelectionMode = FileSelectionMode.individual,
    this.characterEncoding = 'Auto-detect',
    this.csvDelimiter = 'Comma',
    this.firstRowIsHeader = true,
    this.importMode = ImportMode.add,
    this.validationLevel = ValidationLevel.standard,
    this.errorHandling = ErrorHandlingMode.skipAndContinue,
    this.warningLevel = WarningLevel.all,
    this.duplicateIdHandling = DuplicateIdHandling.skip,
    this.enableTypeConversion = true,
    this.typeConversionFailAsError = false,
    this.binaryFileMode = BinaryFileMode.copy,
    this.allowedMimeTypes = const [],
    this.maxFileSizeMB = 10,
    this.missingFileMode = MissingFileMode.warnAndContinue,
    this.createPlaceholders = true,
    this.memoryMode = MemoryMode.standard,
    this.propertyMergeMode = PropertyMergeMode.addToExisting,
    this.labelMergeMode = LabelMergeMode.merge,
    this.enableDataPreview = true,
    this.showProcessingPlan = true,
  });

  ImportOptions copyWith({
    FileSelectionMode? fileSelectionMode,
    String? characterEncoding,
    String? csvDelimiter,
    bool? firstRowIsHeader,
    ImportMode? importMode,
    ValidationLevel? validationLevel,
    ErrorHandlingMode? errorHandling,
    WarningLevel? warningLevel,
    DuplicateIdHandling? duplicateIdHandling,
    bool? enableTypeConversion,
    bool? typeConversionFailAsError,
    BinaryFileMode? binaryFileMode,
    List<String>? allowedMimeTypes,
    int? maxFileSizeMB,
    MissingFileMode? missingFileMode,
    bool? createPlaceholders,
    MemoryMode? memoryMode,
    PropertyMergeMode? propertyMergeMode,
    LabelMergeMode? labelMergeMode,
    bool? enableDataPreview,
    bool? showProcessingPlan,
  }) {
    return ImportOptions(
      fileSelectionMode: fileSelectionMode ?? this.fileSelectionMode,
      characterEncoding: characterEncoding ?? this.characterEncoding,
      csvDelimiter: csvDelimiter ?? this.csvDelimiter,
      firstRowIsHeader: firstRowIsHeader ?? this.firstRowIsHeader,
      importMode: importMode ?? this.importMode,
      validationLevel: validationLevel ?? this.validationLevel,
      errorHandling: errorHandling ?? this.errorHandling,
      warningLevel: warningLevel ?? this.warningLevel,
      duplicateIdHandling: duplicateIdHandling ?? this.duplicateIdHandling,
      enableTypeConversion: enableTypeConversion ?? this.enableTypeConversion,
      typeConversionFailAsError:
          typeConversionFailAsError ?? this.typeConversionFailAsError,
      binaryFileMode: binaryFileMode ?? this.binaryFileMode,
      allowedMimeTypes: allowedMimeTypes ?? this.allowedMimeTypes,
      maxFileSizeMB: maxFileSizeMB ?? this.maxFileSizeMB,
      missingFileMode: missingFileMode ?? this.missingFileMode,
      createPlaceholders: createPlaceholders ?? this.createPlaceholders,
      memoryMode: memoryMode ?? this.memoryMode,
      propertyMergeMode: propertyMergeMode ?? this.propertyMergeMode,
      labelMergeMode: labelMergeMode ?? this.labelMergeMode,
      enableDataPreview: enableDataPreview ?? this.enableDataPreview,
      showProcessingPlan: showProcessingPlan ?? this.showProcessingPlan,
    );
  }
}
