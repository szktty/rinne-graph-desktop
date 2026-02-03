// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) {
  return _AppConfig.fromJson(json);
}

/// @nodoc
mixin _$AppConfig {
  /// Configuration name (for identification)
  String get name => throw _privateConstructorUsedError;

  /// Configuration description
  String? get description => throw _privateConstructorUsedError;

  /// Debug-related configuration
  DebugConfig get debug => throw _privateConstructorUsedError;

  /// Startup configuration
  StartupConfig get startup => throw _privateConstructorUsedError;

  /// Development configuration
  DevelopmentConfig get development => throw _privateConstructorUsedError;

  /// Serializes this AppConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppConfigCopyWith<AppConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppConfigCopyWith<$Res> {
  factory $AppConfigCopyWith(AppConfig value, $Res Function(AppConfig) then) =
      _$AppConfigCopyWithImpl<$Res, AppConfig>;
  @useResult
  $Res call({
    String name,
    String? description,
    DebugConfig debug,
    StartupConfig startup,
    DevelopmentConfig development,
  });

  $DebugConfigCopyWith<$Res> get debug;
  $StartupConfigCopyWith<$Res> get startup;
  $DevelopmentConfigCopyWith<$Res> get development;
}

/// @nodoc
class _$AppConfigCopyWithImpl<$Res, $Val extends AppConfig>
    implements $AppConfigCopyWith<$Res> {
  _$AppConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = freezed,
    Object? debug = null,
    Object? startup = null,
    Object? development = null,
  }) {
    return _then(
      _value.copyWith(
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            debug:
                null == debug
                    ? _value.debug
                    : debug // ignore: cast_nullable_to_non_nullable
                        as DebugConfig,
            startup:
                null == startup
                    ? _value.startup
                    : startup // ignore: cast_nullable_to_non_nullable
                        as StartupConfig,
            development:
                null == development
                    ? _value.development
                    : development // ignore: cast_nullable_to_non_nullable
                        as DevelopmentConfig,
          )
          as $Val,
    );
  }

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DebugConfigCopyWith<$Res> get debug {
    return $DebugConfigCopyWith<$Res>(_value.debug, (value) {
      return _then(_value.copyWith(debug: value) as $Val);
    });
  }

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StartupConfigCopyWith<$Res> get startup {
    return $StartupConfigCopyWith<$Res>(_value.startup, (value) {
      return _then(_value.copyWith(startup: value) as $Val);
    });
  }

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DevelopmentConfigCopyWith<$Res> get development {
    return $DevelopmentConfigCopyWith<$Res>(_value.development, (value) {
      return _then(_value.copyWith(development: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppConfigImplCopyWith<$Res>
    implements $AppConfigCopyWith<$Res> {
  factory _$$AppConfigImplCopyWith(
    _$AppConfigImpl value,
    $Res Function(_$AppConfigImpl) then,
  ) = __$$AppConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String? description,
    DebugConfig debug,
    StartupConfig startup,
    DevelopmentConfig development,
  });

  @override
  $DebugConfigCopyWith<$Res> get debug;
  @override
  $StartupConfigCopyWith<$Res> get startup;
  @override
  $DevelopmentConfigCopyWith<$Res> get development;
}

/// @nodoc
class __$$AppConfigImplCopyWithImpl<$Res>
    extends _$AppConfigCopyWithImpl<$Res, _$AppConfigImpl>
    implements _$$AppConfigImplCopyWith<$Res> {
  __$$AppConfigImplCopyWithImpl(
    _$AppConfigImpl _value,
    $Res Function(_$AppConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = freezed,
    Object? debug = null,
    Object? startup = null,
    Object? development = null,
  }) {
    return _then(
      _$AppConfigImpl(
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        debug:
            null == debug
                ? _value.debug
                : debug // ignore: cast_nullable_to_non_nullable
                    as DebugConfig,
        startup:
            null == startup
                ? _value.startup
                : startup // ignore: cast_nullable_to_non_nullable
                    as StartupConfig,
        development:
            null == development
                ? _value.development
                : development // ignore: cast_nullable_to_non_nullable
                    as DevelopmentConfig,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppConfigImpl implements _AppConfig {
  const _$AppConfigImpl({
    this.name = 'default',
    this.description,
    this.debug = const DebugConfig(),
    this.startup = const StartupConfig(),
    this.development = const DevelopmentConfig(),
  });

  factory _$AppConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppConfigImplFromJson(json);

  /// Configuration name (for identification)
  @override
  @JsonKey()
  final String name;

  /// Configuration description
  @override
  final String? description;

  /// Debug-related configuration
  @override
  @JsonKey()
  final DebugConfig debug;

  /// Startup configuration
  @override
  @JsonKey()
  final StartupConfig startup;

  /// Development configuration
  @override
  @JsonKey()
  final DevelopmentConfig development;

  @override
  String toString() {
    return 'AppConfig(name: $name, description: $description, debug: $debug, startup: $startup, development: $development)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppConfigImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.debug, debug) || other.debug == debug) &&
            (identical(other.startup, startup) || other.startup == startup) &&
            (identical(other.development, development) ||
                other.development == development));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, description, debug, startup, development);

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppConfigImplCopyWith<_$AppConfigImpl> get copyWith =>
      __$$AppConfigImplCopyWithImpl<_$AppConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppConfigImplToJson(this);
  }
}

abstract class _AppConfig implements AppConfig {
  const factory _AppConfig({
    final String name,
    final String? description,
    final DebugConfig debug,
    final StartupConfig startup,
    final DevelopmentConfig development,
  }) = _$AppConfigImpl;

  factory _AppConfig.fromJson(Map<String, dynamic> json) =
      _$AppConfigImpl.fromJson;

  /// Configuration name (for identification)
  @override
  String get name;

  /// Configuration description
  @override
  String? get description;

  /// Debug-related configuration
  @override
  DebugConfig get debug;

  /// Startup configuration
  @override
  StartupConfig get startup;

  /// Development configuration
  @override
  DevelopmentConfig get development;

  /// Create a copy of AppConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppConfigImplCopyWith<_$AppConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DebugConfig _$DebugConfigFromJson(Map<String, dynamic> json) {
  return _DebugConfig.fromJson(json);
}

/// @nodoc
mixin _$DebugConfig {
  /// Whether to force enable debug mode
  bool? get forceDebugMode => throw _privateConstructorUsedError;

  /// Whether to enable debug logging
  bool? get enableDebugLogging => throw _privateConstructorUsedError;

  /// Whether to enable screenshot server
  bool get enableScreenshotServer => throw _privateConstructorUsedError;

  /// Whether to enable verbose logging
  bool get enableVerboseLogging => throw _privateConstructorUsedError;

  /// Serializes this DebugConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DebugConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DebugConfigCopyWith<DebugConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DebugConfigCopyWith<$Res> {
  factory $DebugConfigCopyWith(
    DebugConfig value,
    $Res Function(DebugConfig) then,
  ) = _$DebugConfigCopyWithImpl<$Res, DebugConfig>;
  @useResult
  $Res call({
    bool? forceDebugMode,
    bool? enableDebugLogging,
    bool enableScreenshotServer,
    bool enableVerboseLogging,
  });
}

/// @nodoc
class _$DebugConfigCopyWithImpl<$Res, $Val extends DebugConfig>
    implements $DebugConfigCopyWith<$Res> {
  _$DebugConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DebugConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? forceDebugMode = freezed,
    Object? enableDebugLogging = freezed,
    Object? enableScreenshotServer = null,
    Object? enableVerboseLogging = null,
  }) {
    return _then(
      _value.copyWith(
            forceDebugMode:
                freezed == forceDebugMode
                    ? _value.forceDebugMode
                    : forceDebugMode // ignore: cast_nullable_to_non_nullable
                        as bool?,
            enableDebugLogging:
                freezed == enableDebugLogging
                    ? _value.enableDebugLogging
                    : enableDebugLogging // ignore: cast_nullable_to_non_nullable
                        as bool?,
            enableScreenshotServer:
                null == enableScreenshotServer
                    ? _value.enableScreenshotServer
                    : enableScreenshotServer // ignore: cast_nullable_to_non_nullable
                        as bool,
            enableVerboseLogging:
                null == enableVerboseLogging
                    ? _value.enableVerboseLogging
                    : enableVerboseLogging // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DebugConfigImplCopyWith<$Res>
    implements $DebugConfigCopyWith<$Res> {
  factory _$$DebugConfigImplCopyWith(
    _$DebugConfigImpl value,
    $Res Function(_$DebugConfigImpl) then,
  ) = __$$DebugConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool? forceDebugMode,
    bool? enableDebugLogging,
    bool enableScreenshotServer,
    bool enableVerboseLogging,
  });
}

/// @nodoc
class __$$DebugConfigImplCopyWithImpl<$Res>
    extends _$DebugConfigCopyWithImpl<$Res, _$DebugConfigImpl>
    implements _$$DebugConfigImplCopyWith<$Res> {
  __$$DebugConfigImplCopyWithImpl(
    _$DebugConfigImpl _value,
    $Res Function(_$DebugConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DebugConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? forceDebugMode = freezed,
    Object? enableDebugLogging = freezed,
    Object? enableScreenshotServer = null,
    Object? enableVerboseLogging = null,
  }) {
    return _then(
      _$DebugConfigImpl(
        forceDebugMode:
            freezed == forceDebugMode
                ? _value.forceDebugMode
                : forceDebugMode // ignore: cast_nullable_to_non_nullable
                    as bool?,
        enableDebugLogging:
            freezed == enableDebugLogging
                ? _value.enableDebugLogging
                : enableDebugLogging // ignore: cast_nullable_to_non_nullable
                    as bool?,
        enableScreenshotServer:
            null == enableScreenshotServer
                ? _value.enableScreenshotServer
                : enableScreenshotServer // ignore: cast_nullable_to_non_nullable
                    as bool,
        enableVerboseLogging:
            null == enableVerboseLogging
                ? _value.enableVerboseLogging
                : enableVerboseLogging // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DebugConfigImpl implements _DebugConfig {
  const _$DebugConfigImpl({
    this.forceDebugMode = null,
    this.enableDebugLogging = null,
    this.enableScreenshotServer = false,
    this.enableVerboseLogging = false,
  });

  factory _$DebugConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$DebugConfigImplFromJson(json);

  /// Whether to force enable debug mode
  @override
  @JsonKey()
  final bool? forceDebugMode;

  /// Whether to enable debug logging
  @override
  @JsonKey()
  final bool? enableDebugLogging;

  /// Whether to enable screenshot server
  @override
  @JsonKey()
  final bool enableScreenshotServer;

  /// Whether to enable verbose logging
  @override
  @JsonKey()
  final bool enableVerboseLogging;

  @override
  String toString() {
    return 'DebugConfig(forceDebugMode: $forceDebugMode, enableDebugLogging: $enableDebugLogging, enableScreenshotServer: $enableScreenshotServer, enableVerboseLogging: $enableVerboseLogging)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DebugConfigImpl &&
            (identical(other.forceDebugMode, forceDebugMode) ||
                other.forceDebugMode == forceDebugMode) &&
            (identical(other.enableDebugLogging, enableDebugLogging) ||
                other.enableDebugLogging == enableDebugLogging) &&
            (identical(other.enableScreenshotServer, enableScreenshotServer) ||
                other.enableScreenshotServer == enableScreenshotServer) &&
            (identical(other.enableVerboseLogging, enableVerboseLogging) ||
                other.enableVerboseLogging == enableVerboseLogging));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    forceDebugMode,
    enableDebugLogging,
    enableScreenshotServer,
    enableVerboseLogging,
  );

  /// Create a copy of DebugConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DebugConfigImplCopyWith<_$DebugConfigImpl> get copyWith =>
      __$$DebugConfigImplCopyWithImpl<_$DebugConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DebugConfigImplToJson(this);
  }
}

abstract class _DebugConfig implements DebugConfig {
  const factory _DebugConfig({
    final bool? forceDebugMode,
    final bool? enableDebugLogging,
    final bool enableScreenshotServer,
    final bool enableVerboseLogging,
  }) = _$DebugConfigImpl;

  factory _DebugConfig.fromJson(Map<String, dynamic> json) =
      _$DebugConfigImpl.fromJson;

  /// Whether to force enable debug mode
  @override
  bool? get forceDebugMode;

  /// Whether to enable debug logging
  @override
  bool? get enableDebugLogging;

  /// Whether to enable screenshot server
  @override
  bool get enableScreenshotServer;

  /// Whether to enable verbose logging
  @override
  bool get enableVerboseLogging;

  /// Create a copy of DebugConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DebugConfigImplCopyWith<_$DebugConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StartupConfig _$StartupConfigFromJson(Map<String, dynamic> json) {
  return _StartupConfig.fromJson(json);
}

/// @nodoc
mixin _$StartupConfig {
  /// Whether to automatically open the last opened stack on startup
  bool? get autoOpenLastStack => throw _privateConstructorUsedError;

  /// Path of the last opened stack (usually null in config file)
  String? get lastOpenedStackPath => throw _privateConstructorUsedError;

  /// Behavior when stack is not found
  StartupErrorBehavior? get errorBehavior => throw _privateConstructorUsedError;

  /// Whether this is the first launch of the app (usually null in config file)
  bool? get isFirstLaunch => throw _privateConstructorUsedError;

  /// Whether to enable sample stack auto-generation
  bool? get enableSampleStackAutoGeneration =>
      throw _privateConstructorUsedError;

  /// Whether to enable development stacks
  bool get enableDevStacks => throw _privateConstructorUsedError;

  /// Serializes this StartupConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StartupConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StartupConfigCopyWith<StartupConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StartupConfigCopyWith<$Res> {
  factory $StartupConfigCopyWith(
    StartupConfig value,
    $Res Function(StartupConfig) then,
  ) = _$StartupConfigCopyWithImpl<$Res, StartupConfig>;
  @useResult
  $Res call({
    bool? autoOpenLastStack,
    String? lastOpenedStackPath,
    StartupErrorBehavior? errorBehavior,
    bool? isFirstLaunch,
    bool? enableSampleStackAutoGeneration,
    bool enableDevStacks,
  });
}

/// @nodoc
class _$StartupConfigCopyWithImpl<$Res, $Val extends StartupConfig>
    implements $StartupConfigCopyWith<$Res> {
  _$StartupConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StartupConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoOpenLastStack = freezed,
    Object? lastOpenedStackPath = freezed,
    Object? errorBehavior = freezed,
    Object? isFirstLaunch = freezed,
    Object? enableSampleStackAutoGeneration = freezed,
    Object? enableDevStacks = null,
  }) {
    return _then(
      _value.copyWith(
            autoOpenLastStack:
                freezed == autoOpenLastStack
                    ? _value.autoOpenLastStack
                    : autoOpenLastStack // ignore: cast_nullable_to_non_nullable
                        as bool?,
            lastOpenedStackPath:
                freezed == lastOpenedStackPath
                    ? _value.lastOpenedStackPath
                    : lastOpenedStackPath // ignore: cast_nullable_to_non_nullable
                        as String?,
            errorBehavior:
                freezed == errorBehavior
                    ? _value.errorBehavior
                    : errorBehavior // ignore: cast_nullable_to_non_nullable
                        as StartupErrorBehavior?,
            isFirstLaunch:
                freezed == isFirstLaunch
                    ? _value.isFirstLaunch
                    : isFirstLaunch // ignore: cast_nullable_to_non_nullable
                        as bool?,
            enableSampleStackAutoGeneration:
                freezed == enableSampleStackAutoGeneration
                    ? _value.enableSampleStackAutoGeneration
                    : enableSampleStackAutoGeneration // ignore: cast_nullable_to_non_nullable
                        as bool?,
            enableDevStacks:
                null == enableDevStacks
                    ? _value.enableDevStacks
                    : enableDevStacks // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StartupConfigImplCopyWith<$Res>
    implements $StartupConfigCopyWith<$Res> {
  factory _$$StartupConfigImplCopyWith(
    _$StartupConfigImpl value,
    $Res Function(_$StartupConfigImpl) then,
  ) = __$$StartupConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool? autoOpenLastStack,
    String? lastOpenedStackPath,
    StartupErrorBehavior? errorBehavior,
    bool? isFirstLaunch,
    bool? enableSampleStackAutoGeneration,
    bool enableDevStacks,
  });
}

/// @nodoc
class __$$StartupConfigImplCopyWithImpl<$Res>
    extends _$StartupConfigCopyWithImpl<$Res, _$StartupConfigImpl>
    implements _$$StartupConfigImplCopyWith<$Res> {
  __$$StartupConfigImplCopyWithImpl(
    _$StartupConfigImpl _value,
    $Res Function(_$StartupConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StartupConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoOpenLastStack = freezed,
    Object? lastOpenedStackPath = freezed,
    Object? errorBehavior = freezed,
    Object? isFirstLaunch = freezed,
    Object? enableSampleStackAutoGeneration = freezed,
    Object? enableDevStacks = null,
  }) {
    return _then(
      _$StartupConfigImpl(
        autoOpenLastStack:
            freezed == autoOpenLastStack
                ? _value.autoOpenLastStack
                : autoOpenLastStack // ignore: cast_nullable_to_non_nullable
                    as bool?,
        lastOpenedStackPath:
            freezed == lastOpenedStackPath
                ? _value.lastOpenedStackPath
                : lastOpenedStackPath // ignore: cast_nullable_to_non_nullable
                    as String?,
        errorBehavior:
            freezed == errorBehavior
                ? _value.errorBehavior
                : errorBehavior // ignore: cast_nullable_to_non_nullable
                    as StartupErrorBehavior?,
        isFirstLaunch:
            freezed == isFirstLaunch
                ? _value.isFirstLaunch
                : isFirstLaunch // ignore: cast_nullable_to_non_nullable
                    as bool?,
        enableSampleStackAutoGeneration:
            freezed == enableSampleStackAutoGeneration
                ? _value.enableSampleStackAutoGeneration
                : enableSampleStackAutoGeneration // ignore: cast_nullable_to_non_nullable
                    as bool?,
        enableDevStacks:
            null == enableDevStacks
                ? _value.enableDevStacks
                : enableDevStacks // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StartupConfigImpl implements _StartupConfig {
  const _$StartupConfigImpl({
    this.autoOpenLastStack = null,
    this.lastOpenedStackPath = null,
    this.errorBehavior = null,
    this.isFirstLaunch = null,
    this.enableSampleStackAutoGeneration = null,
    this.enableDevStacks = false,
  });

  factory _$StartupConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$StartupConfigImplFromJson(json);

  /// Whether to automatically open the last opened stack on startup
  @override
  @JsonKey()
  final bool? autoOpenLastStack;

  /// Path of the last opened stack (usually null in config file)
  @override
  @JsonKey()
  final String? lastOpenedStackPath;

  /// Behavior when stack is not found
  @override
  @JsonKey()
  final StartupErrorBehavior? errorBehavior;

  /// Whether this is the first launch of the app (usually null in config file)
  @override
  @JsonKey()
  final bool? isFirstLaunch;

  /// Whether to enable sample stack auto-generation
  @override
  @JsonKey()
  final bool? enableSampleStackAutoGeneration;

  /// Whether to enable development stacks
  @override
  @JsonKey()
  final bool enableDevStacks;

  @override
  String toString() {
    return 'StartupConfig(autoOpenLastStack: $autoOpenLastStack, lastOpenedStackPath: $lastOpenedStackPath, errorBehavior: $errorBehavior, isFirstLaunch: $isFirstLaunch, enableSampleStackAutoGeneration: $enableSampleStackAutoGeneration, enableDevStacks: $enableDevStacks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StartupConfigImpl &&
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
                    enableSampleStackAutoGeneration) &&
            (identical(other.enableDevStacks, enableDevStacks) ||
                other.enableDevStacks == enableDevStacks));
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
    enableDevStacks,
  );

  /// Create a copy of StartupConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StartupConfigImplCopyWith<_$StartupConfigImpl> get copyWith =>
      __$$StartupConfigImplCopyWithImpl<_$StartupConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StartupConfigImplToJson(this);
  }
}

abstract class _StartupConfig implements StartupConfig {
  const factory _StartupConfig({
    final bool? autoOpenLastStack,
    final String? lastOpenedStackPath,
    final StartupErrorBehavior? errorBehavior,
    final bool? isFirstLaunch,
    final bool? enableSampleStackAutoGeneration,
    final bool enableDevStacks,
  }) = _$StartupConfigImpl;

  factory _StartupConfig.fromJson(Map<String, dynamic> json) =
      _$StartupConfigImpl.fromJson;

  /// Whether to automatically open the last opened stack on startup
  @override
  bool? get autoOpenLastStack;

  /// Path of the last opened stack (usually null in config file)
  @override
  String? get lastOpenedStackPath;

  /// Behavior when stack is not found
  @override
  StartupErrorBehavior? get errorBehavior;

  /// Whether this is the first launch of the app (usually null in config file)
  @override
  bool? get isFirstLaunch;

  /// Whether to enable sample stack auto-generation
  @override
  bool? get enableSampleStackAutoGeneration;

  /// Whether to enable development stacks
  @override
  bool get enableDevStacks;

  /// Create a copy of StartupConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StartupConfigImplCopyWith<_$StartupConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DevelopmentConfig _$DevelopmentConfigFromJson(Map<String, dynamic> json) {
  return _DevelopmentConfig.fromJson(json);
}

/// @nodoc
mixin _$DevelopmentConfig {
  /// Whether to perform full reset of all settings
  bool get resetAllSettings => throw _privateConstructorUsedError;

  /// Whether to perform full reset of database
  bool get resetDatabase => throw _privateConstructorUsedError;

  /// Whether to auto-generate test data
  bool get generateTestData => throw _privateConstructorUsedError;

  /// Whether to enable UI development mode
  bool get enableUiDevMode => throw _privateConstructorUsedError;

  /// Serializes this DevelopmentConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DevelopmentConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DevelopmentConfigCopyWith<DevelopmentConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DevelopmentConfigCopyWith<$Res> {
  factory $DevelopmentConfigCopyWith(
    DevelopmentConfig value,
    $Res Function(DevelopmentConfig) then,
  ) = _$DevelopmentConfigCopyWithImpl<$Res, DevelopmentConfig>;
  @useResult
  $Res call({
    bool resetAllSettings,
    bool resetDatabase,
    bool generateTestData,
    bool enableUiDevMode,
  });
}

/// @nodoc
class _$DevelopmentConfigCopyWithImpl<$Res, $Val extends DevelopmentConfig>
    implements $DevelopmentConfigCopyWith<$Res> {
  _$DevelopmentConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DevelopmentConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resetAllSettings = null,
    Object? resetDatabase = null,
    Object? generateTestData = null,
    Object? enableUiDevMode = null,
  }) {
    return _then(
      _value.copyWith(
            resetAllSettings:
                null == resetAllSettings
                    ? _value.resetAllSettings
                    : resetAllSettings // ignore: cast_nullable_to_non_nullable
                        as bool,
            resetDatabase:
                null == resetDatabase
                    ? _value.resetDatabase
                    : resetDatabase // ignore: cast_nullable_to_non_nullable
                        as bool,
            generateTestData:
                null == generateTestData
                    ? _value.generateTestData
                    : generateTestData // ignore: cast_nullable_to_non_nullable
                        as bool,
            enableUiDevMode:
                null == enableUiDevMode
                    ? _value.enableUiDevMode
                    : enableUiDevMode // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DevelopmentConfigImplCopyWith<$Res>
    implements $DevelopmentConfigCopyWith<$Res> {
  factory _$$DevelopmentConfigImplCopyWith(
    _$DevelopmentConfigImpl value,
    $Res Function(_$DevelopmentConfigImpl) then,
  ) = __$$DevelopmentConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool resetAllSettings,
    bool resetDatabase,
    bool generateTestData,
    bool enableUiDevMode,
  });
}

/// @nodoc
class __$$DevelopmentConfigImplCopyWithImpl<$Res>
    extends _$DevelopmentConfigCopyWithImpl<$Res, _$DevelopmentConfigImpl>
    implements _$$DevelopmentConfigImplCopyWith<$Res> {
  __$$DevelopmentConfigImplCopyWithImpl(
    _$DevelopmentConfigImpl _value,
    $Res Function(_$DevelopmentConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DevelopmentConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resetAllSettings = null,
    Object? resetDatabase = null,
    Object? generateTestData = null,
    Object? enableUiDevMode = null,
  }) {
    return _then(
      _$DevelopmentConfigImpl(
        resetAllSettings:
            null == resetAllSettings
                ? _value.resetAllSettings
                : resetAllSettings // ignore: cast_nullable_to_non_nullable
                    as bool,
        resetDatabase:
            null == resetDatabase
                ? _value.resetDatabase
                : resetDatabase // ignore: cast_nullable_to_non_nullable
                    as bool,
        generateTestData:
            null == generateTestData
                ? _value.generateTestData
                : generateTestData // ignore: cast_nullable_to_non_nullable
                    as bool,
        enableUiDevMode:
            null == enableUiDevMode
                ? _value.enableUiDevMode
                : enableUiDevMode // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DevelopmentConfigImpl implements _DevelopmentConfig {
  const _$DevelopmentConfigImpl({
    this.resetAllSettings = false,
    this.resetDatabase = false,
    this.generateTestData = false,
    this.enableUiDevMode = false,
  });

  factory _$DevelopmentConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$DevelopmentConfigImplFromJson(json);

  /// Whether to perform full reset of all settings
  @override
  @JsonKey()
  final bool resetAllSettings;

  /// Whether to perform full reset of database
  @override
  @JsonKey()
  final bool resetDatabase;

  /// Whether to auto-generate test data
  @override
  @JsonKey()
  final bool generateTestData;

  /// Whether to enable UI development mode
  @override
  @JsonKey()
  final bool enableUiDevMode;

  @override
  String toString() {
    return 'DevelopmentConfig(resetAllSettings: $resetAllSettings, resetDatabase: $resetDatabase, generateTestData: $generateTestData, enableUiDevMode: $enableUiDevMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DevelopmentConfigImpl &&
            (identical(other.resetAllSettings, resetAllSettings) ||
                other.resetAllSettings == resetAllSettings) &&
            (identical(other.resetDatabase, resetDatabase) ||
                other.resetDatabase == resetDatabase) &&
            (identical(other.generateTestData, generateTestData) ||
                other.generateTestData == generateTestData) &&
            (identical(other.enableUiDevMode, enableUiDevMode) ||
                other.enableUiDevMode == enableUiDevMode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    resetAllSettings,
    resetDatabase,
    generateTestData,
    enableUiDevMode,
  );

  /// Create a copy of DevelopmentConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DevelopmentConfigImplCopyWith<_$DevelopmentConfigImpl> get copyWith =>
      __$$DevelopmentConfigImplCopyWithImpl<_$DevelopmentConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DevelopmentConfigImplToJson(this);
  }
}

abstract class _DevelopmentConfig implements DevelopmentConfig {
  const factory _DevelopmentConfig({
    final bool resetAllSettings,
    final bool resetDatabase,
    final bool generateTestData,
    final bool enableUiDevMode,
  }) = _$DevelopmentConfigImpl;

  factory _DevelopmentConfig.fromJson(Map<String, dynamic> json) =
      _$DevelopmentConfigImpl.fromJson;

  /// Whether to perform full reset of all settings
  @override
  bool get resetAllSettings;

  /// Whether to perform full reset of database
  @override
  bool get resetDatabase;

  /// Whether to auto-generate test data
  @override
  bool get generateTestData;

  /// Whether to enable UI development mode
  @override
  bool get enableUiDevMode;

  /// Create a copy of DevelopmentConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DevelopmentConfigImplCopyWith<_$DevelopmentConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
