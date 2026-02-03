import 'dart:typed_data';
import 'package:core_foundation_common/core_foundation_common.dart';

import 'package:core_graph_common/src/metadata/label_metadata.dart';

/// Abstract interface for label metadata storage
abstract interface class LabelStorage {
  // Basic CRUD operations
  Future<List<LabelMetadata>> getAllLabels();
  Future<LabelMetadata?> getLabel(String name);
  Future<void> saveLabel(LabelMetadata label);
  Future<bool> deleteLabel(String name);

  // Asset management
  Future<UniqueId> saveThumbnailImage(Uint8List imageData);
  Future<Uint8List?> getThumbnailImage(UniqueId imageId);

  // RinneGraph event integration
  Future<void> updateLabelUsageStats(
    String labelName,
    int vertexCount,
    int edgeCount,
  );
  Future<void> markLabelAsUsed(String labelName);
  Future<List<String>> getUnusedLabels();

  // Statistics
  Future<Map<String, int>> getLabelUsageCounts();
  Future<List<LabelMetadata>> getRecentlyUsedLabels({int limit = 10});
}
