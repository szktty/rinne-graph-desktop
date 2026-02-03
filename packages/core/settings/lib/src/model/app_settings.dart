import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// Application settings model
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(false) bool darkMode,
    @Default('ja') String language,
    @Default(true) bool autoSave,
    @Default(30) int autoSaveInterval,
    @Default({}) Map<String, dynamic> custom,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
