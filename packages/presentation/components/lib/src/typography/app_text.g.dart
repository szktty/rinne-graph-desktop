// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_text.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for effective theme data

@ProviderFor(effectiveThemeDataForText)
final effectiveThemeDataForTextProvider = EffectiveThemeDataForTextProvider._();

/// Provider for effective theme data

final class EffectiveThemeDataForTextProvider
    extends $FunctionalProvider<AppThemeData, AppThemeData, AppThemeData>
    with $Provider<AppThemeData> {
  /// Provider for effective theme data
  EffectiveThemeDataForTextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveThemeDataForTextProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$effectiveThemeDataForTextHash();

  @$internal
  @override
  $ProviderElement<AppThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppThemeData create(Ref ref) {
    return effectiveThemeDataForText(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppThemeData>(value),
    );
  }
}

String _$effectiveThemeDataForTextHash() =>
    r'f587fec324348c1bb953a477750654175d69946b';
