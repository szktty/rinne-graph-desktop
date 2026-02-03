import 'dart:async';

import 'package:core_graph_common/src/metadata/label_metadata.dart';
import 'package:core_graph_common/src/metadata/label_storage.dart';
import 'package:rinne_graph/rinne_graph.dart' as rg;

/// RinneGraphのラベルイベントと連携してラベルメタデータを管理するサービス
class LabelService {
  LabelService(this._graph, this._storage) {
    _initializeEventListeners();
  }
  final rg.Graph _graph;
  final LabelStorage _storage;
  final Map<String, LabelUsageStats> _usageStatsCache = {};

  /// イベントリスナーを初期化
  void _initializeEventListeners() {
    // 頂点ラベルイベントを監視
    _graph.onVertexLabelEvent(_handleVertexLabelEvent);

    // エッジラベルイベントを監視
    _graph.onEdgeLabelEvent(_handleEdgeLabelEvent);
  }

  /// 頂点ラベルイベントを処理
  void _handleVertexLabelEvent(rg.VertexLabelEvent event) {
    switch (event.eventType) {
      case rg.LabelEventType.added:
        _onLabelAdded(event.label, isVertex: true);
      case rg.LabelEventType.removed:
        _onLabelRemoved(event.label, isVertex: true);
      case rg.LabelEventType.updated:
        _onLabelUpdated(event.label, isVertex: true);
    }
  }

  /// エッジラベルイベントを処理
  void _handleEdgeLabelEvent(rg.EdgeLabelEvent event) {
    switch (event.eventType) {
      case rg.LabelEventType.added:
        _onLabelAdded(event.label, isVertex: false);
      case rg.LabelEventType.removed:
        _onLabelRemoved(event.label, isVertex: false);
      case rg.LabelEventType.updated:
        _onLabelUpdated(event.label, isVertex: false);
    }
  }

  /// ラベルが追加された時の処理
  Future<void> _onLabelAdded(String labelName, {required bool isVertex}) async {
    // ラベルメタデータが存在しない場合は作成
    await _ensureLabelMetadataExists(labelName);

    // 使用統計を更新
    await _updateUsageStats(labelName);

    // 最終使用日時を更新
    await _storage.markLabelAsUsed(labelName);
  }

  /// ラベルが削除された時の処理
  Future<void> _onLabelRemoved(
    String labelName, {
    required bool isVertex,
  }) async {
    // 使用統計を更新
    await _updateUsageStats(labelName);
  }

  /// ラベルが更新された時の処理
  Future<void> _onLabelUpdated(
    String labelName, {
    required bool isVertex,
  }) async {
    // 最終使用日時を更新
    await _storage.markLabelAsUsed(labelName);
  }

  /// ラベルメタデータが存在することを確認し、存在しない場合は作成
  Future<void> _ensureLabelMetadataExists(String labelName) async {
    final existing = await _storage.getLabel(labelName);
    if (existing == null) {
      // デフォルトのラベルメタデータを作成
      final now = DateTime.now();
      final defaultMetadata = LabelMetadata(
        name: labelName,
        description: '',
        createdAt: now,
        updatedAt: now,
      );
      await _storage.saveLabel(defaultMetadata);
    }
  }

  /// 使用統計を更新
  Future<void> _updateUsageStats(String labelName) async {
    try {
      // RinneGraphから最新の統計情報を取得
      final stats = await _graph.getStatistics();
      final vertexCount = stats.vertexLabelCounts[labelName] ?? 0;
      final edgeCount = stats.edgeLabelCounts[labelName] ?? 0;

      // ストレージに統計情報を更新
      await _storage.updateLabelUsageStats(labelName, vertexCount, edgeCount);

      // キャッシュを更新
      _usageStatsCache[labelName] = LabelUsageStats(
        labelName: labelName,
        vertexCount: vertexCount,
        edgeCount: edgeCount,
        totalCount: vertexCount + edgeCount,
      );
    } catch (e) {
      // TODO: Use logging framework instead of print
      print('ラベル使用統計の更新に失敗: $e');
    }
  }

  /// 全ラベルの使用統計を一括更新
  Future<void> refreshAllUsageStats() async {
    try {
      final stats = await _graph.getStatistics();

      // 全ラベルの統計を更新
      final allLabels = <String>{
        ...stats.vertexLabelCounts.keys,
        ...stats.edgeLabelCounts.keys,
      };

      for (final labelName in allLabels) {
        final vertexCount = stats.vertexLabelCounts[labelName] ?? 0;
        final edgeCount = stats.edgeLabelCounts[labelName] ?? 0;

        await _storage.updateLabelUsageStats(labelName, vertexCount, edgeCount);

        _usageStatsCache[labelName] = LabelUsageStats(
          labelName: labelName,
          vertexCount: vertexCount,
          edgeCount: edgeCount,
          totalCount: vertexCount + edgeCount,
        );
      }
    } catch (e) {
      // TODO: Use logging framework instead of print
      print('全ラベル使用統計の更新に失敗: $e');
    }
  }

  /// キャッシュされた使用統計を取得
  LabelUsageStats? getCachedUsageStats(String labelName) {
    return _usageStatsCache[labelName];
  }

  /// 未使用ラベルを検出
  Future<List<String>> findUnusedLabels() async {
    final allLabels = await _storage.getAllLabels();
    final unusedLabels = <String>[];

    for (final label in allLabels) {
      final stats = _usageStatsCache[label.name];
      if (stats == null || stats.totalCount == 0) {
        unusedLabels.add(label.name);
      }
    }

    return unusedLabels;
  }

  /// リソースを解放
  void dispose() {
    // TODO: RinneGraphのイベントリスナー解除API実装後に対応
    _usageStatsCache.clear();
  }
}

/// ラベル使用統計情報
class LabelUsageStats {
  const LabelUsageStats({
    required this.labelName,
    required this.vertexCount,
    required this.edgeCount,
    required this.totalCount,
  });
  final String labelName;
  final int vertexCount;
  final int edgeCount;
  final int totalCount;

  @override
  String toString() {
    return 'LabelUsageStats(label: $labelName, vertex: $vertexCount, edge: $edgeCount, total: $totalCount)';
  }
}
