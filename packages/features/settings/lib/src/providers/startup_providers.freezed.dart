// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'startup_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StartupSettings _$StartupSettingsFromJson(Map<String, dynamic> json) {
  return _StartupSettings.fromJson(json);
}

/// @nodoc
mixin _$StartupSettings {
  /// Whether to automatically open the last opened stack on startup.
  bool get autoOpenLastStack => throw _privateConstructorUsedError;

  /// Path of the last opened stack.
  String? get lastOpenedStackPath => throw _privateConstructorUsedError;

  /// Behavior when stack is not found.
  StartupErrorBehavior get errorBehavior => throw _privateConstructorUsedError;

  /// Whether it is the first launch of the app.
  bool get isFirstLaunch => throw _privateConstructorUsedError;

  /// Whether to enable sample stack auto-generation.
  bool get enableSampleStackAutoGeneration =>
      throw _privateConstructorUsedError;

  /// Serializes this StartupSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StartupSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StartupSettingsCopyWith<StartupSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StartupSettingsCopyWith<$Res> {
  factory $StartupSettingsCopyWith(
    StartupSettings value,
    $Res Function(StartupSettings) then,
  ) = _$StartupSettingsCopyWithImpl<$Res, StartupSettings>;
  @useResult
  $Res call({
    bool autoOpenLastStack,
    String? lastOpenedStackPath,
    StartupErrorBehavior errorBehavior,
    bool isFirstLaunch,
    bool enableSampleStackAutoGeneration,
  });
}

/// @nodoc
class _$StartupSettingsCopyWithImpl<$Res, $Val extends StartupSettings>
    implements $StartupSettingsCopyWith<$Res> {
  _$StartupSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StartupSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoOpenLastStack = null,
    Object? lastOpenedStackPath = freezed,
    Object? errorBehavior = null,
    Object? isFirstLaunch = null,
    Object? enableSampleStackAutoGeneration = null,
  }) {
    return _then(
      _value.copyWith(
            autoOpenLastStack:
                null == autoOpenLastStack
                    ? _value.autoOpenLastStack
                    : autoOpenLastStack // ignore: cast_nullable_to_non_nullable
                        as bool,
            lastOpenedStackPath:
                freezed == lastOpenedStackPath
                    ? _value.lastOpenedStackPath
                    : lastOpenedStackPath // ignore: cast_nullable_to_non_nullable
                        as String?,
            errorBehavior:
                null == errorBehavior
                    ? _value.errorBehavior
                    : errorBehavior // ignore: cast_nullable_to_non_nullable
                        as StartupErrorBehavior,
            isFirstLaunch:
                null == isFirstLaunch
                    ? _value.isFirstLaunch
                    : isFirstLaunch // ignore: cast_nullable_to_non_nullable
                        as bool,
            enableSampleStackAutoGeneration:
                null == enableSampleStackAutoGeneration
                    ? _value.enableSampleStackAutoGeneration
                    : enableSampleStackAutoGeneration // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StartupSettingsImplCopyWith<$Res>
    implements $StartupSettingsCopyWith<$Res> {
  factory _$$StartupSettingsImplCopyWith(
    _$StartupSettingsImpl value,
    $Res Function(_$StartupSettingsImpl) then,
  ) = __$$StartupSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool autoOpenLastStack,
    String? lastOpenedStackPath,
    StartupErrorBehavior errorBehavior,
    bool isFirstLaunch,
    bool enableSampleStackAutoGeneration,
  });
}

/// @nodoc
class __$$StartupSettingsImplCopyWithImpl<$Res>
    extends _$StartupSettingsCopyWithImpl<$Res, _$StartupSettingsImpl>
    implements _$$StartupSettingsImplCopyWith<$Res> {
  __$$StartupSettingsImplCopyWithImpl(
    _$StartupSettingsImpl _value,
    $Res Function(_$StartupSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StartupSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoOpenLastStack = null,
    Object? lastOpenedStackPath = freezed,
    Object? errorBehavior = null,
    Object? isFirstLaunch = null,
    Object? enableSampleStackAutoGeneration = null,
  }) {
    return _then(
      _$StartupSettingsImpl(
        autoOpenLastStack:
            null == autoOpenLastStack
                ? _value.autoOpenLastStack
                : autoOpenLastStack // ignore: cast_nullable_to_non_nullable
                    as bool,
        lastOpenedStackPath:
            freezed == lastOpenedStackPath
                ? _value.lastOpenedStackPath
                : lastOpenedStackPath // ignore: cast_nullable_to_non_nullable
                    as String?,
        errorBehavior:
            null == errorBehavior
                ? _value.errorBehavior
                : errorBehavior // ignore: cast_nullable_to_non_nullable
                    as StartupErrorBehavior,
        isFirstLaunch:
            null == isFirstLaunch
                ? _value.isFirstLaunch
                : isFirstLaunch // ignore: cast_nullable_to_non_nullable
                    as bool,
        enableSampleStackAutoGeneration:
            null == enableSampleStackAutoGeneration
                ? _value.enableSampleStackAutoGeneration
                : enableSampleStackAutoGeneration // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StartupSettingsImpl implements _StartupSettings {
  const _$StartupSettingsImpl({
    this.autoOpenLastStack = false,
    this.lastOpenedStackPath,
    this.errorBehavior = StartupErrorBehavior.showWelcome,
    this.isFirstLaunch = true,
    this.enableSampleStackAutoGeneration = true,
  });

  factory _$StartupSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$StartupSettingsImplFromJson(json);

  /// Whether to automatically open the last opened stack on startup.
  @override
  @JsonKey()
  final bool autoOpenLastStack;

  /// Path of the last opened stack.
  @override
  final String? lastOpenedStackPath;

  /// Behavior when stack is not found.
  @override
  @JsonKey()
  final StartupErrorBehavior errorBehavior;

  /// Whether it is the first launch of the app.
  @override
  @JsonKey()
  final bool isFirstLaunch;

  /// Whether to enable sample stack auto-generation.
  @override
  @JsonKey()
  final bool enableSampleStackAutoGeneration;

  @override
  String toString() {
    return 'StartupSettings(autoOpenLastStack: $autoOpenLastStack, lastOpenedStackPath: $lastOpenedStackPath, errorBehavior: $errorBehavior, isFirstLaunch: $isFirstLaunch, enableSampleStackAutoGeneration: $enableSampleStackAutoGeneration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartupSettingsImpl &&
            (identical(other.autoOpenLastStack, autoOpenLastStack) ||
                other.autoOpenLastStack == autoOpenLastStack) &&
            (identical(other.lastOpenedStackPath, lastOpenedStackPath) ||
                other.lastOpenedStackPath == lastOpenedStackPath) &&
            (identical(other.errorBehavior, errorBehavior) ||
                other.errorBehavior == errorBehavior) &&
            (identical(other.isFirstLaunch, isFirstLaunch) ||
                other.isFirstLaunch == isFirstLaunch) &&
            (identical(
                  other.enableSampleStackAutoGeneration,
                  enableSampleStackAutoGeneration,
                ) ||
                other.enableSampleStackAutoGeneration ==
                    enableSampleStackAutoGeneration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    autoOpenLastStack,
    lastOpenedStackPath,
    errorBehavior,
    isFirstLaunch,
    enableSampleStackAutoGeneration,
  );

  /// Create a copy of StartupSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartupSettingsImplCopyWith<_$StartupSettingsImpl> get copyWith =>
      __$$StartupSettingsImplCopyWithImpl<_$StartupSettingsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StartupSettingsImplToJson(this);
  }
}

abstract class _StartupSettings implements StartupSettings {
  const factory _StartupSettings({
    final bool autoOpenLastStack,
    final String? lastOpenedStackPath,
    final StartupErrorBehavior errorBehavior,
    final bool isFirstLaunch,
    final bool enableSampleStackAutoGeneration,
  }) = _$StartupSettingsImpl;

  factory _StartupSettings.fromJson(Map<String, dynamic> json) =
      _$StartupSettingsImpl.fromJson;

  /// Whether to automatically open the last opened stack on startup.
  @override
  bool get autoOpenLastStack;

  /// Path of the last opened stack.
  @override
  String? get lastOpenedStackPath;

  /// Behavior when stack is not found.
  @override
  StartupErrorBehavior get errorBehavior;

  /// Whether it is the first launch of the app.
  @override
  bool get isFirstLaunch;

  /// Whether to enable sample stack auto-generation.
  @override
  bool get enableSampleStackAutoGeneration;

  /// Create a copy of StartupSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartupSettingsImplCopyWith<_$StartupSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
