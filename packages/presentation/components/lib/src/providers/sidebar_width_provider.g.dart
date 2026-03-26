// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sidebar_width_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that manages the width of the primary sidebar.

@ProviderFor(SidebarWidth)
final sidebarWidthProvider = SidebarWidthProvider._();

/// Provider that manages the width of the primary sidebar.
final class SidebarWidthProvider
    extends $NotifierProvider<SidebarWidth, double> {
  /// Provider that manages the width of the primary sidebar.
  SidebarWidthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sidebarWidthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sidebarWidthHash();

  @$internal
  @override
  SidebarWidth create() => SidebarWidth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$sidebarWidthHash() => r'185fbdccd3b99aa5bd2a7a19c00e0f2b3cdf7e5a';

/// Provider that manages the width of the primary sidebar.

abstract class _$SidebarWidth extends $Notifier<double> {
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

/// Provider that manages the width of the secondary sidebar.

@ProviderFor(SecondarySidebarWidth)
final secondarySidebarWidthProvider = SecondarySidebarWidthProvider._();

/// Provider that manages the width of the secondary sidebar.
final class SecondarySidebarWidthProvider
    extends $NotifierProvider<SecondarySidebarWidth, double> {
  /// Provider that manages the width of the secondary sidebar.
  SecondarySidebarWidthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secondarySidebarWidthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secondarySidebarWidthHash();

  @$internal
  @override
  SecondarySidebarWidth create() => SecondarySidebarWidth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$secondarySidebarWidthHash() =>
    r'ebbdec6f15b0501798d064ba057b3cfbd8227cf9';

/// Provider that manages the width of the secondary sidebar.

abstract class _$SecondarySidebarWidth extends $Notifier<double> {
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
