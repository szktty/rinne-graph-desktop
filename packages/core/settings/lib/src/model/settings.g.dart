// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsImpl _$$SettingsImplFromJson(Map<String, dynamic> json) =>
    _$SettingsImpl(
      language: json['language'] as String? ?? 'en',
      locale:
          json['locale'] == null
              ? const Locale('en', 'US')
              : const LocaleConverter().fromJson(
                json['locale'] as Map<String, dynamic>,
              ),
      enableAutoSave: json['enableAutoSave'] as bool? ?? true,
      autoSaveInterval: (json['autoSaveInterval'] as num?)?.toInt() ?? 15,
      activeThemeName: json['activeThemeName'] as String? ?? 'system',
      followSystemTheme: json['followSystemTheme'] as bool? ?? true,
      enableAnimations: json['enableAnimations'] as bool? ?? true,
      themeColorType: json['themeColorType'] as String? ?? 'blue',
    );

Map<String, dynamic> _$$SettingsImplToJson(_$SettingsImpl instance) =>
    <String, dynamic>{
      'language': instance.language,
      'locale': const LocaleConverter().toJson(instance.locale),
      'enableAutoSave': instance.enableAutoSave,
      'autoSaveInterval': instance.autoSaveInterval,
      'activeThemeName': instance.activeThemeName,
      'followSystemTheme': instance.followSystemTheme,
      'enableAnimations': instance.enableAnimations,
      'themeColorType': instance.themeColorType,
    };
