import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_graph_flutter/core_graph.dart';

part 'selected_entity_providers.g.dart';

// These providers are removed because unified providers are used
// Using activeGraphProvider and selectedEntityIdProvider from core_graph package

/// Provider that monitors the selected entity and sets it in the editor
/// Using unified core_graph provider
///
/// Note: Not using AutoDispose keeps the state persistent even when switching screens
@Riverpod(keepAlive: true)
Entity? selectedEntityForEditor(Ref ref) {
  // Get the selected entity from the unified provider
  final selectedEntity = ref.watch(selectedEntityProvider);
  debugPrint('[selectedEntityForEditor] ===== PROVIDER CALLED =====');
  debugPrint(
    '[selectedEntityForEditor] Using unified provider, entity: ${selectedEntity?.id}',
  );
  debugPrint(
    '[selectedEntityForEditor] Entity type: ${selectedEntity?.runtimeType}',
  );
  return selectedEntity;
}
