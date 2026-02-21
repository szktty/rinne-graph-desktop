// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeStackGraphStorageHash() =>
    r'b9cbc7d38769d6dfdd29a7cde05a7cb60aa201ee';

/// Provider for GraphStorage for the active stack
///
/// Copied from [activeStackGraphStorage].
@ProviderFor(activeStackGraphStorage)
final activeStackGraphStorageProvider =
    AutoDisposeProvider<core_graph.GraphStorage?>.internal(
      activeStackGraphStorage,
      name: r'activeStackGraphStorageProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activeStackGraphStorageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveStackGraphStorageRef =
    AutoDisposeProviderRef<core_graph.GraphStorage?>;
String _$graphViewCacheHash() => r'cd2a10827bc8912c7633f50f8802cf7f4d57b555';

/// Provider for the graph view cache
///
/// Copied from [graphViewCache].
@ProviderFor(graphViewCache)
final graphViewCacheProvider = AutoDisposeProvider<GraphViewCache>.internal(
  graphViewCache,
  name: r'graphViewCacheProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$graphViewCacheHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GraphViewCacheRef = AutoDisposeProviderRef<GraphViewCache>;
String _$graphActionsHash() => r'6322a1d7cb318abd298167fabb53f481fd79333e';

/// Graph operations actions provider
///
/// Copied from [graphActions].
@ProviderFor(graphActions)
final graphActionsProvider = AutoDisposeProvider<GraphActions>.internal(
  graphActions,
  name: r'graphActionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$graphActionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GraphActionsRef = AutoDisposeProviderRef<GraphActions>;
String _$selectedGraphEntityIdHash() =>
    r'6a04c3d1f50dd5b55f0b65a1a89cca8e6be1ff32';

/// Provider managing the selected graph entity ID
///
/// Copied from [SelectedGraphEntityId].
@ProviderFor(SelectedGraphEntityId)
final selectedGraphEntityIdProvider = AutoDisposeNotifierProvider<
  SelectedGraphEntityId,
  core_graph.EntityId?
>.internal(
  SelectedGraphEntityId.new,
  name: r'selectedGraphEntityIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedGraphEntityIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedGraphEntityId = AutoDisposeNotifier<core_graph.EntityId?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
