// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppConfigImpl _$$AppConfigImplFromJson(Map<String, dynamic> json) =>
    _$AppConfigImpl(
      name: json['name'] as String? ?? 'default',
      description: json['description'] as String?,
      debug:
          json['debug'] == null
              ? const DebugConfig()
              : DebugConfig.fromJson(json['debug'] as Map<String, dynamic>),
      startup:
          json['startup'] == null
              ? const StartupConfig()
              : StartupConfig.fromJson(json['startup'] as Map<String, dynamic>),
      development:
          json['development'] == null
              ? const DevelopmentConfig()
              : DevelopmentConfig.fromJson(
                json['development'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$$AppConfigImplToJson(_$AppConfigImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'debug': instance.debug,
      'startup': instance.startup,
      'development': instance.development,
    };

_$DebugConfigImpl _$$DebugConfigImplFromJson(Map<String, dynamic> json) =>
    _$DebugConfigImpl(
      forceDebugMode: json['forceDebugMode'] as bool? ?? null,
      enableDebugLogging: json['enableDebugLogging'] as bool? ?? null,
      enableScreenshotServer: json['enableScreenshotServer'] as bool? ?? false,
      enableVerboseLogging: json['enableVerboseLogging'] as bool? ?? false,
    );

Map<String, dynamic> _$$DebugConfigImplToJson(_$DebugConfigImpl instance) =>
    <String, dynamic>{
      'forceDebugMode': instance.forceDebugMode,
      'enableDebugLogging': instance.enableDebugLogging,
      'enableScreenshotServer': instance.enableScreenshotServer,
      'enableVerboseLogging': instance.enableVerboseLogging,
    };

_$StartupConfigImpl _$$StartupConfigImplFromJson(Map<String, dynamic> json) =>
    _$StartupConfigImpl(
      autoOpenLastStack: json['autoOpenLastStack'] as bool? ?? null,
      lastOpenedStackPath: json['lastOpenedStackPath'] as String? ?? null,
      errorBehavior:
          $enumDecodeNullable(
            _$StartupErrorBehaviorEnumMap,
            json['errorBehavior'],
          ) ??
          null,
      isFirstLaunch: json['isFirstLaunch'] as bool? ?? null,
      enableSampleStackAutoGeneration:
          json['enableSampleStackAutoGeneration'] as bool? ?? null,
      enableDevStacks: json['enableDevStacks'] as bool? ?? false,
    );

Map<String, dynamic> _$$StartupConfigImplToJson(
  _$StartupConfigImpl instance,
) => <String, dynamic>{
  'autoOpenLastStack': instance.autoOpenLastStack,
  'lastOpenedStackPath': instance.lastOpenedStackPath,
  'errorBehavior': _$StartupErrorBehaviorEnumMap[instance.errorBehavior],
  'isFirstLaunch': instance.isFirstLaunch,
  'enableSampleStackAutoGeneration': instance.enableSampleStackAutoGeneration,
  'enableDevStacks': instance.enableDevStacks,
};

const _$StartupErrorBehaviorEnumMap = {
  StartupErrorBehavior.showWelcome: 'showWelcome',
  StartupErrorBehavior.showError: 'showError',
  StartupErrorBehavior.openLastSuccessful: 'openLastSuccessful',
};

_$DevelopmentConfigImpl _$$DevelopmentConfigImplFromJson(
  Map<String, dynamic> json,
) => _$DevelopmentConfigImpl(
  resetAllSettings: json['resetAllSettings'] as bool? ?? false,
  resetDatabase: json['resetDatabase'] as bool? ?? false,
  generateTestData: json['generateTestData'] as bool? ?? false,
  enableUiDevMode: json['enableUiDevMode'] as bool? ?? false,
);

Map<String, dynamic> _$$DevelopmentConfigImplToJson(
  _$DevelopmentConfigImpl instance,
) => <String, dynamic>{
  'resetAllSettings': instance.resetAllSettings,
  'resetDatabase': instance.resetDatabase,
  'generateTestData': instance.generateTestData,
  'enableUiDevMode': instance.enableUiDevMode,
};
