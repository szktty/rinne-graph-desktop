import 'dart:ui';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'localization_providers.g.dart';

/// List of supported locales
@riverpod
List<Locale> supportedLocales(SupportedLocalesRef ref) {
  return const [Locale('ja', 'JP'), Locale('en', 'US')];
}

/// Notifier for language switching.
/// This notifier is independent of settings and holds locale state.
/// Use setLocale() to update the locale from outside (e.g., from features_settings).
@riverpod
class LocalizationNotifier extends _$LocalizationNotifier {
  @override
  Locale build() {
    return const Locale('en', 'US');
  }

  /// Sets the locale.
  void setLocale(Locale locale) {
    state = locale;
  }

  /// Switches to Japanese
  void switchToJapanese() {
    setLocale(const Locale('ja', 'JP'));
  }

  /// Switches to English
  void switchToEnglish() {
    setLocale(const Locale('en', 'US'));
  }

  /// Whether the current language is Japanese
  bool get isJapanese => state.languageCode == 'ja';

  /// Whether the current language is English
  bool get isEnglish => state.languageCode == 'en';
}

/// Provider that provides the current locale.
/// Retrieved from LocalizationNotifier state.
@riverpod
Locale currentLocale(CurrentLocaleRef ref) {
  return ref.watch(localizationNotifierProvider);
}
