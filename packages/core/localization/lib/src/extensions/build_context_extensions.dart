/*
 * Copyright (c) 2026 SUZUKI Tetsuya
 * SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Commercial
 *
 * This file is part of RinneGraph.
 * For commercial licensing inquiries, please contact: contact@szktty.jp
 */

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
