// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sidebar_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the visibility of the primary sidebar.

@ProviderFor(PrimarySidebarState)
final primarySidebarStateProvider = PrimarySidebarStateProvider._();

/// Provider that manages the visibility of the primary sidebar.
final class PrimarySidebarStateProvider
    extends $NotifierProvider<PrimarySidebarState, bool> {
  /// Provider that manages the visibility of the primary sidebar.
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
    r'5244ce21dab0b0e79f232a61bd1e6a045ee867aa';

/// Provider that manages the visibility of the primary sidebar.

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

/// Provider that manages the visibility of the secondary sidebar.

@ProviderFor(SecondarySidebarState)
final secondarySidebarStateProvider = SecondarySidebarStateProvider._();

/// Provider that manages the visibility of the secondary sidebar.
final class SecondarySidebarStateProvider
    extends $NotifierProvider<SecondarySidebarState, bool> {
  /// Provider that manages the visibility of the secondary sidebar.
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
    r'211f6783b5b0ab3b3088aed6347a5e2a09f00dcb';

/// Provider that manages the visibility of the secondary sidebar.

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

/// Provider that manages the per-screen visibility of the secondary sidebar.
///
/// Stores a map from activity bar screen index to sidebar visibility.

@ProviderFor(PerScreenSecondarySidebarState)
final perScreenSecondarySidebarStateProvider =
    PerScreenSecondarySidebarStateProvider._();

/// Provider that manages the per-screen visibility of the secondary sidebar.
///
/// Stores a map from activity bar screen index to sidebar visibility.
final class PerScreenSecondarySidebarStateProvider
    extends $NotifierProvider<PerScreenSecondarySidebarState, Map<int, bool>> {
  /// Provider that manages the per-screen visibility of the secondary sidebar.
  ///
  /// Stores a map from activity bar screen index to sidebar visibility.
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
    r'0ed58f27579ed15edbead6aa47bc64caaa40e52a';

/// Provider that manages the per-screen visibility of the secondary sidebar.
///
/// Stores a map from activity bar screen index to sidebar visibility.

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
