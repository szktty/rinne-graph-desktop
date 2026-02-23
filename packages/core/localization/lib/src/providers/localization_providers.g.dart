// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localization_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// List of supported locales

@ProviderFor(supportedLocales)
final supportedLocalesProvider = SupportedLocalesProvider._();

/// List of supported locales

final class SupportedLocalesProvider
    extends $FunctionalProvider<List<Locale>, List<Locale>, List<Locale>>
    with $Provider<List<Locale>> {
  /// List of supported locales
  SupportedLocalesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supportedLocalesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supportedLocalesHash();

  @$internal
  @override
  $ProviderElement<List<Locale>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Locale> create(Ref ref) {
    return supportedLocales(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Locale> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Locale>>(value),
    );
  }
}

String _$supportedLocalesHash() => r'993f584d56ef247295f7a5ce2de8f90561d6e466';

/// Notifier for language switching.
/// This notifier is independent of settings and holds locale state.
/// Use setLocale() to update the locale from outside (e.g., from features_settings).

@ProviderFor(LocalizationNotifier)
final localizationProvider = LocalizationNotifierProvider._();

/// Notifier for language switching.
/// This notifier is independent of settings and holds locale state.
/// Use setLocale() to update the locale from outside (e.g., from features_settings).
final class LocalizationNotifierProvider
    extends $NotifierProvider<LocalizationNotifier, Locale> {
  /// Notifier for language switching.
  /// This notifier is independent of settings and holds locale state.
  /// Use setLocale() to update the locale from outside (e.g., from features_settings).
  LocalizationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localizationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localizationNotifierHash();

  @$internal
  @override
  LocalizationNotifier create() => LocalizationNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$localizationNotifierHash() =>
    r'de37ac94d8c53bbecde2052d4db50cdcb626936b';

/// Notifier for language switching.
/// This notifier is independent of settings and holds locale state.
/// Use setLocale() to update the locale from outside (e.g., from features_settings).

abstract class _$LocalizationNotifier extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider that provides the current locale.
/// Retrieved from LocalizationNotifier state.

@ProviderFor(currentLocale)
final currentLocaleProvider = CurrentLocaleProvider._();

/// Provider that provides the current locale.
/// Retrieved from LocalizationNotifier state.

final class CurrentLocaleProvider
    extends $FunctionalProvider<Locale, Locale, Locale>
    with $Provider<Locale> {
  /// Provider that provides the current locale.
  /// Retrieved from LocalizationNotifier state.
  CurrentLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentLocaleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentLocaleHash();

  @$internal
  @override
  $ProviderElement<Locale> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Locale create(Ref ref) {
    return currentLocale(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$currentLocaleHash() => r'2f4fd247c50eec1ecbebc781d046fdf2e0b9bec6';
