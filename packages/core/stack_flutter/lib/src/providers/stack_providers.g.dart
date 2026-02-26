// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider to asynchronously get path to application documents directory

@ProviderFor(documentsDirectory)
final documentsDirectoryProvider = DocumentsDirectoryProvider._();

/// Provider to asynchronously get path to application documents directory

final class DocumentsDirectoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Directory>,
          Directory,
          FutureOr<Directory>
        >
    with $FutureModifier<Directory>, $FutureProvider<Directory> {
  /// Provider to asynchronously get path to application documents directory
  DocumentsDirectoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentsDirectoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentsDirectoryHash();

  @$internal
  @override
  $FutureProviderElement<Directory> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Directory> create(Ref ref) {
    return documentsDirectory(ref);
  }
}

String _$documentsDirectoryHash() =>
    r'da8c43d011f6b17480413b9c84e7de1c8576cccd';

/// Provider to provide root directory for stack search

@ProviderFor(stackSearchDirectory)
final stackSearchDirectoryProvider = StackSearchDirectoryProvider._();

/// Provider to provide root directory for stack search

final class StackSearchDirectoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Directory>,
          Directory,
          FutureOr<Directory>
        >
    with $FutureModifier<Directory>, $FutureProvider<Directory> {
  /// Provider to provide root directory for stack search
  StackSearchDirectoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stackSearchDirectoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stackSearchDirectoryHash();

  @$internal
  @override
  $FutureProviderElement<Directory> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Directory> create(Ref ref) {
    return stackSearchDirectory(ref);
  }
}

String _$stackSearchDirectoryHash() =>
    r'fd5957bdf33d98c5f5059299afd47722bc61b00b';

/// Provider to asynchronously get scratch stack directory

@ProviderFor(scratchesDirectory)
final scratchesDirectoryProvider = ScratchesDirectoryProvider._();

/// Provider to asynchronously get scratch stack directory

final class ScratchesDirectoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Directory>,
          Directory,
          FutureOr<Directory>
        >
    with $FutureModifier<Directory>, $FutureProvider<Directory> {
  /// Provider to asynchronously get scratch stack directory
  ScratchesDirectoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scratchesDirectoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scratchesDirectoryHash();

  @$internal
  @override
  $FutureProviderElement<Directory> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Directory> create(Ref ref) {
    return scratchesDirectory(ref);
  }
}

String _$scratchesDirectoryHash() =>
    r'e1dcceae3b66bcfa27c73c38297855d5939050eb';

/// Provider to asynchronously get sample stacks directory

@ProviderFor(samplesDirectory)
final samplesDirectoryProvider = SamplesDirectoryProvider._();

/// Provider to asynchronously get sample stacks directory

final class SamplesDirectoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Directory>,
          Directory,
          FutureOr<Directory>
        >
    with $FutureModifier<Directory>, $FutureProvider<Directory> {
  /// Provider to asynchronously get sample stacks directory
  SamplesDirectoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'samplesDirectoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$samplesDirectoryHash();

  @$internal
  @override
  $FutureProviderElement<Directory> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Directory> create(Ref ref) {
    return samplesDirectory(ref);
  }
}

String _$samplesDirectoryHash() => r'c2e9e84f51e5756919534d5d94c777df366faf5f';

/// Provider to provide list of sample stacks as List<Stack>

@ProviderFor(sampleStacksList)
final sampleStacksListProvider = SampleStacksListProvider._();

/// Provider to provide list of sample stacks as List<Stack>

final class SampleStacksListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Stack>>,
          List<Stack>,
          FutureOr<List<Stack>>
        >
    with $FutureModifier<List<Stack>>, $FutureProvider<List<Stack>> {
  /// Provider to provide list of sample stacks as List<Stack>
  SampleStacksListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sampleStacksListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sampleStacksListHash();

  @$internal
  @override
  $FutureProviderElement<List<Stack>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Stack>> create(Ref ref) {
    return sampleStacksList(ref);
  }
}

String _$sampleStacksListHash() => r'99c8ae2e04cae7737362b28b887fc1494ada898b';

/// Provider to trigger stack list update

@ProviderFor(RefreshStacksTrigger)
final refreshStacksTriggerProvider = RefreshStacksTriggerProvider._();

/// Provider to trigger stack list update
final class RefreshStacksTriggerProvider
    extends $NotifierProvider<RefreshStacksTrigger, int> {
  /// Provider to trigger stack list update
  RefreshStacksTriggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refreshStacksTriggerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refreshStacksTriggerHash();

  @$internal
  @override
  RefreshStacksTrigger create() => RefreshStacksTrigger();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$refreshStacksTriggerHash() =>
    r'7628c34502a8f5f3576dd0f4d1c2b6ea99229edc';

/// Provider to trigger stack list update

abstract class _$RefreshStacksTrigger extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider to provide list of available stacks (Stream<Stack>)

@ProviderFor(availableStacksStream)
final availableStacksStreamProvider = AvailableStacksStreamProvider._();

/// Provider to provide list of available stacks (Stream<Stack>)

final class AvailableStacksStreamProvider
    extends $FunctionalProvider<AsyncValue<Stack>, Stack, Stream<Stack>>
    with $FutureModifier<Stack>, $StreamProvider<Stack> {
  /// Provider to provide list of available stacks (Stream<Stack>)
  AvailableStacksStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableStacksStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableStacksStreamHash();

  @$internal
  @override
  $StreamProviderElement<Stack> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Stack> create(Ref ref) {
    return availableStacksStream(ref);
  }
}

String _$availableStacksStreamHash() =>
    r'1abd85812f6db34165faef1ea55a8d5b67933f46';

/// Provider to provide list of available stacks as List<Stack>
/// Archived stacks are excluded

@ProviderFor(availableStacksList)
final availableStacksListProvider = AvailableStacksListProvider._();

/// Provider to provide list of available stacks as List<Stack>
/// Archived stacks are excluded

final class AvailableStacksListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Stack>>,
          List<Stack>,
          FutureOr<List<Stack>>
        >
    with $FutureModifier<List<Stack>>, $FutureProvider<List<Stack>> {
  /// Provider to provide list of available stacks as List<Stack>
  /// Archived stacks are excluded
  AvailableStacksListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableStacksListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableStacksListHash();

  @$internal
  @override
  $FutureProviderElement<List<Stack>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Stack>> create(Ref ref) {
    return availableStacksList(ref);
  }
}

String _$availableStacksListHash() =>
    r'c7820530015ad9e72141809169a20f7d449ed8dd';

/// Provider to provide list of all stacks (including archived) as List<Stack>

@ProviderFor(allStacksList)
final allStacksListProvider = AllStacksListProvider._();

/// Provider to provide list of all stacks (including archived) as List<Stack>

final class AllStacksListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Stack>>,
          List<Stack>,
          FutureOr<List<Stack>>
        >
    with $FutureModifier<List<Stack>>, $FutureProvider<List<Stack>> {
  /// Provider to provide list of all stacks (including archived) as List<Stack>
  AllStacksListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allStacksListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allStacksListHash();

  @$internal
  @override
  $FutureProviderElement<List<Stack>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Stack>> create(Ref ref) {
    return allStacksList(ref);
  }
}

String _$allStacksListHash() => r'dff17a3d264d85f80478598e6f3075fa15a558c0';

/// Provider to provide actions for stack creation, deletion, etc.

@ProviderFor(StackActions)
final stackActionsProvider = StackActionsProvider._();

/// Provider to provide actions for stack creation, deletion, etc.
final class StackActionsProvider extends $NotifierProvider<StackActions, void> {
  /// Provider to provide actions for stack creation, deletion, etc.
  StackActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stackActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stackActionsHash();

  @$internal
  @override
  StackActions create() => StackActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$stackActionsHash() => r'304f55bbb6f80459308a1da74278ee7bd9dccf10';

/// Provider to provide actions for stack creation, deletion, etc.

abstract class _$StackActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider to manage currently open active stack
///
/// This provider manages the currently active stack across the entire application.
/// When a stack is set, related services and providers are notified.

@ProviderFor(ActiveStack)
final activeStackProvider = ActiveStackProvider._();

/// Provider to manage currently open active stack
///
/// This provider manages the currently active stack across the entire application.
/// When a stack is set, related services and providers are notified.
final class ActiveStackProvider extends $NotifierProvider<ActiveStack, Stack?> {
  /// Provider to manage currently open active stack
  ///
  /// This provider manages the currently active stack across the entire application.
  /// When a stack is set, related services and providers are notified.
  ActiveStackProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeStackProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeStackHash();

  @$internal
  @override
  ActiveStack create() => ActiveStack();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Stack? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Stack?>(value),
    );
  }
}

String _$activeStackHash() => r'0136755005e6afdcb3db1ced86a091d64336fb10';

/// Provider to manage currently open active stack
///
/// This provider manages the currently active stack across the entire application.
/// When a stack is set, related services and providers are notified.

abstract class _$ActiveStack extends $Notifier<Stack?> {
  Stack? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Stack?, Stack?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Stack?, Stack?>,
              Stack?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
