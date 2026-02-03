// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_display_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nodeDisplayContentHash() =>
    r'f72864ff230940ba02ea928202d172bb70be3756';

/// Node display content provider (value only)
///
/// Copied from [nodeDisplayContent].
@ProviderFor(nodeDisplayContent)
final nodeDisplayContentProvider =
    AutoDisposeProvider<NodeDisplayContent>.internal(
      nodeDisplayContent,
      name: r'nodeDisplayContentProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$nodeDisplayContentHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NodeDisplayContentRef = AutoDisposeProviderRef<NodeDisplayContent>;
String _$nodeSizeHash() => r'090cbf82926a2852731fbb0df76071e2658801cb';

/// Node size provider (value only)
///
/// Copied from [nodeSize].
@ProviderFor(nodeSize)
final nodeSizeProvider = AutoDisposeProvider<NodeSize>.internal(
  nodeSize,
  name: r'nodeSizeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$nodeSizeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NodeSizeRef = AutoDisposeProviderRef<NodeSize>;
String _$nodeVisualDataForEntityHash() =>
    r'88230951459adc2e7c14072599ee9affa248754a';

/// Function provider that gets visual data for a specific entity
///
/// Copied from [nodeVisualDataForEntity].
@ProviderFor(nodeVisualDataForEntity)
final nodeVisualDataForEntityProvider = AutoDisposeProvider<
  NodeVisualData Function(String entityId, Set<String> labels)
>.internal(
  nodeVisualDataForEntity,
  name: r'nodeVisualDataForEntityProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$nodeVisualDataForEntityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NodeVisualDataForEntityRef =
    AutoDisposeProviderRef<
      NodeVisualData Function(String entityId, Set<String> labels)
    >;
String _$nodeDisplayContentStateHash() =>
    r'2b8a70e558076b8a06f2b7d630dab2b7562f5703';

/// Provider that manages node display content settings
///
/// Copied from [NodeDisplayContentState].
@ProviderFor(NodeDisplayContentState)
final nodeDisplayContentStateProvider = AutoDisposeNotifierProvider<
  NodeDisplayContentState,
  NodeDisplayContent
>.internal(
  NodeDisplayContentState.new,
  name: r'nodeDisplayContentStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$nodeDisplayContentStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NodeDisplayContentState = AutoDisposeNotifier<NodeDisplayContent>;
String _$nodeSizeStateHash() => r'ea1bf604c9f40f836aea3374108e9f8440613847';

/// Provider that manages node size settings
///
/// Copied from [NodeSizeState].
@ProviderFor(NodeSizeState)
final nodeSizeStateProvider =
    AutoDisposeNotifierProvider<NodeSizeState, NodeSize>.internal(
      NodeSizeState.new,
      name: r'nodeSizeStateProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$nodeSizeStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NodeSizeState = AutoDisposeNotifier<NodeSize>;
String _$nodeVisualDataMapHash() => r'69371146776703eec2c3c64316f9516fc11626e6';

/// Provider that manages node visual data
///
/// Copied from [NodeVisualDataMap].
@ProviderFor(NodeVisualDataMap)
final nodeVisualDataMapProvider = AutoDisposeNotifierProvider<
  NodeVisualDataMap,
  Map<String, NodeVisualData>
>.internal(
  NodeVisualDataMap.new,
  name: r'nodeVisualDataMapProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$nodeVisualDataMapHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NodeVisualDataMap = AutoDisposeNotifier<Map<String, NodeVisualData>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
