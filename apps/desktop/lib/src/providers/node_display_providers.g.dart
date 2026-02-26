// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_display_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages node display content settings

@ProviderFor(NodeDisplayContentState)
final nodeDisplayContentStateProvider = NodeDisplayContentStateProvider._();

/// Provider that manages node display content settings
final class NodeDisplayContentStateProvider
    extends $NotifierProvider<NodeDisplayContentState, NodeDisplayContent> {
  /// Provider that manages node display content settings
  NodeDisplayContentStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nodeDisplayContentStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nodeDisplayContentStateHash();

  @$internal
  @override
  NodeDisplayContentState create() => NodeDisplayContentState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NodeDisplayContent value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NodeDisplayContent>(value),
    );
  }
}

String _$nodeDisplayContentStateHash() =>
    r'2b8a70e558076b8a06f2b7d630dab2b7562f5703';

/// Provider that manages node display content settings

abstract class _$NodeDisplayContentState extends $Notifier<NodeDisplayContent> {
  NodeDisplayContent build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<NodeDisplayContent, NodeDisplayContent>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NodeDisplayContent, NodeDisplayContent>,
              NodeDisplayContent,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Node display content provider (value only)

@ProviderFor(nodeDisplayContent)
final nodeDisplayContentProvider = NodeDisplayContentProvider._();

/// Node display content provider (value only)

final class NodeDisplayContentProvider
    extends
        $FunctionalProvider<
          NodeDisplayContent,
          NodeDisplayContent,
          NodeDisplayContent
        >
    with $Provider<NodeDisplayContent> {
  /// Node display content provider (value only)
  NodeDisplayContentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nodeDisplayContentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nodeDisplayContentHash();

  @$internal
  @override
  $ProviderElement<NodeDisplayContent> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NodeDisplayContent create(Ref ref) {
    return nodeDisplayContent(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NodeDisplayContent value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NodeDisplayContent>(value),
    );
  }
}

String _$nodeDisplayContentHash() =>
    r'dbe8785a9667df3f631edaffeeea325a1c2ce89f';

/// Provider that manages node size settings

@ProviderFor(NodeSizeState)
final nodeSizeStateProvider = NodeSizeStateProvider._();

/// Provider that manages node size settings
final class NodeSizeStateProvider
    extends $NotifierProvider<NodeSizeState, NodeSize> {
  /// Provider that manages node size settings
  NodeSizeStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nodeSizeStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nodeSizeStateHash();

  @$internal
  @override
  NodeSizeState create() => NodeSizeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NodeSize value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NodeSize>(value),
    );
  }
}

String _$nodeSizeStateHash() => r'ea1bf604c9f40f836aea3374108e9f8440613847';

/// Provider that manages node size settings

abstract class _$NodeSizeState extends $Notifier<NodeSize> {
  NodeSize build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<NodeSize, NodeSize>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NodeSize, NodeSize>,
              NodeSize,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Node size provider (value only)

@ProviderFor(nodeSize)
final nodeSizeProvider = NodeSizeProvider._();

/// Node size provider (value only)

final class NodeSizeProvider
    extends $FunctionalProvider<NodeSize, NodeSize, NodeSize>
    with $Provider<NodeSize> {
  /// Node size provider (value only)
  NodeSizeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nodeSizeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nodeSizeHash();

  @$internal
  @override
  $ProviderElement<NodeSize> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NodeSize create(Ref ref) {
    return nodeSize(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NodeSize value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NodeSize>(value),
    );
  }
}

String _$nodeSizeHash() => r'd6db3b0ea32cb812b6348a9b8b4f721645671a63';

/// Provider that manages node visual data

@ProviderFor(NodeVisualDataMap)
final nodeVisualDataMapProvider = NodeVisualDataMapProvider._();

/// Provider that manages node visual data
final class NodeVisualDataMapProvider
    extends $NotifierProvider<NodeVisualDataMap, Map<String, NodeVisualData>> {
  /// Provider that manages node visual data
  NodeVisualDataMapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nodeVisualDataMapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nodeVisualDataMapHash();

  @$internal
  @override
  NodeVisualDataMap create() => NodeVisualDataMap();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, NodeVisualData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, NodeVisualData>>(value),
    );
  }
}

String _$nodeVisualDataMapHash() => r'69371146776703eec2c3c64316f9516fc11626e6';

/// Provider that manages node visual data

abstract class _$NodeVisualDataMap
    extends $Notifier<Map<String, NodeVisualData>> {
  Map<String, NodeVisualData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<Map<String, NodeVisualData>, Map<String, NodeVisualData>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, NodeVisualData>,
                Map<String, NodeVisualData>
              >,
              Map<String, NodeVisualData>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Function provider that gets visual data for a specific entity

@ProviderFor(nodeVisualDataForEntity)
final nodeVisualDataForEntityProvider = NodeVisualDataForEntityProvider._();

/// Function provider that gets visual data for a specific entity

final class NodeVisualDataForEntityProvider
    extends
        $FunctionalProvider<
          NodeVisualData Function(String entityId, Set<String> labels),
          NodeVisualData Function(String entityId, Set<String> labels),
          NodeVisualData Function(String entityId, Set<String> labels)
        >
    with
        $Provider<
          NodeVisualData Function(String entityId, Set<String> labels)
        > {
  /// Function provider that gets visual data for a specific entity
  NodeVisualDataForEntityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nodeVisualDataForEntityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nodeVisualDataForEntityHash();

  @$internal
  @override
  $ProviderElement<NodeVisualData Function(String entityId, Set<String> labels)>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  NodeVisualData Function(String entityId, Set<String> labels) create(Ref ref) {
    return nodeVisualDataForEntity(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    NodeVisualData Function(String entityId, Set<String> labels) value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<
        NodeVisualData Function(String entityId, Set<String> labels)
      >(value),
    );
  }
}

String _$nodeVisualDataForEntityHash() =>
    r'014cd930dd4e389b3de5d7dc3d30b3d4d363c806';
