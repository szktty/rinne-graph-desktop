// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'startup_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StartupSettings _$StartupSettingsFromJson(Map<String, dynamic> json) =>
    _StartupSettings(
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

Map<String, dynamic> _$StartupSettingsToJson(
  _StartupSettings instance,
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

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Startup settings provider.

@ProviderFor(StartupSettingsNotifier)
final startupSettingsProvider = StartupSettingsNotifierProvider._();

/// Startup settings provider.
final class StartupSettingsNotifierProvider
    extends $AsyncNotifierProvider<StartupSettingsNotifier, StartupSettings> {
  /// Startup settings provider.
  StartupSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startupSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startupSettingsNotifierHash();

  @$internal
  @override
  StartupSettingsNotifier create() => StartupSettingsNotifier();
}

String _$startupSettingsNotifierHash() =>
    r'f058513565aae37c4d10046437af7bcc236691f7';

/// Startup settings provider.

abstract class _$StartupSettingsNotifier
    extends $AsyncNotifier<StartupSettings> {
  FutureOr<StartupSettings> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<StartupSettings>, StartupSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<StartupSettings>, StartupSettings>,
              AsyncValue<StartupSettings>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Startup settings sync provider (returns default if async not yet loaded).

@ProviderFor(startupSettingsSync)
final startupSettingsSyncProvider = StartupSettingsSyncProvider._();

/// Startup settings sync provider (returns default if async not yet loaded).

final class StartupSettingsSyncProvider
    extends
        $FunctionalProvider<StartupSettings, StartupSettings, StartupSettings>
    with $Provider<StartupSettings> {
  /// Startup settings sync provider (returns default if async not yet loaded).
  StartupSettingsSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startupSettingsSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startupSettingsSyncHash();

  @$internal
  @override
  $ProviderElement<StartupSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StartupSettings create(Ref ref) {
    return startupSettingsSync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StartupSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StartupSettings>(value),
    );
  }
}

String _$startupSettingsSyncHash() =>
    r'8d99fb668bb6408fb987ba5d7e5cfa1e94cf68df';
