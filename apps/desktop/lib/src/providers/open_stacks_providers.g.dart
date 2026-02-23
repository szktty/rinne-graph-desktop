// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_stacks_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider managing the list of open stacks

@ProviderFor(OpenStacks)
final openStacksProvider = OpenStacksProvider._();

/// Provider managing the list of open stacks
final class OpenStacksProvider
    extends $NotifierProvider<OpenStacks, List<core_stack.Stack>> {
  /// Provider managing the list of open stacks
  OpenStacksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openStacksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openStacksHash();

  @$internal
  @override
  OpenStacks create() => OpenStacks();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<core_stack.Stack> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<core_stack.Stack>>(value),
    );
  }
}

String _$openStacksHash() => r'601107c306a736c3966223f1a9d1e22b4e51664a';

/// Provider managing the list of open stacks

abstract class _$OpenStacks extends $Notifier<List<core_stack.Stack>> {
  List<core_stack.Stack> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<List<core_stack.Stack>, List<core_stack.Stack>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<core_stack.Stack>, List<core_stack.Stack>>,
              List<core_stack.Stack>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Action provider for open stacks

@ProviderFor(OpenStacksActions)
final openStacksActionsProvider = OpenStacksActionsProvider._();

/// Action provider for open stacks
final class OpenStacksActionsProvider
    extends $NotifierProvider<OpenStacksActions, void> {
  /// Action provider for open stacks
  OpenStacksActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openStacksActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openStacksActionsHash();

  @$internal
  @override
  OpenStacksActions create() => OpenStacksActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$openStacksActionsHash() => r'ded253e84b7d82223aa466d0795570e787c5bd1c';

/// Action provider for open stacks

abstract class _$OpenStacksActions extends $Notifier<void> {
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
