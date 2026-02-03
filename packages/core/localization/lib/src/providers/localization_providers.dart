import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core_settings/core_settings.dart';

part 'localization_providers.g.dart';

/// Provider that provides the current locale
/// Retrieved from settings and automatically updated when settings change
@riverpod
Locale currentLocale(CurrentLocaleRef ref) {
  final settings = ref.watch(settingsManagerProvider);
  return settings.locale;
}

/// List of supported locales
@riverpod
List<Locale> supportedLocales(SupportedLocalesRef ref) {
  return const [Locale('ja', 'JP'), Locale('en', 'US')];
}

/// Notifier for language switching
@riverpod
class LocalizationNotifier extends _$LocalizationNotifier {
  @override
  Locale build() {
    return ref.watch(currentLocaleProvider);
  }

  /// Changes the language
  void changeLanguage(Locale locale) {
    final settingsNotifier = ref.read(settingsManagerProvider.notifier);
    settingsNotifier.updateSettings(
      ref
          .read(settingsManagerProvider)
          .copyWith(language: locale.languageCode, locale: locale),
    );
  }

  /// Switches to Japanese
  void switchToJapanese() {
    changeLanguage(const Locale('ja', 'JP'));
  }

  /// Switches to English
  void switchToEnglish() {
    changeLanguage(const Locale('en', 'US'));
  }

  /// Whether the current language is Japanese
  bool get isJapanese => state.languageCode == 'ja';

  /// Whether the current language is English
  bool get isEnglish => state.languageCode == 'en';
}
