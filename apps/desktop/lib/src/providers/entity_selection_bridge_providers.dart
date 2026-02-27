/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:core_graph_flutter/core_graph.dart' as core_graph;
import 'package:core_stack_flutter/core_stack.dart' as core_stack;
import 'package:presentation_components/presentation_components.dart';

import 'graph_providers.dart';
import 'selection_providers.dart';
import 'app_state_providers.dart';

part 'entity_selection_bridge_providers.g.dart';

/// Provider that manages the state of stack loading errors
final stackLoadingErrorProvider = StateProvider<ErrorDialogData?>(
  (ref) => null,
);

/// Provider that manages the graph loading state
final graphLoadingStateProvider = StateProvider<bool>((ref) => false);

/// Provider that manages the delayed loading display state
/// Becomes true only if loading continues for more than 1 second
final delayedLoadingStateProvider = StateProvider<bool>((ref) => false);

/// Provider that links entity selection state with the editor
///
/// This provider provides the following functionalities:
/// 1. Transmits selected entity ID to the entity_editor package
/// 2. Transmits the active graph to the entity_editor package
/// 3. Automatically displays the secondary sidebar when an entity is selected
@riverpod
class EntitySelectionBridge extends _$EntitySelectionBridge {
  @override
  void build() {
    // Monitor active stack changes and load graph
    ref.listen(core_stack.activeStackProvider, (previous, next) async {
      debugPrint(
        '[EntitySelectionBridge] Active stack changed: ${previous?.directory.path} -> ${next?.directory.path}',
      );

      // Do nothing if it's the same as the previous stack
      if (previous?.directory.path == next?.directory.path) {
        debugPrint('[EntitySelectionBridge] Same stack, skipping reload');
        return;
      }

      if (next == null) {
        // If stack is cleared, also clear unified providers
        ref.read(core_graph.activeGraphProvider.notifier).clearGraph();
        ref.read(core_graph.selectedEntityIdProvider.notifier).clearSelection();
        return;
      }

      // Load graph data for new stack
      debugPrint('[EntitySelectionBridge] Loading graph for new stack');
      try {
        // Wait a bit before starting load (wait for provider initialization)
        await Future.delayed(const Duration(milliseconds: 100));
        await _loadGraphForStack(next);
        debugPrint('[EntitySelectionBridge] Graph loaded for new stack');
      } catch (e) {
        debugPrint('[EntitySelectionBridge] Error loading graph: $e');
        // Set error state
        ref
            .read(stackLoadingErrorProvider.notifier)
            .state = ErrorDialogData.withDetails(
          'An error occurred while opening the stack.',
          '$e',
        );
      }
    });

    // Directly monitor selection state
    ref.listen(selectionStateProvider, (previous, next) {
      final entityId = next.selectedEntityId;
      debugPrint(
        '[EntitySelectionBridge] Selection state changed: ${previous?.selectedEntityId} -> $entityId',
      );

      // Transmit selection state to unified provider
      ref
          .read(core_graph.selectedEntityIdProvider.notifier)
          .setEntityId(entityId);
      debugPrint(
        '[EntitySelectionBridge] Updated selectedEntityIdProvider with: $entityId',
      );

      // Automatically display secondary sidebar when entity is selected
      if (entityId != null) {
        ref.read(screenBasedSecondarySidebarStateProvider.notifier).show();
        debugPrint('[EntitySelectionBridge] Showing secondary sidebar');
      }
    });
  }

  /// Loads graph data for the stack and sets it to the unified provider
  Future<void> _loadGraphForStack(core_stack.Stack stack) async {
    // Start loading state
    ref.read(graphLoadingStateProvider.notifier).state = true;

    // Timer to start delayed loading display after 1 second
    Timer? delayedLoadingTimer;
    delayedLoadingTimer = Timer(const Duration(seconds: 1), () {
      if (ref.read(graphLoadingStateProvider)) {
        ref.read(delayedLoadingStateProvider.notifier).state = true;
      }
    });

    try {
      debugPrint(
        '[EntitySelectionBridge] Starting graph load for stack: ${stack.info.name}',
      );
      debugPrint(
        '[EntitySelectionBridge] Loading graph for stack: ${stack.directory.path}',
      );

      // Get GraphStorage
      final storage = ref.read(activeStackGraphStorageProvider);
      if (storage == null) {
        debugPrint('[EntitySelectionBridge] No active graph storage');
        return;
      }

      // Create GraphContext
      final graphContext = core_graph.GraphContext(storage: storage);

      // Initialization is handled by _loadActualGraphData (with retry logic)

      core_graph.Graph? graph;

      debugPrint('[EntitySelectionBridge] Loading actual graph data');
      graph = await _loadActualGraphData(graphContext, stack);

      debugPrint(
        '[EntitySelectionBridge] Setting graph: ${graph.nodes.length} nodes, ${graph.links.length} links',
      );
      ref.read(core_graph.activeGraphProvider.notifier).setGraph(graph);
    } on Exception catch (e) {
      debugPrint('[EntitySelectionBridge] Error loading graph: $e');
      ref.read(core_graph.activeGraphProvider.notifier).clearGraph();
      // Set error state
      ref
          .read(stackLoadingErrorProvider.notifier)
          .state = ErrorDialogData.fromException(
        e,
        context: 'Failed to load graph data.',
      );
    } finally {
      // Always end loading state and cancel timer
      ref.read(graphLoadingStateProvider.notifier).state = false;
      ref.read(delayedLoadingStateProvider.notifier).state = false;
      delayedLoadingTimer.cancel();
    }
  }

  /// TODO: Delete after stack operation integration
  /// Should not load all data
  ///
  /// Loads actual stack data
  Future<core_graph.Graph> _loadActualGraphData(
    core_graph.GraphContext graphContext,
    core_stack.Stack activeStack,
  ) async {
    debugPrint('[_loadActualGraphData] Loading actual data from GraphContext');

    // Initialize GraphContext (with timeout, with retry functionality)
    try {
      debugPrint('[_loadActualGraphData] Initializing GraphContext...');

      bool initSuccess = false;
      for (int attempt = 0; attempt < 3; attempt++) {
        try {
          await graphContext.initialize().timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('GraphContext initialization timed out');
            },
          );
          initSuccess = true;
          break;
        } catch (e) {
          debugPrint(
            '[_loadActualGraphData] Initialization attempt ${attempt + 1} failed: $e',
          );
          if (attempt < 2) {
            await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
          }
        }
      }

      if (!initSuccess) {
        throw Exception('Failed to initialize GraphContext after 3 attempts');
      }

      debugPrint(
        '[_loadActualGraphData] GraphContext initialized successfully',
      );

      // Check storage readiness (with timeout)
      final isReady = await graphContext.isReady().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw Exception('GraphContext isReady check timed out');
        },
      );
      if (!isReady) {
        throw Exception(
          'GraphContext storage is not ready for stack: ${activeStack.directory.path}',
        );
      }
      debugPrint('[_loadActualGraphData] Storage is ready');
    } catch (e) {
      debugPrint(
        '[_loadActualGraphData] Failed to initialize GraphContext: $e',
      );
      throw Exception(
        'Failed to initialize GraphContext for stack: ${activeStack.directory.path}. Error: $e',
      );
    }

    try {
      debugPrint('[_loadActualGraphData] Querying nodes and links');

      // Execute query to get all nodes and links (with timeout)
      final nodeQuery = core_graph.GraphQuery<core_graph.Node>(
        entityType: core_graph.Node,
      );
      final linkQuery = core_graph.GraphQuery<core_graph.Link>(
        entityType: core_graph.Link,
      );

      // Get nodes and links in parallel (with timeout)
      final results = await Future.wait([
        graphContext
            .queryNodes(nodeQuery)
            .timeout(
              const Duration(seconds: 30),
              onTimeout: () {
                throw Exception('Node query timed out');
              },
            ),
        graphContext
            .queryLinks(linkQuery)
            .timeout(
              const Duration(seconds: 30),
              onTimeout: () {
                throw Exception('Link query timed out');
              },
            ),
      ]);

      final nodeResult = results[0] as core_graph.QueryResult<core_graph.Node>;
      final linkResult = results[1] as core_graph.QueryResult<core_graph.Link>;

      final nodes = nodeResult.items;
      final links = linkResult.items;

      debugPrint(
        '[_loadActualGraphData] Loaded ${nodes.length} nodes and ${links.length} links',
      );

      // Create Graph object (convert from Set to Map)
      return core_graph.Graph(nodes: nodes.toSet(), links: links.toSet());
    } catch (e) {
      debugPrint('[_loadActualGraphData] Failed to query graph data: $e');
      throw Exception(
        'Failed to query graph data for stack: ${activeStack.directory.path}. Error: $e',
      );
    }
  }
}

/// Entity selection state initialization provider
///
/// Executed only once when the application starts,
/// and starts the collaboration between entity selection and the editor.
@riverpod
void initializeEntitySelectionBridge(Ref ref) {
  // Monitor EntitySelectionBridge to start collaboration
  ref.watch(entitySelectionBridgeProvider);
}
