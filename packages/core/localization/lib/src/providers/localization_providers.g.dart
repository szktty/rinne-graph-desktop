// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localization_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentLocaleHash() => r'17f2f5d47095bd2708c5767e7cda4554b6edec5c';

/// Provider that provides the current locale
/// Retrieved from settings and automatically updated when settings change
///
/// Copied from [currentLocale].
@ProviderFor(currentLocale)
final currentLocaleProvider = AutoDisposeProvider<Locale>.internal(
  currentLocale,
  name: r'currentLocaleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentLocaleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentLocaleRef = AutoDisposeProviderRef<Locale>;
String _$supportedLocalesHash() => r'993f584d56ef247295f7a5ce2de8f90561d6e466';

/// List of supported locales
///
/// Copied from [supportedLocales].
@ProviderFor(supportedLocales)
final supportedLocalesProvider = AutoDisposeProvider<List<Locale>>.internal(
  supportedLocales,
  name: r'supportedLocalesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$supportedLocalesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SupportedLocalesRef = AutoDisposeProviderRef<List<Locale>>;
String _$localizationNotifierHash() =>
    r'02a0d8b2b105767557a24b8c41371545718fee80';

/// Notifier for language switching
///
/// Copied from [LocalizationNotifier].
@ProviderFor(LocalizationNotifier)
final localizationNotifierProvider =
    AutoDisposeNotifierProvider<LocalizationNotifier, Locale>.internal(
      LocalizationNotifier.new,
      name: r'localizationNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$localizationNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LocalizationNotifier = AutoDisposeNotifier<Locale>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
