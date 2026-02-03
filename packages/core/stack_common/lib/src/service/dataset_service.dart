import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../model/dataset.dart';
import '../model/stack.dart';

/// Service class for datasets
/// Manages dataset operations within a stack
class DatasetService {
  /// Gets all datasets from the specified stack
  Future<List<Dataset>> getDatasets(Stack stack) async {
    final datasetsDir = Directory('${stack.directory.path}/datasets');

    if (!datasetsDir.existsSync()) {
      return [];
    }

    final datasets = <Dataset>[];
    final files = await datasetsDir.list().toList();

    for (final file in files) {
      if (file is File && file.path.endsWith('.json')) {
        try {
          final dataset = await _loadDatasetFromFile(file);
          if (dataset != null) {
            datasets.add(dataset);
          }
        } catch (e) {
          print('Failed to load dataset from ${file.path}: $e');
        }
      }
    }

    // Sort by creation date (newest first)
    datasets.sort((a, b) => b.created.compareTo(a.created));

    return datasets;
  }

  /// Gets the dataset with the specified ID
  Future<Dataset?> getDataset(Stack stack, String datasetId) async {
    final datasets = await getDatasets(stack);

    try {
      return datasets.firstWhere((dataset) => dataset.id == datasetId);
    } catch (e) {
      return null;
    }
  }

  /// Gets the dataset by dataset name
  Future<Dataset?> getDatasetByName(Stack stack, String name) async {
    final datasets = await getDatasets(stack);

    try {
      return datasets.firstWhere((dataset) => dataset.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Creates a new dataset
  Future<Dataset> createDataset(
    Stack stack,
    String name,
    String description, {
    DatasetFilter? filter,
    Map<String, dynamic> metadata = const {},
  }) async {
    // Check if a dataset with the same name already exists
    final existing = await getDatasetByName(stack, name);
    if (existing != null) {
      throw ArgumentError('Dataset with name "$name" already exists');
    }

    // Create dataset
    final dataset = Dataset.create(
      name: name,
      description: description,
      filter: filter,
      metadata: metadata,
    );

    // Save to file
    await _saveDatasetToFile(stack, dataset);

    return dataset;
  }

  /// Updates a dataset
  Future<Dataset> updateDataset(
    Stack stack,
    String datasetId, {
    String? name,
    String? description,
    DatasetFilter? filter,
    Map<String, dynamic>? metadata,
  }) async {
    final existing = await getDataset(stack, datasetId);
    if (existing == null) {
      throw ArgumentError('Dataset with id "$datasetId" not found');
    }

    // If name changed, check for duplicates
    if (name != null && name != existing.name) {
      final duplicateCheck = await getDatasetByName(stack, name);
      if (duplicateCheck != null && duplicateCheck.id != datasetId) {
        throw ArgumentError('Dataset with name "$name" already exists');
      }
    }

    // Delete existing file
    await _deleteDatasetFile(stack, existing);

    // Create updated dataset
    final updatedDataset = existing.updated(
      name: name,
      description: description,
      filter: filter,
      metadata: metadata,
    );

    // Save to new file
    await _saveDatasetToFile(stack, updatedDataset);

    return updatedDataset;
  }

  /// Deletes a dataset
  Future<bool> deleteDataset(Stack stack, String datasetId) async {
    final dataset = await getDataset(stack, datasetId);
    if (dataset == null) {
      return false;
    }

    try {
      await _deleteDatasetFile(stack, dataset);
      return true;
    } catch (e) {
      print('Failed to delete dataset file: $e');
      return false;
    }
  }

  /// Gets a filtered list of datasets by applying dataset filters
  Future<List<Dataset>> getFilteredDatasets(
    Stack stack, {
    List<String>? entityLabels,
    String? namePattern,
    DateTime? createdAfter,
    DateTime? createdBefore,
  }) async {
    final allDatasets = await getDatasets(stack);

    return allDatasets.where((dataset) {
      // Entity label filter
      if (entityLabels != null && entityLabels.isNotEmpty) {
        if (dataset.filter == null ||
            !dataset.filter!.entityLabels.any(
              (label) => entityLabels.contains(label),
            )) {
          return false;
        }
      }

      // Name pattern filter
      if (namePattern != null && namePattern.isNotEmpty) {
        if (!dataset.name.toLowerCase().contains(namePattern.toLowerCase())) {
          return false;
        }
      }

      // Creation date filter
      if (createdAfter != null && dataset.created.isBefore(createdAfter)) {
        return false;
      }

      if (createdBefore != null && dataset.created.isAfter(createdBefore)) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Gets dataset statistics
  Future<Map<String, dynamic>> getDatasetStatistics(Stack stack) async {
    final datasets = await getDatasets(stack);

    final stats = <String, dynamic>{
      'total': datasets.length,
      'withFilter': datasets.where((d) => d.hasFilter).length,
      'withoutFilter': datasets.where((d) => !d.hasFilter).length,
      'entityLabels': <String>{},
    };

    // Entity label statistics
    final allLabels = <String>{};
    for (final dataset in datasets) {
      if (dataset.filter != null) {
        allLabels.addAll(dataset.filter!.entityLabels);
      }
    }
    stats['entityLabels'] = allLabels.toList()..sort();
    stats['uniqueEntityLabels'] = allLabels.length;

    return stats;
  }

  /// Loads a dataset from a file
  Future<Dataset?> _loadDatasetFromFile(File file) async {
    try {
      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;

      // Generate ID from file name
      final fileName = file.uri.pathSegments.last;
      final id = Dataset.generateIdFromFileName(fileName);

      return Dataset.fromJson(json, id: id);
    } catch (e) {
      print('Error loading dataset from ${file.path}: $e');
      return null;
    }
  }

  /// Saves a dataset to a file
  Future<void> _saveDatasetToFile(Stack stack, Dataset dataset) async {
    final datasetsDir = Directory('${stack.directory.path}/datasets');

    // Create directory if it does not exist
    if (!datasetsDir.existsSync()) {
      await datasetsDir.create(recursive: true);
    }

    final file = File('${datasetsDir.path}/${dataset.fileName}');
    final json = dataset.toJson();

    // ID is generated from the file name, so do not include it in JSON
    final jsonString = const JsonEncoder.withIndent(
      '  ',
    ).convert(json..remove('id'));
    await file.writeAsString(jsonString);
  }

  /// Deletes a dataset file
  Future<void> _deleteDatasetFile(Stack stack, Dataset dataset) async {
    final file = File('${stack.directory.path}/datasets/${dataset.fileName}');

    if (file.existsSync()) {
      await file.delete();
    }
  }

  /// Validates a dataset
  List<String> validateDataset(Dataset dataset) {
    final errors = <String>[];

    if (dataset.name.isEmpty) {
      errors.add('Dataset name cannot be empty');
    }

    if (dataset.description.isEmpty) {
      errors.add('Dataset description cannot be empty');
    }

    // Check for invalid characters for file names
    final invalidChars = RegExp(r'[<>:"/\\|?*]');
    if (invalidChars.hasMatch(dataset.name)) {
      errors.add('Dataset name contains invalid characters for file names');
    }

    return errors;
  }

  /// Duplicates a dataset
  Future<Dataset> duplicateDataset(
    Stack stack,
    String datasetId,
    String newName,
  ) async {
    final original = await getDataset(stack, datasetId);
    if (original == null) {
      throw ArgumentError('Dataset with id "$datasetId" not found');
    }

    // Create duplicate
    return createDataset(
      stack,
      newName,
      '${original.description} (copy)',
      filter: original.filter,
      metadata: Map<String, dynamic>.from(original.metadata),
    );
  }

  /// Gets preset datasets
  List<Dataset> getPresetDatasets() {
    final now = DateTime.now();
    return [
      Dataset(
        id: 'preset_all',
        name: 'All',
        description: 'All data in the stack',
        type: DatasetType.preset,
        created: now,
        metadata: const {'preset_type': 'all'},
      ),
      Dataset(
        id: 'preset_recent',
        name: 'Recent Items',
        description: 'Recently created/edited entities',
        type: DatasetType.preset,
        created: now,
        metadata: const {'preset_type': 'recent', 'days': 7},
      ),
      Dataset(
        id: 'preset_bookmarks',
        name: 'Bookmarks',
        description: 'Bookmarked entities',
        type: DatasetType.preset,
        created: now,
        metadata: const {'preset_type': 'bookmarks'},
      ),
    ];
  }

  /// Gets temporary datasets
  Future<List<Dataset>> getTemporaryDatasets(Stack stack) async {
    final allDatasets = await getDatasets(stack);
    return allDatasets.where((d) => d.type == DatasetType.temporary).toList();
  }

  /// Cleans up expired temporary datasets
  Future<void> cleanupExpiredTemporaryDatasets(
    Stack stack, {
    int maxAgeHours = 24,
  }) async {
    final temporaryDatasets = await getTemporaryDatasets(stack);
    final cutoffTime = DateTime.now().subtract(Duration(hours: maxAgeHours));

    for (final dataset in temporaryDatasets) {
      if (dataset.created.isBefore(cutoffTime)) {
        await deleteDataset(stack, dataset.id);
      }
    }
  }

  /// Creates a temporary dataset from search results
  Future<Dataset> createFromSearchResult(
    Stack stack,
    String name,
    String description,
    List<String> nodeIds,
    List<String> linkIds, {
    Map<String, dynamic>? searchMetadata,
  }) async {
    final metadata = <String, dynamic>{
      'node_ids': nodeIds,
      'link_ids': linkIds,
      'node_count': nodeIds.length,
      'link_count': linkIds.length,
      if (searchMetadata != null) ...searchMetadata,
    };

    return createDataset(stack, name, description, metadata: metadata);
  }

  /// Gets datasets classified by type
  Future<Map<DatasetType, List<Dataset>>> getDatasetsByType(Stack stack) async {
    final savedDatasets = await getDatasets(stack);
    final presetDatasets = getPresetDatasets();
    final temporaryDatasets =
        savedDatasets.where((d) => d.type == DatasetType.temporary).toList();
    final userSavedDatasets =
        savedDatasets.where((d) => d.type == DatasetType.saved).toList();

    return {
      DatasetType.preset: presetDatasets,
      DatasetType.saved: userSavedDatasets,
      DatasetType.temporary: temporaryDatasets,
    };
  }
}
