/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

/// Import configuration model
class ImportConfig {
  final ImportType type;
  final String filePath;
  final Map<String, dynamic> metadata;
  final CsvMapping? csvMapping;
  final List<String> selectedColumns;
  final bool validateData;

  const ImportConfig({
    required this.type,
    required this.filePath,
    required this.metadata,
    this.csvMapping,
    this.selectedColumns = const [],
    this.validateData = true,
  });

  ImportConfig copyWith({
    ImportType? type,
    String? filePath,
    Map<String, dynamic>? metadata,
    CsvMapping? csvMapping,
    List<String>? selectedColumns,
    bool? validateData,
  }) {
    return ImportConfig(
      type: type ?? this.type,
      filePath: filePath ?? this.filePath,
      metadata: metadata ?? this.metadata,
      csvMapping: csvMapping ?? this.csvMapping,
      selectedColumns: selectedColumns ?? this.selectedColumns,
      validateData: validateData ?? this.validateData,
    );
  }
}

/// Types of import files
enum ImportType { csv, json, yaml }

/// CSV mapping settings
class CsvMapping {
  final String? idColumn;
  final List<String> labelColumns;
  final List<String> propertyColumns;
  final String? sourceColumn;
  final String? targetColumn;
  final String? typeColumn;

  const CsvMapping({
    this.idColumn,
    this.labelColumns = const [],
    this.propertyColumns = const [],
    this.sourceColumn,
    this.targetColumn,
    this.typeColumn,
  });

  CsvMapping copyWith({
    String? idColumn,
    List<String>? labelColumns,
    List<String>? propertyColumns,
    String? sourceColumn,
    String? targetColumn,
    String? typeColumn,
  }) {
    return CsvMapping(
      idColumn: idColumn ?? this.idColumn,
      labelColumns: labelColumns ?? this.labelColumns,
      propertyColumns: propertyColumns ?? this.propertyColumns,
      sourceColumn: sourceColumn ?? this.sourceColumn,
      targetColumn: targetColumn ?? this.targetColumn,
      typeColumn: typeColumn ?? this.typeColumn,
    );
  }
}

/// Types of data to import
enum ImportDataType { entities, relations, mixed }
