// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bridge_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bridge provider for desktop app
/// Bridges existing capsules and Riverpod providers
/// Provider that provides GraphStorage implementation

@ProviderFor(desktopGraphStorage)
final desktopGraphStorageProvider = DesktopGraphStorageProvider._();

/// Bridge provider for desktop app
/// Bridges existing capsules and Riverpod providers
/// Provider that provides GraphStorage implementation

final class DesktopGraphStorageProvider
    extends
        $FunctionalProvider<
          core_graph.GraphStorage,
          core_graph.GraphStorage,
          core_graph.GraphStorage
        >
    with $Provider<core_graph.GraphStorage> {
  /// Bridge provider for desktop app
  /// Bridges existing capsules and Riverpod providers
  /// Provider that provides GraphStorage implementation
  DesktopGraphStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'desktopGraphStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$desktopGraphStorageHash();

  @$internal
  @override
  $ProviderElement<core_graph.GraphStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  core_graph.GraphStorage create(Ref ref) {
    return desktopGraphStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(core_graph.GraphStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<core_graph.GraphStorage>(value),
    );
  }
}

String _$desktopGraphStorageHash() =>
    r'eb70959f430d9f9fcab75141457e2947667b15bd';

/// Provider that provides StackSearchDirectory implementation

@ProviderFor(desktopStackSearchDirectory)
final desktopStackSearchDirectoryProvider =
    DesktopStackSearchDirectoryProvider._();

/// Provider that provides StackSearchDirectory implementation

final class DesktopStackSearchDirectoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Directory>,
          Directory,
          FutureOr<Directory>
        >
    with $FutureModifier<Directory>, $FutureProvider<Directory> {
  /// Provider that provides StackSearchDirectory implementation
  DesktopStackSearchDirectoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'desktopStackSearchDirectoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$desktopStackSearchDirectoryHash();

  @$internal
  @override
  $FutureProviderElement<Directory> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Directory> create(Ref ref) {
    return desktopStackSearchDirectory(ref);
  }
}

String _$desktopStackSearchDirectoryHash() =>
    r'324f5ec1ac212ef89432fd18d5effd5491e2383d';

/// Provides application-specific GraphStorageProvider override

@ProviderFor(overriddenGraphStorage)
final overriddenGraphStorageProvider = OverriddenGraphStorageProvider._();

/// Provides application-specific GraphStorageProvider override

final class OverriddenGraphStorageProvider
    extends
        $FunctionalProvider<
          core_graph.GraphStorage?,
          core_graph.GraphStorage?,
          core_graph.GraphStorage?
        >
    with $Provider<core_graph.GraphStorage?> {
  /// Provides application-specific GraphStorageProvider override
  OverriddenGraphStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overriddenGraphStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overriddenGraphStorageHash();

  @$internal
  @override
  $ProviderElement<core_graph.GraphStorage?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  core_graph.GraphStorage? create(Ref ref) {
    return overriddenGraphStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(core_graph.GraphStorage? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<core_graph.GraphStorage?>(value),
    );
  }
}

String _$overriddenGraphStorageHash() =>
    r'60cabbe6f012387add73e234c839aeda239b2114';

/// GraphContext provider for desktop app

@ProviderFor(desktopGraphContext)
final desktopGraphContextProvider = DesktopGraphContextProvider._();

/// GraphContext provider for desktop app

final class DesktopGraphContextProvider
    extends
        $FunctionalProvider<
          core_graph.GraphContext?,
          core_graph.GraphContext?,
          core_graph.GraphContext?
        >
    with $Provider<core_graph.GraphContext?> {
  /// GraphContext provider for desktop app
  DesktopGraphContextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'desktopGraphContextProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$desktopGraphContextHash();

  @$internal
  @override
  $ProviderElement<core_graph.GraphContext?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  core_graph.GraphContext? create(Ref ref) {
    return desktopGraphContext(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(core_graph.GraphContext? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<core_graph.GraphContext?>(value),
    );
  }
}

String _$desktopGraphContextHash() =>
    r'38e35f304b853205283addcfdf926ed9b9e8b61a';

/// Adapter provider for compatibility with legacy capsules

@ProviderFor(graphCapsuleAdapter)
final graphCapsuleAdapterProvider = GraphCapsuleAdapterProvider._();

/// Adapter provider for compatibility with legacy capsules

final class GraphCapsuleAdapterProvider
    extends
        $FunctionalProvider<
          GraphCapsuleAdapter,
          GraphCapsuleAdapter,
          GraphCapsuleAdapter
        >
    with $Provider<GraphCapsuleAdapter> {
  /// Adapter provider for compatibility with legacy capsules
  GraphCapsuleAdapterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graphCapsuleAdapterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graphCapsuleAdapterHash();

  @$internal
  @override
  $ProviderElement<GraphCapsuleAdapter> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GraphCapsuleAdapter create(Ref ref) {
    return graphCapsuleAdapter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GraphCapsuleAdapter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GraphCapsuleAdapter>(value),
    );
  }
}

String _$graphCapsuleAdapterHash() =>
    r'1ae523786b3a36ec760ef3cde4bc3c5859675b82';

/// StackCapsuleAdapter

@ProviderFor(stackCapsuleAdapter)
final stackCapsuleAdapterProvider = StackCapsuleAdapterProvider._();

/// StackCapsuleAdapter

final class StackCapsuleAdapterProvider
    extends
        $FunctionalProvider<
          StackCapsuleAdapter,
          StackCapsuleAdapter,
          StackCapsuleAdapter
        >
    with $Provider<StackCapsuleAdapter> {
  /// StackCapsuleAdapter
  StackCapsuleAdapterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stackCapsuleAdapterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stackCapsuleAdapterHash();

  @$internal
  @override
  $ProviderElement<StackCapsuleAdapter> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StackCapsuleAdapter create(Ref ref) {
    return stackCapsuleAdapter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StackCapsuleAdapter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StackCapsuleAdapter>(value),
    );
  }
}

String _$stackCapsuleAdapterHash() =>
    r'165a666dc7531b2aab2ff7a8df73a3670221f57d';
