// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_detail_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Management of selection state.

@ProviderFor(SelectedItem)
final selectedItemProvider = SelectedItemProvider._();

/// Management of selection state.
final class SelectedItemProvider
    extends $NotifierProvider<SelectedItem, String?> {
  /// Management of selection state.
  SelectedItemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedItemProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedItemHash();

  @$internal
  @override
  SelectedItem create() => SelectedItem();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedItemHash() => r'6f48932ff07c0d40e789d339dc4d8f949cf939f1';

/// Management of selection state.

abstract class _$SelectedItem extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Management of master width.

@ProviderFor(MasterWidth)
final masterWidthProvider = MasterWidthProvider._();

/// Management of master width.
final class MasterWidthProvider extends $NotifierProvider<MasterWidth, double> {
  /// Management of master width.
  MasterWidthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'masterWidthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$masterWidthHash();

  @$internal
  @override
  MasterWidth create() => MasterWidth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$masterWidthHash() => r'8b00286acec6207bf612e61f81b34c5ed2f63435';

/// Management of master width.

abstract class _$MasterWidth extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Management of detail display visibility.

@ProviderFor(DetailVisibility)
final detailVisibilityProvider = DetailVisibilityProvider._();

/// Management of detail display visibility.
final class DetailVisibilityProvider
    extends $NotifierProvider<DetailVisibility, bool> {
  /// Management of detail display visibility.
  DetailVisibilityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'detailVisibilityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$detailVisibilityHash();

  @$internal
  @override
  DetailVisibility create() => DetailVisibility();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$detailVisibilityHash() => r'11919f895308c35c7892ac952c07723ea9e4adab';

/// Management of detail display visibility.

abstract class _$DetailVisibility extends $Notifier<bool> {
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
