/// Import result model
class ImportResult {
  final bool success;
  final int entitiesCount;
  final int relationsCount;
  final List<ImportError> errors;
  final List<ImportWarning> warnings;
  final String? stackPath;
  final Duration duration;

  const ImportResult({
    required this.success,
    required this.entitiesCount,
    required this.relationsCount,
    required this.errors,
    required this.warnings,
    this.stackPath,
    required this.duration,
  });

  /// Creates a successful result
  factory ImportResult.success({
    required int entitiesCount,
    required int relationsCount,
    required String stackPath,
    required Duration duration,
    List<ImportWarning> warnings = const [],
  }) {
    return ImportResult(
      success: true,
      entitiesCount: entitiesCount,
      relationsCount: relationsCount,
      errors: const [],
      warnings: warnings,
      stackPath: stackPath,
      duration: duration,
    );
  }

  /// Creates a failed result
  factory ImportResult.failure({
    required List<ImportError> errors,
    required Duration duration,
    List<ImportWarning> warnings = const [],
  }) {
    return ImportResult(
      success: false,
      entitiesCount: 0,
      relationsCount: 0,
      errors: errors,
      warnings: warnings,
      stackPath: null,
      duration: duration,
    );
  }

  /// Check for errors
  bool get hasErrors => errors.isNotEmpty;

  /// Check for warnings
  bool get hasWarnings => warnings.isNotEmpty;

  /// Total processed items
  int get totalProcessed => entitiesCount + relationsCount;
}

/// Import error
class ImportError {
  final ImportErrorType type;
  final String message;
  final int? line;
  final String? column;
  final Map<String, dynamic>? context;

  const ImportError({
    required this.type,
    required this.message,
    this.line,
    this.column,
    this.context,
  });

  /// Creates a file error
  factory ImportError.file(String message) {
    return ImportError(type: ImportErrorType.file, message: message);
  }

  /// Creates a data error
  factory ImportError.data(String message, {int? line, String? column}) {
    return ImportError(
      type: ImportErrorType.data,
      message: message,
      line: line,
      column: column,
    );
  }

  /// Creates a configuration error
  factory ImportError.config(String message) {
    return ImportError(type: ImportErrorType.config, message: message);
  }

  /// Creates a system error
  factory ImportError.system(String message) {
    return ImportError(type: ImportErrorType.system, message: message);
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('[${type.name.toUpperCase()}] ');

    if (line != null) {
      buffer.write('Line $line: ');
    }

    if (column != null) {
      buffer.write('Column $column: ');
    }

    buffer.write(message);

    return buffer.toString();
  }
}

/// Types of import errors
enum ImportErrorType {
  file, // File-related error
  data, // Data-related error
  config, // Configuration-related error
  system, // System error
}

/// Import warning
class ImportWarning {
  final ImportWarningType type;
  final String message;
  final int? line;
  final String? column;

  const ImportWarning({
    required this.type,
    required this.message,
    this.line,
    this.column,
  });

  /// Creates a data conversion warning
  factory ImportWarning.dataConversion(
    String message, {
    int? line,
    String? column,
  }) {
    return ImportWarning(
      type: ImportWarningType.dataConversion,
      message: message,
      line: line,
      column: column,
    );
  }

  /// Creates a missing data warning
  factory ImportWarning.missingData(
    String message, {
    int? line,
    String? column,
  }) {
    return ImportWarning(
      type: ImportWarningType.missingData,
      message: message,
      line: line,
      column: column,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('[Warning] ');

    if (line != null) {
      buffer.write('Line $line: ');
    }

    if (column != null) {
      buffer.write('Column $column: ');
    }

    buffer.write(message);

    return buffer.toString();
  }
}

/// Types of import warnings
enum ImportWarningType {
  dataConversion, // Data conversion warning
  missingData, // Missing data warning
  performance, // Performance warning
}

/// Import progress
class ImportProgress {
  final int completed;
  final int total;
  final String message;
  final ImportProgressStage stage;

  const ImportProgress({
    required this.completed,
    required this.total,
    required this.message,
    required this.stage,
  });

  /// Progress rate (0.0 to 1.0)
  double get progress => total > 0 ? completed / total : 0.0;

  /// Progress rate (percentage)
  int get progressPercent => (progress * 100).round();

  /// Is completed
  bool get isCompleted => completed >= total;
}

/// Import progress stages
enum ImportProgressStage {
  validating, // Validating file
  parsing, // Parsing file
  converting, // Converting data
  creating, // Creating stack
  finalizing, // Finalizing
  completed, // Completed
}

extension ImportProgressStageExtension on ImportProgressStage {
  String get displayName {
    switch (this) {
      case ImportProgressStage.validating:
        return 'Validating file';
      case ImportProgressStage.parsing:
        return 'Parsing file';
      case ImportProgressStage.converting:
        return 'Converting data';
      case ImportProgressStage.creating:
        return 'Creating stack';
      case ImportProgressStage.finalizing:
        return 'Finalizing';
      case ImportProgressStage.completed:
        return 'Completed';
    }
  }
}
