class GraphStatistics {
  const GraphStatistics({
    required this.nodeCount,
    required this.linkCount,
    required this.binaryDataCount,
    required this.nodeLabels,
    required this.linkTypes,
    required this.propertyKeys,
  });
  final int nodeCount;
  final int linkCount;
  final int binaryDataCount;
  final Set<String> nodeLabels;
  final Set<String> linkTypes;
  final Set<String> propertyKeys;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GraphStatistics &&
          runtimeType == other.runtimeType &&
          nodeCount == other.nodeCount &&
          linkCount == other.linkCount &&
          binaryDataCount == other.binaryDataCount &&
          nodeLabels == other.nodeLabels &&
          linkTypes == other.linkTypes &&
          propertyKeys == other.propertyKeys;

  @override
  int get hashCode =>
      nodeCount.hashCode ^
      linkCount.hashCode ^
      binaryDataCount.hashCode ^
      nodeLabels.hashCode ^
      linkTypes.hashCode ^
      propertyKeys.hashCode;
}
