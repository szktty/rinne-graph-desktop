// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bridge_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$desktopGraphStorageHash() =>
    r'11ba525e25288b7a199462b17f70dafccbd9bf9a';

/// Bridge provider for desktop app
/// Bridges existing capsules and Riverpod providers
/// Provider that provides GraphStorage implementation
///
/// Copied from [desktopGraphStorage].
@ProviderFor(desktopGraphStorage)
final desktopGraphStorageProvider =
    AutoDisposeProvider<core_graph.GraphStorage>.internal(
      desktopGraphStorage,
      name: r'desktopGraphStorageProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$desktopGraphStorageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DesktopGraphStorageRef =
    AutoDisposeProviderRef<core_graph.GraphStorage>;
String _$desktopStackSearchDirectoryHash() =>
    r'95fad1ba10356c4817a9490f27698fc2184f939f';

/// Provider that provides StackSearchDirectory implementation
///
/// Copied from [desktopStackSearchDirectory].
@ProviderFor(desktopStackSearchDirectory)
final desktopStackSearchDirectoryProvider =
    AutoDisposeFutureProvider<Directory>.internal(
      desktopStackSearchDirectory,
      name: r'desktopStackSearchDirectoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$desktopStackSearchDirectoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DesktopStackSearchDirectoryRef =
    AutoDisposeFutureProviderRef<Directory>;
String _$overriddenGraphStorageHash() =>
    r'7134e0ae2a88f8281c190935845e97c31c3e93ed';

/// Provides application-specific GraphStorageProvider override
///
/// Copied from [overriddenGraphStorage].
@ProviderFor(overriddenGraphStorage)
final overriddenGraphStorageProvider =
    AutoDisposeProvider<core_graph.GraphStorage?>.internal(
      overriddenGraphStorage,
      name: r'overriddenGraphStorageProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$overriddenGraphStorageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OverriddenGraphStorageRef =
    AutoDisposeProviderRef<core_graph.GraphStorage?>;
String _$desktopGraphContextHash() =>
    r'fbedabc7b436e2a6763b72641bc451a3f253b74c';

/// GraphContext provider for desktop app
///
/// Copied from [desktopGraphContext].
@ProviderFor(desktopGraphContext)
final desktopGraphContextProvider =
    AutoDisposeProvider<core_graph.GraphContext?>.internal(
      desktopGraphContext,
      name: r'desktopGraphContextProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$desktopGraphContextHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DesktopGraphContextRef =
    AutoDisposeProviderRef<core_graph.GraphContext?>;
String _$graphCapsuleAdapterHash() =>
    r'7be44d515924089b5f6f4744b8002ae6fbada336';

/// Adapter provider for compatibility with legacy capsules
///
/// Copied from [graphCapsuleAdapter].
@ProviderFor(graphCapsuleAdapter)
final graphCapsuleAdapterProvider =
    AutoDisposeProvider<GraphCapsuleAdapter>.internal(
      graphCapsuleAdapter,
      name: r'graphCapsuleAdapterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$graphCapsuleAdapterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GraphCapsuleAdapterRef = AutoDisposeProviderRef<GraphCapsuleAdapter>;
String _$stackCapsuleAdapterHash() =>
    r'f45188b3caf0093e1749e41bc89a198e8095a84b';

/// StackCapsuleAdapter
///
/// Copied from [stackCapsuleAdapter].
@ProviderFor(stackCapsuleAdapter)
final stackCapsuleAdapterProvider =
    AutoDisposeProvider<StackCapsuleAdapter>.internal(
      stackCapsuleAdapter,
      name: r'stackCapsuleAdapterProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$stackCapsuleAdapterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StackCapsuleAdapterRef = AutoDisposeProviderRef<StackCapsuleAdapter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
