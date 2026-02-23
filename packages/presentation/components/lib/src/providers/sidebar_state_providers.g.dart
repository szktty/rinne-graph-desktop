// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sidebar_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A map that manages the secondary sidebar state for each screen.
/// Key: index of the activity bar, Value: visibility state of the sidebar.

@ProviderFor(PerScreenSecondarySidebarState)
final perScreenSecondarySidebarStateProvider =
    PerScreenSecondarySidebarStateProvider._();

/// A map that manages the secondary sidebar state for each screen.
/// Key: index of the activity bar, Value: visibility state of the sidebar.
final class PerScreenSecondarySidebarStateProvider
    extends $NotifierProvider<PerScreenSecondarySidebarState, Map<int, bool>> {
  /// A map that manages the secondary sidebar state for each screen.
  /// Key: index of the activity bar, Value: visibility state of the sidebar.
  PerScreenSecondarySidebarStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'perScreenSecondarySidebarStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$perScreenSecondarySidebarStateHash();

  @$internal
  @override
  PerScreenSecondarySidebarState create() => PerScreenSecondarySidebarState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, bool>>(value),
    );
  }
}

String _$perScreenSecondarySidebarStateHash() =>
    r'bcc0a6654129f13732784d73b5e9696d0cd02fb2';

/// A map that manages the secondary sidebar state for each screen.
/// Key: index of the activity bar, Value: visibility state of the sidebar.

abstract class _$PerScreenSecondarySidebarState
    extends $Notifier<Map<int, bool>> {
  Map<int, bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<int, bool>, Map<int, bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<int, bool>, Map<int, bool>>,
              Map<int, bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages the visibility state of the primary sidebar (left side).

@ProviderFor(PrimarySidebarState)
final primarySidebarStateProvider = PrimarySidebarStateProvider._();

/// Provider that manages the visibility state of the primary sidebar (left side).
final class PrimarySidebarStateProvider
    extends $NotifierProvider<PrimarySidebarState, bool> {
  /// Provider that manages the visibility state of the primary sidebar (left side).
  PrimarySidebarStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'primarySidebarStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$primarySidebarStateHash();

  @$internal
  @override
  PrimarySidebarState create() => PrimarySidebarState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$primarySidebarStateHash() =>
    r'949060907b3824817cda678f7b573d6c82221da9';

/// Provider that manages the visibility state of the primary sidebar (left side).

abstract class _$PrimarySidebarState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that manages the visibility state of the secondary sidebar (right side).
/// Manages the state for each screen based on the current activity bar index.

@ProviderFor(SecondarySidebarState)
final secondarySidebarStateProvider = SecondarySidebarStateProvider._();

/// Provider that manages the visibility state of the secondary sidebar (right side).
/// Manages the state for each screen based on the current activity bar index.
final class SecondarySidebarStateProvider
    extends $NotifierProvider<SecondarySidebarState, bool> {
  /// Provider that manages the visibility state of the secondary sidebar (right side).
  /// Manages the state for each screen based on the current activity bar index.
  SecondarySidebarStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secondarySidebarStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secondarySidebarStateHash();

  @$internal
  @override
  SecondarySidebarState create() => SecondarySidebarState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$secondarySidebarStateHash() =>
    r'6c522f5354c8d7fa1a0ff9282b9bd0c16ea53d51';

/// Provider that manages the visibility state of the secondary sidebar (right side).
/// Manages the state for each screen based on the current activity bar index.

abstract class _$SecondarySidebarState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Secondary sidebar state provider based on the current activity bar index.
/// This provider automatically manages the state for each screen.

@ProviderFor(contextualSecondarySidebarState)
final contextualSecondarySidebarStateProvider =
    ContextualSecondarySidebarStateProvider._();

/// Secondary sidebar state provider based on the current activity bar index.
/// This provider automatically manages the state for each screen.

final class ContextualSecondarySidebarStateProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Secondary sidebar state provider based on the current activity bar index.
  /// This provider automatically manages the state for each screen.
  ContextualSecondarySidebarStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contextualSecondarySidebarStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contextualSecondarySidebarStateHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return contextualSecondarySidebarState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$contextualSecondarySidebarStateHash() =>
    r'96e8a7487c59b14e817408e588b71ec7ecc2faef';
