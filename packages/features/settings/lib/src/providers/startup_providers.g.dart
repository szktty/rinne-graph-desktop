// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'startup_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StartupSettingsImpl _$$StartupSettingsImplFromJson(
  Map<String, dynamic> json,
) => _$StartupSettingsImpl(
  autoOpenLastStack: json['autoOpenLastStack'] as bool? ?? false,
  lastOpenedStackPath: json['lastOpenedStackPath'] as String?,
  errorBehavior:
      $enumDecodeNullable(
        _$StartupErrorBehaviorEnumMap,
        json['errorBehavior'],
      ) ??
      StartupErrorBehavior.showWelcome,
  isFirstLaunch: json['isFirstLaunch'] as bool? ?? true,
  enableSampleStackAutoGeneration:
      json['enableSampleStackAutoGeneration'] as bool? ?? true,
);

Map<String, dynamic> _$$StartupSettingsImplToJson(
  _$StartupSettingsImpl instance,
) => <String, dynamic>{
  'autoOpenLastStack': instance.autoOpenLastStack,
  'lastOpenedStackPath': instance.lastOpenedStackPath,
  'errorBehavior': _$StartupErrorBehaviorEnumMap[instance.errorBehavior]!,
  'isFirstLaunch': instance.isFirstLaunch,
  'enableSampleStackAutoGeneration': instance.enableSampleStackAutoGeneration,
};

const _$StartupErrorBehaviorEnumMap = {
  StartupErrorBehavior.showWelcome: 'showWelcome',
  StartupErrorBehavior.showError: 'showError',
  StartupErrorBehavior.openLastSuccessful: 'openLastSuccessful',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$startupSettingsHash() => r'67a30e14f69af12d40edaa2fca11a600abb784be';

/// Startup settings provider.
///
/// Copied from [startupSettings].
@ProviderFor(startupSettings)
final startupSettingsProvider = Provider<StartupSettings>.internal(
  startupSettings,
  name: r'startupSettingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$startupSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StartupSettingsRef = ProviderRef<StartupSettings>;
String _$startupSettingsNotifierHash() =>
    r'f058513565aae37c4d10046437af7bcc236691f7';

/// Startup settings provider.
///
/// Copied from [StartupSettingsNotifier].
@ProviderFor(StartupSettingsNotifier)
final startupSettingsNotifierProvider =
    AsyncNotifierProvider<StartupSettingsNotifier, StartupSettings>.internal(
      StartupSettingsNotifier.new,
      name: r'startupSettingsNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$startupSettingsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$StartupSettingsNotifier = AsyncNotifier<StartupSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
