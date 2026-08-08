/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

import 'package:core_graph_common/src/model/property_type.dart';
import 'package:core_graph_common/src/property_type/global_property_type_definition.dart';
import 'package:core_graph_common/src/property_type/global_property_type_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'property_type_providers.g.dart';

/// Path of the stack whose property type definitions are in scope.
///
/// Overridden by the application layer, which is the only layer that knows
/// about the active stack — `core_graph_flutter` deliberately does not depend
/// on `core_stack_flutter`, so the path is injected rather than looked up.
///
/// Null when no stack is open, which leaves the type map empty and every
/// property untyped.
@Riverpod(keepAlive: true)
class PropertyTypeStackPath extends _$PropertyTypeStackPath {
  @override
  String? build() => null;

  /// Points the type definitions at [stackPath].
  ///
  /// Setting this to a different stack rebuilds the manager below, which is
  /// what keeps one stack's definitions from leaking into the next.
  void setStackPath(String? stackPath) {
    state = stackPath;
  }
}

/// Manager for the active stack's property type definitions.
///
/// Rebuilt whenever the stack path changes, so its in-memory cache never
/// outlives the stack it was populated from.
@Riverpod(keepAlive: true)
GlobalPropertyTypeManager? propertyTypeManager(Ref ref) {
  final stackPath = ref.watch(propertyTypeStackPathProvider);
  if (stackPath == null) {
    return null;
  }

  final manager = GlobalPropertyTypeManager(stackPath);

  // Belt and braces: the provider is already rebuilt per path, but a manager
  // that outlives its disposal would otherwise keep serving stale definitions.
  ref.onDispose(manager.clearCache);

  return manager;
}

/// Resolves the type definition of [propertyName] for an entity with [labels].
///
/// Follows the manager's resolution order — label-scoped first, then
/// stack-wide — and yields null when nothing defines the property, which
/// callers read as "untyped" and render as plain text.
@riverpod
Future<GlobalPropertyTypeDefinition?> propertyTypeDefinition(
  Ref ref,
  String propertyName,
  List<String> labels,
) async {
  final manager = ref.watch(propertyTypeManagerProvider);
  if (manager == null) {
    return null;
  }

  return manager.getPropertyTypeForLabels(propertyName, labels);
}

/// Resolves [propertyName] to a concrete [PropertyType] for [labels].
///
/// Null means untyped — the editor falls back to a plain text field. A type
/// name this build does not recognise also resolves to null, so a stack
/// written by a newer version degrades rather than throwing.
@riverpod
Future<PropertyType?> resolvedPropertyType(
  Ref ref,
  String propertyName,
  List<String> labels,
) async {
  final definition = await ref.watch(
    propertyTypeDefinitionProvider(propertyName, labels).future,
  );

  return definition?.toPropertyType();
}

/// Every property type defined for [labels], keyed by property name.
///
/// Lets the editor resolve a whole property list in one pass instead of
/// watching a provider per row. Label-scoped definitions win over stack-wide
/// ones, and within the labels the first match wins, matching
/// [GlobalPropertyTypeManager.getPropertyTypeForLabels].
@riverpod
Future<Map<String, PropertyType>> propertyTypesForLabels(
  Ref ref,
  List<String> labels,
) async {
  final manager = ref.watch(propertyTypeManagerProvider);
  if (manager == null) {
    return const {};
  }

  final resolved = <String, PropertyType>{};

  // Stack-wide definitions first, so the label-scoped pass below overwrites
  // them where both define the same property name.
  final global = await manager.getAllPropertyTypes();
  for (final entry in global.entries) {
    final type = entry.value.toPropertyType();
    if (type != null) {
      resolved[entry.key] = type;
    }
  }

  final byLabel = await manager.getAllLabelPropertyTypes();
  // Reversed so that the earliest label's definition is applied last and wins.
  for (final label in labels.toList().reversed) {
    final forLabel = byLabel[label];
    if (forLabel == null) continue;

    for (final entry in forLabel.entries) {
      final type = entry.value.toPropertyType();
      if (type != null) {
        resolved[entry.key] = type;
      }
    }
  }

  return resolved;
}
