// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_container.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that supplies the default padding for AppContainer.

@ProviderFor(appContainerPadding)
final appContainerPaddingProvider = AppContainerPaddingProvider._();

/// Provider that supplies the default padding for AppContainer.

final class AppContainerPaddingProvider
    extends
        $FunctionalProvider<
          EdgeInsetsGeometry,
          EdgeInsetsGeometry,
          EdgeInsetsGeometry
        >
    with $Provider<EdgeInsetsGeometry> {
  /// Provider that supplies the default padding for AppContainer.
  AppContainerPaddingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appContainerPaddingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appContainerPaddingHash();

  @$internal
  @override
  $ProviderElement<EdgeInsetsGeometry> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EdgeInsetsGeometry create(Ref ref) {
    return appContainerPadding(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EdgeInsetsGeometry value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EdgeInsetsGeometry>(value),
    );
  }
}

String _$appContainerPaddingHash() =>
    r'b54b43ea33f23f90737337f72ada3f788d80bc2a';

/// Provider that supplies the leading widget width for AppContainer.

@ProviderFor(appContainerLeadingWidth)
final appContainerLeadingWidthProvider = AppContainerLeadingWidthProvider._();

/// Provider that supplies the leading widget width for AppContainer.

final class AppContainerLeadingWidthProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  /// Provider that supplies the leading widget width for AppContainer.
  AppContainerLeadingWidthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appContainerLeadingWidthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appContainerLeadingWidthHash();

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    return appContainerLeadingWidth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$appContainerLeadingWidthHash() =>
    r'99fdd8134a53bcb15a242b72916d47fd24f29956';
