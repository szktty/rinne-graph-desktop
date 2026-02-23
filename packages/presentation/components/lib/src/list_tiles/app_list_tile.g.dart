// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_list_tile.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that supplies an effective AppColorScheme.

@ProviderFor(effectiveAppColorSchemeForListTile)
final effectiveAppColorSchemeForListTileProvider =
    EffectiveAppColorSchemeForListTileProvider._();

/// Provider that supplies an effective AppColorScheme.

final class EffectiveAppColorSchemeForListTileProvider
    extends $FunctionalProvider<AppColorScheme, AppColorScheme, AppColorScheme>
    with $Provider<AppColorScheme> {
  /// Provider that supplies an effective AppColorScheme.
  EffectiveAppColorSchemeForListTileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveAppColorSchemeForListTileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$effectiveAppColorSchemeForListTileHash();

  @$internal
  @override
  $ProviderElement<AppColorScheme> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppColorScheme create(Ref ref) {
    return effectiveAppColorSchemeForListTile(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppColorScheme value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppColorScheme>(value),
    );
  }
}

String _$effectiveAppColorSchemeForListTileHash() =>
    r'59e0f0c272c49df310d0478685a9b4de788bb707';
