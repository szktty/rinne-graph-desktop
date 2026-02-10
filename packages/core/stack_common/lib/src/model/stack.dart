import 'dart:io';

import 'package:meta/meta.dart';
import 'stack_info.dart';
import 'stack_settings.dart';

/// Class representing an entire stack
@immutable
class Stack {
  /// Creates a stack
  const Stack({
    required this.directory,
    required this.info,
    required this.settings,
    this.isScratch = false,
    this.isAssetBased = false,
  });

  /// Stack directory (.stack)
  final Directory directory;

  /// Basic stack information
  final StackInfo info;

  /// Stack settings information
  final StackSettings settings;

  /// Flag indicating if it's a scratch stack
  final bool isScratch;

  /// Flag indicating if it's an asset-based stack
  final bool isAssetBased;

  /// Whether it is a sample stack (derived from info metadata)
  bool get isSample => info.isSample;

  /// Whether it is pinned
  bool get isPinned => settings.customFields['isPinned'] == true;

  /// Whether it is marked as a favorite
  bool get isFavorite => settings.customFields['isFavorite'] == true;

  /// Whether it is archived
  bool get isArchived => settings.customFields['isArchived'] == true;

  /// Stack file path (graph.db)
  String? get path {
    final graphFile = File('${directory.path}/data/graph.db');
    return graphFile.existsSync() ? graphFile.path : null;
  }

  /// Determines if a stack is a scratch stack
  /// Determined based on directory path
  static bool isPathScratchStack(String path) {
    return path.contains('/RinneGraph/Scratches/');
  }

  /// Creates a copy of the stack and modifies specified fields
  Stack copyWith({
    Directory? directory,
    StackInfo? info,
    StackSettings? settings,
    bool? isScratch,
    bool? isAssetBased,
  }) {
    return Stack(
      directory: directory ?? this.directory,
      info: info ?? this.info,
      settings: settings ?? this.settings,
      isScratch: isScratch ?? this.isScratch,
      isAssetBased: isAssetBased ?? this.isAssetBased,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Stack &&
          runtimeType == other.runtimeType &&
          directory.path == other.directory.path && // Compare by path
          info == other.info &&
          settings == other.settings &&
          isScratch == other.isScratch &&
          isAssetBased == other.isAssetBased;

  @override
  int get hashCode => Object.hash(
    runtimeType,
    directory.path, // Hash by path
    info,
    settings,
    isScratch,
    isAssetBased,
  );

  @override
  String toString() {
    return 'Stack(directory: ${directory.path}, info: $info, '
        'settings: $settings, isScratch: $isScratch, isAssetBased: $isAssetBased)';
  }
}
