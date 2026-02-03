import 'package:core_stack/src/model/dataset.dart';
import 'package:core_stack/src/model/stack.dart';
import 'package:core_stack/src/service/dataset_service.dart';

/// Class representing the result of a dataset API operation
class DatasetApiResult<T> {
  const DatasetApiResult._({
    required this.success,
    this.data,
    this.error,
    this.errorCode,
  });

  factory DatasetApiResult.success(T data) =>
      DatasetApiResult._(success: true, data: data);

  factory DatasetApiResult.error(String error, {String? errorCode}) =>
      DatasetApiResult._(success: false, error: error, errorCode: errorCode);
  final bool success;
  final T? data;
  final String? error;
  final String? errorCode;

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (data != null) 'data': _dataToJson(data),
      if (error != null) 'error': error,
      if (errorCode != null) 'errorCode': errorCode,
    };
  }

  dynamic _dataToJson(dynamic data) {
    if (data is Dataset) {
      return data.toJson();
    } else if (data is List<Dataset>) {
      return data.map((d) => d.toJson()).toList();
    } else if (data is Map ||
        data is List ||
        data is String ||
        data is int ||
        data is double ||
        data is bool) {
      return data;
    } else {
      return data.toString();
    }
  }
}

/// Class providing dataset API operations
class DatasetApi {
  DatasetApi({DatasetService? datasetService})
    : _datasetService = datasetService ?? DatasetService();
  final DatasetService _datasetService;

  /// Retrieves all datasets from a stack
  Future<DatasetApiResult<List<Dataset>>> listDatasets(Stack stack) async {
    try {
      final datasets = await _datasetService.getDatasets(stack);
      return DatasetApiResult.success(datasets);
    } catch (e) {
      return DatasetApiResult.error(
        'Failed to list datasets: $e',
        errorCode: 'DATASET_LIST_ERROR',
      );
    }
  }

  /// Retrieves a dataset by its specified ID
  Future<DatasetApiResult<Dataset>> getDataset(
    Stack stack,
    String datasetId,
  ) async {
    try {
      final dataset = await _datasetService.getDataset(stack, datasetId);
      if (dataset == null) {
        return DatasetApiResult.error(
          'Dataset not found: $datasetId',
          errorCode: 'DATASET_NOT_FOUND',
        );
      }
      return DatasetApiResult.success(dataset);
    } catch (e) {
      return DatasetApiResult.error(
        'Failed to get dataset: $e',
        errorCode: 'DATASET_GET_ERROR',
      );
    }
  }

  /// Retrieves a dataset by its name
  Future<DatasetApiResult<Dataset>> getDatasetByName(
    Stack stack,
    String name,
  ) async {
    try {
      final dataset = await _datasetService.getDatasetByName(stack, name);
      if (dataset == null) {
        return DatasetApiResult.error(
          'Dataset not found: $name',
          errorCode: 'DATASET_NOT_FOUND',
        );
      }
      return DatasetApiResult.success(dataset);
    } catch (e) {
      return DatasetApiResult.error(
        'Failed to get dataset by name: $e',
        errorCode: 'DATASET_GET_ERROR',
      );
    }
  }

  /// Creates a new dataset
  Future<DatasetApiResult<Dataset>> createDataset(
    Stack stack, {
    required String name,
    required String description,
    DatasetFilter? filter,
    Map<String, dynamic> metadata = const {},
  }) async {
    try {
      // Input validation
      if (name.trim().isEmpty) {
        return DatasetApiResult.error(
          'Dataset name cannot be empty',
          errorCode: 'INVALID_INPUT',
        );
      }

      if (description.trim().isEmpty) {
        return DatasetApiResult.error(
          'Dataset description cannot be empty',
          errorCode: 'INVALID_INPUT',
        );
      }

      final dataset = await _datasetService.createDataset(
        stack,
        name.trim(),
        description.trim(),
        filter: filter,
        metadata: metadata,
      );

      return DatasetApiResult.success(dataset);
    } on ArgumentError catch (e) {
      return DatasetApiResult.error(
        e.toString(),
        errorCode: 'DATASET_ALREADY_EXISTS',
      );
    } catch (e) {
      return DatasetApiResult.error(
        'Failed to create dataset: $e',
        errorCode: 'DATASET_CREATE_ERROR',
      );
    }
  }

  /// Updates a dataset
  Future<DatasetApiResult<Dataset>> updateDataset(
    Stack stack,
    String datasetId, {
    String? name,
    String? description,
    DatasetFilter? filter,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Input validation
      if (name != null && name.trim().isEmpty) {
        return DatasetApiResult.error(
          'Dataset name cannot be empty',
          errorCode: 'INVALID_INPUT',
        );
      }

      if (description != null && description.trim().isEmpty) {
        return DatasetApiResult.error(
          'Dataset description cannot be empty',
          errorCode: 'INVALID_INPUT',
        );
      }

      final dataset = await _datasetService.updateDataset(
        stack,
        datasetId,
        name: name?.trim(),
        description: description?.trim(),
        filter: filter,
        metadata: metadata,
      );

      return DatasetApiResult.success(dataset);
    } on ArgumentError catch (e) {
      final message = e.toString();
      return DatasetApiResult.error(
        message,
        errorCode:
            message.contains('not found')
                ? 'DATASET_NOT_FOUND'
                : 'DATASET_ALREADY_EXISTS',
      );
    } catch (e) {
      return DatasetApiResult.error(
        'Failed to update dataset: $e',
        errorCode: 'DATASET_UPDATE_ERROR',
      );
    }
  }

  /// Deletes a dataset
  Future<DatasetApiResult<bool>> deleteDataset(
    Stack stack,
    String datasetId,
  ) async {
    try {
      final success = await _datasetService.deleteDataset(stack, datasetId);
      if (!success) {
        return DatasetApiResult.error(
          'Dataset not found: $datasetId',
          errorCode: 'DATASET_NOT_FOUND',
        );
      }
      return DatasetApiResult.success(true);
    } catch (e) {
      return DatasetApiResult.error(
        'Failed to delete dataset: $e',
        errorCode: 'DATASET_DELETE_ERROR',
      );
    }
  }

  /// Searches for datasets based on filter conditions
  Future<DatasetApiResult<List<Dataset>>> searchDatasets(
    Stack stack, {
    List<String>? entityLabels,
    String? namePattern,
    DateTime? createdAfter,
    DateTime? createdBefore,
  }) async {
    try {
      final datasets = await _datasetService.getFilteredDatasets(
        stack,
        entityLabels: entityLabels,
        namePattern: namePattern,
        createdAfter: createdAfter,
        createdBefore: createdBefore,
      );
      return DatasetApiResult.success(datasets);
    } catch (e) {
      return DatasetApiResult.error(
        'Failed to search datasets: $e',
        errorCode: 'DATASET_SEARCH_ERROR',
      );
    }
  }

  /// Retrieves dataset statistics
  Future<DatasetApiResult<Map<String, dynamic>>> getDatasetStatistics(
    Stack stack,
  ) async {
    try {
      final stats = await _datasetService.getDatasetStatistics(stack);
      return DatasetApiResult.success(stats);
    } catch (e) {
      return DatasetApiResult.error(
        'Failed to get dataset statistics: $e',
        errorCode: 'DATASET_STATS_ERROR',
      );
    }
  }

  /// Validates a dataset
  DatasetApiResult<List<String>> validateDataset(Dataset dataset) {
    try {
      final errors = _datasetService.validateDataset(dataset);
      return DatasetApiResult.success(errors);
    } catch (e) {
      return DatasetApiResult.error(
        'Failed to validate dataset: $e',
        errorCode: 'DATASET_VALIDATION_ERROR',
      );
    }
  }

  /// Duplicates a dataset
  Future<DatasetApiResult<Dataset>> duplicateDataset(
    Stack stack,
    String datasetId,
    String newName,
  ) async {
    try {
      if (newName.trim().isEmpty) {
        return DatasetApiResult.error(
          'New dataset name cannot be empty',
          errorCode: 'INVALID_INPUT',
        );
      }

      final dataset = await _datasetService.duplicateDataset(
        stack,
        datasetId,
        newName.trim(),
      );

      return DatasetApiResult.success(dataset);
    } on ArgumentError catch (e) {
      final message = e.toString();
      return DatasetApiResult.error(
        message,
        errorCode:
            message.contains('not found')
                ? 'DATASET_NOT_FOUND'
                : 'DATASET_ALREADY_EXISTS',
      );
    } catch (e) {
      return DatasetApiResult.error(
        'Failed to duplicate dataset: $e',
        errorCode: 'DATASET_DUPLICATE_ERROR',
      );
    }
  }

  /// Creates DatasetFilter from JSON request
  static DatasetFilter? parseFilterFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    try {
      return DatasetFilter.fromJson(json);
    } catch (e) {
      throw ArgumentError('Invalid filter format: $e');
    }
  }

  /// Parses DateTime from JSON request
  static DateTime? parseDateTimeFromJson(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        throw ArgumentError('Invalid datetime format: $value');
      }
    }

    throw ArgumentError('DateTime must be a string: $value');
  }
}
