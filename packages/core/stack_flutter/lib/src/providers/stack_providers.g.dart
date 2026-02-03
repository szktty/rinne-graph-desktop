// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$documentsDirectoryHash() =>
    r'da8c43d011f6b17480413b9c84e7de1c8576cccd';

/// Provider to asynchronously get path to application documents directory
///
/// Copied from [documentsDirectory].
@ProviderFor(documentsDirectory)
final documentsDirectoryProvider =
    AutoDisposeFutureProvider<Directory>.internal(
      documentsDirectory,
      name: r'documentsDirectoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$documentsDirectoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DocumentsDirectoryRef = AutoDisposeFutureProviderRef<Directory>;
String _$stackSearchDirectoryHash() =>
    r'fd5957bdf33d98c5f5059299afd47722bc61b00b';

/// Provider to provide root directory for stack search
///
/// Copied from [stackSearchDirectory].
@ProviderFor(stackSearchDirectory)
final stackSearchDirectoryProvider =
    AutoDisposeFutureProvider<Directory>.internal(
      stackSearchDirectory,
      name: r'stackSearchDirectoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$stackSearchDirectoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StackSearchDirectoryRef = AutoDisposeFutureProviderRef<Directory>;
String _$scratchesDirectoryHash() =>
    r'e1dcceae3b66bcfa27c73c38297855d5939050eb';

/// Provider to asynchronously get scratch stack directory
///
/// Copied from [scratchesDirectory].
@ProviderFor(scratchesDirectory)
final scratchesDirectoryProvider =
    AutoDisposeFutureProvider<Directory>.internal(
      scratchesDirectory,
      name: r'scratchesDirectoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$scratchesDirectoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScratchesDirectoryRef = AutoDisposeFutureProviderRef<Directory>;
String _$availableStacksStreamHash() =>
    r'1abd85812f6db34165faef1ea55a8d5b67933f46';

/// Provider to provide list of available stacks (Stream<Stack>)
///
/// Copied from [availableStacksStream].
@ProviderFor(availableStacksStream)
final availableStacksStreamProvider = AutoDisposeStreamProvider<Stack>.internal(
  availableStacksStream,
  name: r'availableStacksStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$availableStacksStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableStacksStreamRef = AutoDisposeStreamProviderRef<Stack>;
String _$availableStacksListHash() =>
    r'c7820530015ad9e72141809169a20f7d449ed8dd';

/// Provider to provide list of available stacks as List<Stack>
/// Archived stacks are excluded
///
/// Copied from [availableStacksList].
@ProviderFor(availableStacksList)
final availableStacksListProvider =
    AutoDisposeFutureProvider<List<Stack>>.internal(
      availableStacksList,
      name: r'availableStacksListProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$availableStacksListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableStacksListRef = AutoDisposeFutureProviderRef<List<Stack>>;
String _$allStacksListHash() => r'dff17a3d264d85f80478598e6f3075fa15a558c0';

/// Provider to provide list of all stacks (including archived) as List<Stack>
///
/// Copied from [allStacksList].
@ProviderFor(allStacksList)
final allStacksListProvider = AutoDisposeFutureProvider<List<Stack>>.internal(
  allStacksList,
  name: r'allStacksListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allStacksListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllStacksListRef = AutoDisposeFutureProviderRef<List<Stack>>;
String _$refreshStacksTriggerHash() =>
    r'7628c34502a8f5f3576dd0f4d1c2b6ea99229edc';

/// Provider to trigger stack list update
///
/// Copied from [RefreshStacksTrigger].
@ProviderFor(RefreshStacksTrigger)
final refreshStacksTriggerProvider =
    AutoDisposeNotifierProvider<RefreshStacksTrigger, int>.internal(
      RefreshStacksTrigger.new,
      name: r'refreshStacksTriggerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$refreshStacksTriggerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RefreshStacksTrigger = AutoDisposeNotifier<int>;
String _$stackActionsHash() => r'9381ea8bfc07487c1077c0cd9475339249ce01fa';

/// Provider to provide actions for stack creation, deletion, etc.
///
/// Copied from [StackActions].
@ProviderFor(StackActions)
final stackActionsProvider =
    AutoDisposeNotifierProvider<StackActions, void>.internal(
      StackActions.new,
      name: r'stackActionsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$stackActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$StackActions = AutoDisposeNotifier<void>;
String _$activeStackHash() => r'0136755005e6afdcb3db1ced86a091d64336fb10';

/// Provider to manage currently open active stack
///
/// This provider manages the currently active stack across the entire application.
/// When a stack is set, related services and providers are notified.
///
/// Copied from [ActiveStack].
@ProviderFor(ActiveStack)
final activeStackProvider = NotifierProvider<ActiveStack, Stack?>.internal(
  ActiveStack.new,
  name: r'activeStackProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeStackHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActiveStack = Notifier<Stack?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
