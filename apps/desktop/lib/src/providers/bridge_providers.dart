import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:core_foundation_flutter/core_foundation_flutter.dart'
    as core_foundation;

part 'bridge_providers.g.dart';

/// Bridge provider for desktop app
/// Bridges existing capsules and Riverpod providers

/// Provider that provides GraphStorage implementation
@riverpod
core_graph.GraphStorage desktopGraphStorage(DesktopGraphStorageRef ref) {
  // GraphStorage implementation for desktop app
  // Actual implementation is overridden at app startup
  throw UnimplementedError(
    'desktopGraphStorage must be implemented at startup',
  );
}

/// Provider that provides StackSearchDirectory implementation
@riverpod
Future<Directory> desktopStackSearchDirectory(
  DesktopStackSearchDirectoryRef ref,
) async {
  final fileSystemOps = core_foundation.FileSystemService();
  return await fileSystemOps.getApplicationDocumentsDirectory();
}

/// Provides application-specific GraphStorageProvider override
@riverpod
core_graph.GraphStorage? overriddenGraphStorage(OverriddenGraphStorageRef ref) {
  // This provider is overridden at startup
  return null;
}

/// GraphContext provider for desktop app
@riverpod
core_graph.GraphContext? desktopGraphContext(DesktopGraphContextRef ref) {
  final storage = ref.watch(overriddenGraphStorageProvider);
  if (storage == null) return null;

  final context = core_graph.GraphContext(storage: storage);
  context.initialize();

  ref.onDispose(() async {
    await context.close();
  });

  return context;
}

/// Adapter provider for compatibility with legacy capsules
@riverpod
GraphCapsuleAdapter graphCapsuleAdapter(GraphCapsuleAdapterRef ref) {
  return GraphCapsuleAdapter(ref);
}

/// StackCapsuleAdapter
@riverpod
StackCapsuleAdapter stackCapsuleAdapter(StackCapsuleAdapterRef ref) {
  return StackCapsuleAdapter(ref);
}

/// Adapter from GraphCapsule to Riverpod
class GraphCapsuleAdapter {
  final GraphCapsuleAdapterRef _ref;

  GraphCapsuleAdapter(this._ref);

  /// Replacement for activeStackGraphStorage capsule
  core_graph.GraphStorage? get activeStackGraphStorage {
    return _ref.read(desktopGraphContextProvider)?.storage;
  }

  /// Replacement for activeStackGraphContext capsule
  core_graph.GraphContext? get activeStackGraphContext {
    return _ref.read(desktopGraphContextProvider);
  }

  /// Replacement for activeGraph capsule
  core_graph.Graph? get activeGraph {
    // Implementation that returns a sample graph
    final context = activeStackGraphContext;
    if (context == null) return null;

    // TODO: Implement actual graph data
    return null;
  }
}

/// Adapter from StackCapsule to Riverpod
class StackCapsuleAdapter {
  final StackCapsuleAdapterRef _ref;

  StackCapsuleAdapter(this._ref);

  /// Replacement for availableStacksValue capsule
  Future<List<core_stack.Stack>> get availableStacksList {
    return _ref.read(core_stack.availableStacksListProvider.future);
  }

  /// Replacement for stackSearchDirectory capsule
  Future<Directory> get stackSearchDirectory {
    return _ref.read(desktopStackSearchDirectoryProvider.future);
  }

  /// Replacement for refreshStacksTrigger
  void refreshStacks() {
    _ref.read(core_stack.refreshStacksTriggerProvider.notifier).trigger();
  }
}
