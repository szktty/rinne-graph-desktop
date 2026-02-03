import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Extension methods for BuildContext
/// Provides concise access to localized strings
extension LocalizationExtensions on BuildContext {
  /// Concise access to AppLocalizations
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Current locale
  Locale get locale => Localizations.localeOf(this);

  /// Current language code
  String get languageCode => locale.languageCode;

  /// Whether it is Japanese
  bool get isJapanese => languageCode == 'ja';

  /// Whether it is English
  bool get isEnglish => languageCode == 'en';
}
