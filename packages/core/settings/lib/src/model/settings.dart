import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';

part 'settings.g.dart';

@freezed
abstract class Settings with _$Settings {
  const factory Settings({
    @Default('en') String language,
    @Default(Locale('en', 'US')) @LocaleConverter() Locale locale,
    @Default(true) bool enableAutoSave,
    @Default(15) int autoSaveInterval,
    @Default('system') String activeThemeName,
    @Default(true) bool followSystemTheme,
    @Default(true) bool enableAnimations,
    @Default('blue') String themeColorType,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  /// Returns the default settings.
  static Settings defaults() {
    return const Settings(
      language: 'en',
      locale: Locale('en', 'US'),
      enableAutoSave: true,
      autoSaveInterval: 15,
      activeThemeName: 'system',
      followSystemTheme: true,
      enableAnimations: true,
      themeColorType: 'blue',
    );
  }
}

/// Converter for serializing Locale to JSON.
class LocaleConverter implements JsonConverter<Locale, Map<String, dynamic>> {
  const LocaleConverter();

  @override
  Locale fromJson(Map<String, dynamic> json) =>
      Locale(json['languageCode'] as String, json['countryCode'] as String);

  @override
  Map<String, dynamic> toJson(Locale locale) => {
    'languageCode': locale.languageCode,
    'countryCode': locale.countryCode,
  };
}
