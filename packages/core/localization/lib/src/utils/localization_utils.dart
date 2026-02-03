import 'dart:ui';

/// Localization-related utility functions
class LocalizationUtils {
  LocalizationUtils._();

  /// List of supported locales
  static const List<Locale> supportedLocales = [
    Locale('ja', 'JP'),
    Locale('en', 'US'),
  ];

  /// Default locale
  static const Locale defaultLocale = Locale('ja', 'JP');

  /// Whether the locale is Japanese
  static bool isJapanese(Locale locale) {
    return locale.languageCode == 'ja';
  }

  /// Whether the locale is English
  static bool isEnglish(Locale locale) {
    return locale.languageCode == 'en';
  }

  /// Gets locale from language code
  static Locale localeFromLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'ja':
        return const Locale('ja', 'JP');
      case 'en':
        return const Locale('en', 'US');
      default:
        return defaultLocale;
    }
  }

  /// Gets display name of the locale
  static String getDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'ja':
        return 'Japanese';
      case 'en':
        return 'English';
      default:
        return locale.languageCode;
    }
  }

  /// Gets detailed display name of the locale
  static String getDetailedDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'ja':
        return 'Japanese';
      case 'en':
        return 'English (United States)';
      default:
        return locale.toString();
    }
  }

  /// Whether the locale is supported
  static bool isSupported(Locale locale) {
    return supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    );
  }

  /// Selects the best locale
  static Locale selectBestLocale(
    List<Locale> supportedLocales,
    Locale? locale,
  ) {
    if (locale != null && isSupported(locale)) {
      return locale;
    }
    return defaultLocale;
  }
}
