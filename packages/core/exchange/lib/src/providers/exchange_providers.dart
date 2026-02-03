import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/stack_exchange_service.dart';

part 'exchange_providers.g.dart';

/// Provider for stack exchange service
@riverpod
StackExchangeService stackExchangeService(StackExchangeServiceRef ref) {
  return StackExchangeService(ref: ref);
}

/// Provider for managing import progress
@riverpod
class ImportProgress extends _$ImportProgress {
  @override
  double build() => 0.0;

  void updateProgress(double progress) {
    state = progress.clamp(0.0, 1.0);
  }

  void reset() {
    state = 0.0;
  }
}

/// Provider for managing import state
@riverpod
class ImportState extends _$ImportState {
  @override
  ImportStatus build() => ImportStatus.idle;

  void setStatus(ImportStatus status) {
    state = status;
  }

  void reset() {
    state = ImportStatus.idle;
  }
}

/// Provider for managing export progress
@riverpod
class ExportProgress extends _$ExportProgress {
  @override
  double build() => 0.0;

  void updateProgress(double progress) {
    state = progress.clamp(0.0, 1.0);
  }

  void reset() {
    state = 0.0;
  }
}

/// Provider for managing export state
@riverpod
class ExportState extends _$ExportState {
  @override
  ExportStatus build() => ExportStatus.idle;

  void setStatus(ExportStatus status) {
    state = status;
  }

  void reset() {
    state = ExportStatus.idle;
  }
}

/// Enumeration for import status
enum ImportStatus {
  /// Idle
  idle,

  /// In progress
  inProgress,

  /// Completed
  completed,

  /// Error
  error,

  /// Cancelled
  cancelled,
}

/// Enumeration for export status
enum ExportStatus {
  /// Idle
  idle,

  /// In progress
  inProgress,

  /// Completed
  completed,

  /// Error
  error,

  /// Cancelled
  cancelled,
}

/// Provider for managing import result
@riverpod
class ImportResult extends _$ImportResult {
  @override
  String? build() => null;

  void setResult(String? result) {
    state = result;
  }

  void clear() {
    state = null;
  }
}

/// Provider for managing export result
@riverpod
class ExportResult extends _$ExportResult {
  @override
  String? build() => null;

  void setResult(String? result) {
    state = result;
  }

  void clear() {
    state = null;
  }
}
