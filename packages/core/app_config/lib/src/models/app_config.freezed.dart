// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppConfig {

/// Configuration name (for identification)
 String get name;/// Configuration description
 String? get description;/// Debug-related configuration
 DebugConfig get debug;/// Startup configuration
 StartupConfig get startup;/// Development configuration
 DevelopmentConfig get development;
/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppConfigCopyWith<AppConfig> get copyWith => _$AppConfigCopyWithImpl<AppConfig>(this as AppConfig, _$identity);

  /// Serializes this AppConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppConfig&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.debug, debug) || other.debug == debug)&&(identical(other.startup, startup) || other.startup == startup)&&(identical(other.development, development) || other.development == development));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,debug,startup,development);

@override
String toString() {
  return 'AppConfig(name: $name, description: $description, debug: $debug, startup: $startup, development: $development)';
}


}

/// @nodoc
abstract mixin class $AppConfigCopyWith<$Res>  {
  factory $AppConfigCopyWith(AppConfig value, $Res Function(AppConfig) _then) = _$AppConfigCopyWithImpl;
@useResult
$Res call({
 String name, String? description, DebugConfig debug, StartupConfig startup, DevelopmentConfig development
});


$DebugConfigCopyWith<$Res> get debug;$StartupConfigCopyWith<$Res> get startup;$DevelopmentConfigCopyWith<$Res> get development;

}
/// @nodoc
class _$AppConfigCopyWithImpl<$Res>
    implements $AppConfigCopyWith<$Res> {
  _$AppConfigCopyWithImpl(this._self, this._then);

  final AppConfig _self;
  final $Res Function(AppConfig) _then;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? debug = null,Object? startup = null,Object? development = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,debug: null == debug ? _self.debug : debug // ignore: cast_nullable_to_non_nullable
as DebugConfig,startup: null == startup ? _self.startup : startup // ignore: cast_nullable_to_non_nullable
as StartupConfig,development: null == development ? _self.development : development // ignore: cast_nullable_to_non_nullable
as DevelopmentConfig,
  ));
}
/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DebugConfigCopyWith<$Res> get debug {
  
  return $DebugConfigCopyWith<$Res>(_self.debug, (value) {
    return _then(_self.copyWith(debug: value));
  });
}/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StartupConfigCopyWith<$Res> get startup {
  
  return $StartupConfigCopyWith<$Res>(_self.startup, (value) {
    return _then(_self.copyWith(startup: value));
  });
}/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DevelopmentConfigCopyWith<$Res> get development {
  
  return $DevelopmentConfigCopyWith<$Res>(_self.development, (value) {
    return _then(_self.copyWith(development: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppConfig].
extension AppConfigPatterns on AppConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppConfig value)  $default,){
final _that = this;
switch (_that) {
case _AppConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  DebugConfig debug,  StartupConfig startup,  DevelopmentConfig development)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that.name,_that.description,_that.debug,_that.startup,_that.development);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  DebugConfig debug,  StartupConfig startup,  DevelopmentConfig development)  $default,) {final _that = this;
switch (_that) {
case _AppConfig():
return $default(_that.name,_that.description,_that.debug,_that.startup,_that.development);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  DebugConfig debug,  StartupConfig startup,  DevelopmentConfig development)?  $default,) {final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that.name,_that.description,_that.debug,_that.startup,_that.development);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppConfig implements AppConfig {
  const _AppConfig({this.name = 'default', this.description, this.debug = const DebugConfig(), this.startup = const StartupConfig(), this.development = const DevelopmentConfig()});
  factory _AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);

/// Configuration name (for identification)
@override@JsonKey() final  String name;
/// Configuration description
@override final  String? description;
/// Debug-related configuration
@override@JsonKey() final  DebugConfig debug;
/// Startup configuration
@override@JsonKey() final  StartupConfig startup;
/// Development configuration
@override@JsonKey() final  DevelopmentConfig development;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppConfigCopyWith<_AppConfig> get copyWith => __$AppConfigCopyWithImpl<_AppConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppConfig&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.debug, debug) || other.debug == debug)&&(identical(other.startup, startup) || other.startup == startup)&&(identical(other.development, development) || other.development == development));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,debug,startup,development);

@override
String toString() {
  return 'AppConfig(name: $name, description: $description, debug: $debug, startup: $startup, development: $development)';
}


}

/// @nodoc
abstract mixin class _$AppConfigCopyWith<$Res> implements $AppConfigCopyWith<$Res> {
  factory _$AppConfigCopyWith(_AppConfig value, $Res Function(_AppConfig) _then) = __$AppConfigCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, DebugConfig debug, StartupConfig startup, DevelopmentConfig development
});


@override $DebugConfigCopyWith<$Res> get debug;@override $StartupConfigCopyWith<$Res> get startup;@override $DevelopmentConfigCopyWith<$Res> get development;

}
/// @nodoc
class __$AppConfigCopyWithImpl<$Res>
    implements _$AppConfigCopyWith<$Res> {
  __$AppConfigCopyWithImpl(this._self, this._then);

  final _AppConfig _self;
  final $Res Function(_AppConfig) _then;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? debug = null,Object? startup = null,Object? development = null,}) {
  return _then(_AppConfig(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,debug: null == debug ? _self.debug : debug // ignore: cast_nullable_to_non_nullable
as DebugConfig,startup: null == startup ? _self.startup : startup // ignore: cast_nullable_to_non_nullable
as StartupConfig,development: null == development ? _self.development : development // ignore: cast_nullable_to_non_nullable
as DevelopmentConfig,
  ));
}

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DebugConfigCopyWith<$Res> get debug {
  
  return $DebugConfigCopyWith<$Res>(_self.debug, (value) {
    return _then(_self.copyWith(debug: value));
  });
}/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StartupConfigCopyWith<$Res> get startup {
  
  return $StartupConfigCopyWith<$Res>(_self.startup, (value) {
    return _then(_self.copyWith(startup: value));
  });
}/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DevelopmentConfigCopyWith<$Res> get development {
  
  return $DevelopmentConfigCopyWith<$Res>(_self.development, (value) {
    return _then(_self.copyWith(development: value));
  });
}
}


/// @nodoc
mixin _$DebugConfig {

/// Whether to force enable debug mode
 bool? get forceDebugMode;/// Whether to enable debug logging
 bool? get enableDebugLogging;/// Whether to enable screenshot server
 bool get enableScreenshotServer;/// Whether to enable verbose logging
 bool get enableVerboseLogging;
/// Create a copy of DebugConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DebugConfigCopyWith<DebugConfig> get copyWith => _$DebugConfigCopyWithImpl<DebugConfig>(this as DebugConfig, _$identity);

  /// Serializes this DebugConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DebugConfig&&(identical(other.forceDebugMode, forceDebugMode) || other.forceDebugMode == forceDebugMode)&&(identical(other.enableDebugLogging, enableDebugLogging) || other.enableDebugLogging == enableDebugLogging)&&(identical(other.enableScreenshotServer, enableScreenshotServer) || other.enableScreenshotServer == enableScreenshotServer)&&(identical(other.enableVerboseLogging, enableVerboseLogging) || other.enableVerboseLogging == enableVerboseLogging));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,forceDebugMode,enableDebugLogging,enableScreenshotServer,enableVerboseLogging);

@override
String toString() {
  return 'DebugConfig(forceDebugMode: $forceDebugMode, enableDebugLogging: $enableDebugLogging, enableScreenshotServer: $enableScreenshotServer, enableVerboseLogging: $enableVerboseLogging)';
}


}

/// @nodoc
abstract mixin class $DebugConfigCopyWith<$Res>  {
  factory $DebugConfigCopyWith(DebugConfig value, $Res Function(DebugConfig) _then) = _$DebugConfigCopyWithImpl;
@useResult
$Res call({
 bool? forceDebugMode, bool? enableDebugLogging, bool enableScreenshotServer, bool enableVerboseLogging
});




}
/// @nodoc
class _$DebugConfigCopyWithImpl<$Res>
    implements $DebugConfigCopyWith<$Res> {
  _$DebugConfigCopyWithImpl(this._self, this._then);

  final DebugConfig _self;
  final $Res Function(DebugConfig) _then;

/// Create a copy of DebugConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? forceDebugMode = freezed,Object? enableDebugLogging = freezed,Object? enableScreenshotServer = null,Object? enableVerboseLogging = null,}) {
  return _then(_self.copyWith(
forceDebugMode: freezed == forceDebugMode ? _self.forceDebugMode : forceDebugMode // ignore: cast_nullable_to_non_nullable
as bool?,enableDebugLogging: freezed == enableDebugLogging ? _self.enableDebugLogging : enableDebugLogging // ignore: cast_nullable_to_non_nullable
as bool?,enableScreenshotServer: null == enableScreenshotServer ? _self.enableScreenshotServer : enableScreenshotServer // ignore: cast_nullable_to_non_nullable
as bool,enableVerboseLogging: null == enableVerboseLogging ? _self.enableVerboseLogging : enableVerboseLogging // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DebugConfig].
extension DebugConfigPatterns on DebugConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DebugConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DebugConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DebugConfig value)  $default,){
final _that = this;
switch (_that) {
case _DebugConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DebugConfig value)?  $default,){
final _that = this;
switch (_that) {
case _DebugConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? forceDebugMode,  bool? enableDebugLogging,  bool enableScreenshotServer,  bool enableVerboseLogging)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DebugConfig() when $default != null:
return $default(_that.forceDebugMode,_that.enableDebugLogging,_that.enableScreenshotServer,_that.enableVerboseLogging);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? forceDebugMode,  bool? enableDebugLogging,  bool enableScreenshotServer,  bool enableVerboseLogging)  $default,) {final _that = this;
switch (_that) {
case _DebugConfig():
return $default(_that.forceDebugMode,_that.enableDebugLogging,_that.enableScreenshotServer,_that.enableVerboseLogging);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? forceDebugMode,  bool? enableDebugLogging,  bool enableScreenshotServer,  bool enableVerboseLogging)?  $default,) {final _that = this;
switch (_that) {
case _DebugConfig() when $default != null:
return $default(_that.forceDebugMode,_that.enableDebugLogging,_that.enableScreenshotServer,_that.enableVerboseLogging);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DebugConfig implements DebugConfig {
  const _DebugConfig({this.forceDebugMode = null, this.enableDebugLogging = null, this.enableScreenshotServer = false, this.enableVerboseLogging = false});
  factory _DebugConfig.fromJson(Map<String, dynamic> json) => _$DebugConfigFromJson(json);

/// Whether to force enable debug mode
@override@JsonKey() final  bool? forceDebugMode;
/// Whether to enable debug logging
@override@JsonKey() final  bool? enableDebugLogging;
/// Whether to enable screenshot server
@override@JsonKey() final  bool enableScreenshotServer;
/// Whether to enable verbose logging
@override@JsonKey() final  bool enableVerboseLogging;

/// Create a copy of DebugConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DebugConfigCopyWith<_DebugConfig> get copyWith => __$DebugConfigCopyWithImpl<_DebugConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DebugConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DebugConfig&&(identical(other.forceDebugMode, forceDebugMode) || other.forceDebugMode == forceDebugMode)&&(identical(other.enableDebugLogging, enableDebugLogging) || other.enableDebugLogging == enableDebugLogging)&&(identical(other.enableScreenshotServer, enableScreenshotServer) || other.enableScreenshotServer == enableScreenshotServer)&&(identical(other.enableVerboseLogging, enableVerboseLogging) || other.enableVerboseLogging == enableVerboseLogging));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,forceDebugMode,enableDebugLogging,enableScreenshotServer,enableVerboseLogging);

@override
String toString() {
  return 'DebugConfig(forceDebugMode: $forceDebugMode, enableDebugLogging: $enableDebugLogging, enableScreenshotServer: $enableScreenshotServer, enableVerboseLogging: $enableVerboseLogging)';
}


}

/// @nodoc
abstract mixin class _$DebugConfigCopyWith<$Res> implements $DebugConfigCopyWith<$Res> {
  factory _$DebugConfigCopyWith(_DebugConfig value, $Res Function(_DebugConfig) _then) = __$DebugConfigCopyWithImpl;
@override @useResult
$Res call({
 bool? forceDebugMode, bool? enableDebugLogging, bool enableScreenshotServer, bool enableVerboseLogging
});




}
/// @nodoc
class __$DebugConfigCopyWithImpl<$Res>
    implements _$DebugConfigCopyWith<$Res> {
  __$DebugConfigCopyWithImpl(this._self, this._then);

  final _DebugConfig _self;
  final $Res Function(_DebugConfig) _then;

/// Create a copy of DebugConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? forceDebugMode = freezed,Object? enableDebugLogging = freezed,Object? enableScreenshotServer = null,Object? enableVerboseLogging = null,}) {
  return _then(_DebugConfig(
forceDebugMode: freezed == forceDebugMode ? _self.forceDebugMode : forceDebugMode // ignore: cast_nullable_to_non_nullable
as bool?,enableDebugLogging: freezed == enableDebugLogging ? _self.enableDebugLogging : enableDebugLogging // ignore: cast_nullable_to_non_nullable
as bool?,enableScreenshotServer: null == enableScreenshotServer ? _self.enableScreenshotServer : enableScreenshotServer // ignore: cast_nullable_to_non_nullable
as bool,enableVerboseLogging: null == enableVerboseLogging ? _self.enableVerboseLogging : enableVerboseLogging // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$StartupConfig {

/// Whether to automatically open the last opened stack on startup
 bool? get autoOpenLastStack;/// Path of the last opened stack (usually null in config file)
 String? get lastOpenedStackPath;/// Behavior when stack is not found
 StartupErrorBehavior? get errorBehavior;/// Whether this is the first launch of the app (usually null in config file)
 bool? get isFirstLaunch;/// Whether to enable sample stack auto-generation
 bool? get enableSampleStackAutoGeneration;/// Whether to enable development stacks
 bool get enableDevStacks;
/// Create a copy of StartupConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartupConfigCopyWith<StartupConfig> get copyWith => _$StartupConfigCopyWithImpl<StartupConfig>(this as StartupConfig, _$identity);

  /// Serializes this StartupConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartupConfig&&(identical(other.autoOpenLastStack, autoOpenLastStack) || other.autoOpenLastStack == autoOpenLastStack)&&(identical(other.lastOpenedStackPath, lastOpenedStackPath) || other.lastOpenedStackPath == lastOpenedStackPath)&&(identical(other.errorBehavior, errorBehavior) || other.errorBehavior == errorBehavior)&&(identical(other.isFirstLaunch, isFirstLaunch) || other.isFirstLaunch == isFirstLaunch)&&(identical(other.enableSampleStackAutoGeneration, enableSampleStackAutoGeneration) || other.enableSampleStackAutoGeneration == enableSampleStackAutoGeneration)&&(identical(other.enableDevStacks, enableDevStacks) || other.enableDevStacks == enableDevStacks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,autoOpenLastStack,lastOpenedStackPath,errorBehavior,isFirstLaunch,enableSampleStackAutoGeneration,enableDevStacks);

@override
String toString() {
  return 'StartupConfig(autoOpenLastStack: $autoOpenLastStack, lastOpenedStackPath: $lastOpenedStackPath, errorBehavior: $errorBehavior, isFirstLaunch: $isFirstLaunch, enableSampleStackAutoGeneration: $enableSampleStackAutoGeneration, enableDevStacks: $enableDevStacks)';
}


}

/// @nodoc
abstract mixin class $StartupConfigCopyWith<$Res>  {
  factory $StartupConfigCopyWith(StartupConfig value, $Res Function(StartupConfig) _then) = _$StartupConfigCopyWithImpl;
@useResult
$Res call({
 bool? autoOpenLastStack, String? lastOpenedStackPath, StartupErrorBehavior? errorBehavior, bool? isFirstLaunch, bool? enableSampleStackAutoGeneration, bool enableDevStacks
});




}
/// @nodoc
class _$StartupConfigCopyWithImpl<$Res>
    implements $StartupConfigCopyWith<$Res> {
  _$StartupConfigCopyWithImpl(this._self, this._then);

  final StartupConfig _self;
  final $Res Function(StartupConfig) _then;

/// Create a copy of StartupConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? autoOpenLastStack = freezed,Object? lastOpenedStackPath = freezed,Object? errorBehavior = freezed,Object? isFirstLaunch = freezed,Object? enableSampleStackAutoGeneration = freezed,Object? enableDevStacks = null,}) {
  return _then(_self.copyWith(
autoOpenLastStack: freezed == autoOpenLastStack ? _self.autoOpenLastStack : autoOpenLastStack // ignore: cast_nullable_to_non_nullable
as bool?,lastOpenedStackPath: freezed == lastOpenedStackPath ? _self.lastOpenedStackPath : lastOpenedStackPath // ignore: cast_nullable_to_non_nullable
as String?,errorBehavior: freezed == errorBehavior ? _self.errorBehavior : errorBehavior // ignore: cast_nullable_to_non_nullable
as StartupErrorBehavior?,isFirstLaunch: freezed == isFirstLaunch ? _self.isFirstLaunch : isFirstLaunch // ignore: cast_nullable_to_non_nullable
as bool?,enableSampleStackAutoGeneration: freezed == enableSampleStackAutoGeneration ? _self.enableSampleStackAutoGeneration : enableSampleStackAutoGeneration // ignore: cast_nullable_to_non_nullable
as bool?,enableDevStacks: null == enableDevStacks ? _self.enableDevStacks : enableDevStacks // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StartupConfig].
extension StartupConfigPatterns on StartupConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StartupConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StartupConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StartupConfig value)  $default,){
final _that = this;
switch (_that) {
case _StartupConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StartupConfig value)?  $default,){
final _that = this;
switch (_that) {
case _StartupConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? autoOpenLastStack,  String? lastOpenedStackPath,  StartupErrorBehavior? errorBehavior,  bool? isFirstLaunch,  bool? enableSampleStackAutoGeneration,  bool enableDevStacks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StartupConfig() when $default != null:
return $default(_that.autoOpenLastStack,_that.lastOpenedStackPath,_that.errorBehavior,_that.isFirstLaunch,_that.enableSampleStackAutoGeneration,_that.enableDevStacks);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? autoOpenLastStack,  String? lastOpenedStackPath,  StartupErrorBehavior? errorBehavior,  bool? isFirstLaunch,  bool? enableSampleStackAutoGeneration,  bool enableDevStacks)  $default,) {final _that = this;
switch (_that) {
case _StartupConfig():
return $default(_that.autoOpenLastStack,_that.lastOpenedStackPath,_that.errorBehavior,_that.isFirstLaunch,_that.enableSampleStackAutoGeneration,_that.enableDevStacks);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? autoOpenLastStack,  String? lastOpenedStackPath,  StartupErrorBehavior? errorBehavior,  bool? isFirstLaunch,  bool? enableSampleStackAutoGeneration,  bool enableDevStacks)?  $default,) {final _that = this;
switch (_that) {
case _StartupConfig() when $default != null:
return $default(_that.autoOpenLastStack,_that.lastOpenedStackPath,_that.errorBehavior,_that.isFirstLaunch,_that.enableSampleStackAutoGeneration,_that.enableDevStacks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StartupConfig implements StartupConfig {
  const _StartupConfig({this.autoOpenLastStack = null, this.lastOpenedStackPath = null, this.errorBehavior = null, this.isFirstLaunch = null, this.enableSampleStackAutoGeneration = null, this.enableDevStacks = false});
  factory _StartupConfig.fromJson(Map<String, dynamic> json) => _$StartupConfigFromJson(json);

/// Whether to automatically open the last opened stack on startup
@override@JsonKey() final  bool? autoOpenLastStack;
/// Path of the last opened stack (usually null in config file)
@override@JsonKey() final  String? lastOpenedStackPath;
/// Behavior when stack is not found
@override@JsonKey() final  StartupErrorBehavior? errorBehavior;
/// Whether this is the first launch of the app (usually null in config file)
@override@JsonKey() final  bool? isFirstLaunch;
/// Whether to enable sample stack auto-generation
@override@JsonKey() final  bool? enableSampleStackAutoGeneration;
/// Whether to enable development stacks
@override@JsonKey() final  bool enableDevStacks;

/// Create a copy of StartupConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartupConfigCopyWith<_StartupConfig> get copyWith => __$StartupConfigCopyWithImpl<_StartupConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StartupConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartupConfig&&(identical(other.autoOpenLastStack, autoOpenLastStack) || other.autoOpenLastStack == autoOpenLastStack)&&(identical(other.lastOpenedStackPath, lastOpenedStackPath) || other.lastOpenedStackPath == lastOpenedStackPath)&&(identical(other.errorBehavior, errorBehavior) || other.errorBehavior == errorBehavior)&&(identical(other.isFirstLaunch, isFirstLaunch) || other.isFirstLaunch == isFirstLaunch)&&(identical(other.enableSampleStackAutoGeneration, enableSampleStackAutoGeneration) || other.enableSampleStackAutoGeneration == enableSampleStackAutoGeneration)&&(identical(other.enableDevStacks, enableDevStacks) || other.enableDevStacks == enableDevStacks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,autoOpenLastStack,lastOpenedStackPath,errorBehavior,isFirstLaunch,enableSampleStackAutoGeneration,enableDevStacks);

@override
String toString() {
  return 'StartupConfig(autoOpenLastStack: $autoOpenLastStack, lastOpenedStackPath: $lastOpenedStackPath, errorBehavior: $errorBehavior, isFirstLaunch: $isFirstLaunch, enableSampleStackAutoGeneration: $enableSampleStackAutoGeneration, enableDevStacks: $enableDevStacks)';
}


}

/// @nodoc
abstract mixin class _$StartupConfigCopyWith<$Res> implements $StartupConfigCopyWith<$Res> {
  factory _$StartupConfigCopyWith(_StartupConfig value, $Res Function(_StartupConfig) _then) = __$StartupConfigCopyWithImpl;
@override @useResult
$Res call({
 bool? autoOpenLastStack, String? lastOpenedStackPath, StartupErrorBehavior? errorBehavior, bool? isFirstLaunch, bool? enableSampleStackAutoGeneration, bool enableDevStacks
});




}
/// @nodoc
class __$StartupConfigCopyWithImpl<$Res>
    implements _$StartupConfigCopyWith<$Res> {
  __$StartupConfigCopyWithImpl(this._self, this._then);

  final _StartupConfig _self;
  final $Res Function(_StartupConfig) _then;

/// Create a copy of StartupConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? autoOpenLastStack = freezed,Object? lastOpenedStackPath = freezed,Object? errorBehavior = freezed,Object? isFirstLaunch = freezed,Object? enableSampleStackAutoGeneration = freezed,Object? enableDevStacks = null,}) {
  return _then(_StartupConfig(
autoOpenLastStack: freezed == autoOpenLastStack ? _self.autoOpenLastStack : autoOpenLastStack // ignore: cast_nullable_to_non_nullable
as bool?,lastOpenedStackPath: freezed == lastOpenedStackPath ? _self.lastOpenedStackPath : lastOpenedStackPath // ignore: cast_nullable_to_non_nullable
as String?,errorBehavior: freezed == errorBehavior ? _self.errorBehavior : errorBehavior // ignore: cast_nullable_to_non_nullable
as StartupErrorBehavior?,isFirstLaunch: freezed == isFirstLaunch ? _self.isFirstLaunch : isFirstLaunch // ignore: cast_nullable_to_non_nullable
as bool?,enableSampleStackAutoGeneration: freezed == enableSampleStackAutoGeneration ? _self.enableSampleStackAutoGeneration : enableSampleStackAutoGeneration // ignore: cast_nullable_to_non_nullable
as bool?,enableDevStacks: null == enableDevStacks ? _self.enableDevStacks : enableDevStacks // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DevelopmentConfig {

/// Whether to perform full reset of all settings
 bool get resetAllSettings;/// Whether to perform full reset of database
 bool get resetDatabase;/// Whether to auto-generate test data
 bool get generateTestData;/// Whether to enable UI development mode
 bool get enableUiDevMode;
/// Create a copy of DevelopmentConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DevelopmentConfigCopyWith<DevelopmentConfig> get copyWith => _$DevelopmentConfigCopyWithImpl<DevelopmentConfig>(this as DevelopmentConfig, _$identity);

  /// Serializes this DevelopmentConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DevelopmentConfig&&(identical(other.resetAllSettings, resetAllSettings) || other.resetAllSettings == resetAllSettings)&&(identical(other.resetDatabase, resetDatabase) || other.resetDatabase == resetDatabase)&&(identical(other.generateTestData, generateTestData) || other.generateTestData == generateTestData)&&(identical(other.enableUiDevMode, enableUiDevMode) || other.enableUiDevMode == enableUiDevMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,resetAllSettings,resetDatabase,generateTestData,enableUiDevMode);

@override
String toString() {
  return 'DevelopmentConfig(resetAllSettings: $resetAllSettings, resetDatabase: $resetDatabase, generateTestData: $generateTestData, enableUiDevMode: $enableUiDevMode)';
}


}

/// @nodoc
abstract mixin class $DevelopmentConfigCopyWith<$Res>  {
  factory $DevelopmentConfigCopyWith(DevelopmentConfig value, $Res Function(DevelopmentConfig) _then) = _$DevelopmentConfigCopyWithImpl;
@useResult
$Res call({
 bool resetAllSettings, bool resetDatabase, bool generateTestData, bool enableUiDevMode
});




}
/// @nodoc
class _$DevelopmentConfigCopyWithImpl<$Res>
    implements $DevelopmentConfigCopyWith<$Res> {
  _$DevelopmentConfigCopyWithImpl(this._self, this._then);

  final DevelopmentConfig _self;
  final $Res Function(DevelopmentConfig) _then;

/// Create a copy of DevelopmentConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? resetAllSettings = null,Object? resetDatabase = null,Object? generateTestData = null,Object? enableUiDevMode = null,}) {
  return _then(_self.copyWith(
resetAllSettings: null == resetAllSettings ? _self.resetAllSettings : resetAllSettings // ignore: cast_nullable_to_non_nullable
as bool,resetDatabase: null == resetDatabase ? _self.resetDatabase : resetDatabase // ignore: cast_nullable_to_non_nullable
as bool,generateTestData: null == generateTestData ? _self.generateTestData : generateTestData // ignore: cast_nullable_to_non_nullable
as bool,enableUiDevMode: null == enableUiDevMode ? _self.enableUiDevMode : enableUiDevMode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DevelopmentConfig].
extension DevelopmentConfigPatterns on DevelopmentConfig {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DevelopmentConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DevelopmentConfig() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DevelopmentConfig value)  $default,){
final _that = this;
switch (_that) {
case _DevelopmentConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DevelopmentConfig value)?  $default,){
final _that = this;
switch (_that) {
case _DevelopmentConfig() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool resetAllSettings,  bool resetDatabase,  bool generateTestData,  bool enableUiDevMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DevelopmentConfig() when $default != null:
return $default(_that.resetAllSettings,_that.resetDatabase,_that.generateTestData,_that.enableUiDevMode);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool resetAllSettings,  bool resetDatabase,  bool generateTestData,  bool enableUiDevMode)  $default,) {final _that = this;
switch (_that) {
case _DevelopmentConfig():
return $default(_that.resetAllSettings,_that.resetDatabase,_that.generateTestData,_that.enableUiDevMode);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool resetAllSettings,  bool resetDatabase,  bool generateTestData,  bool enableUiDevMode)?  $default,) {final _that = this;
switch (_that) {
case _DevelopmentConfig() when $default != null:
return $default(_that.resetAllSettings,_that.resetDatabase,_that.generateTestData,_that.enableUiDevMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DevelopmentConfig implements DevelopmentConfig {
  const _DevelopmentConfig({this.resetAllSettings = false, this.resetDatabase = false, this.generateTestData = false, this.enableUiDevMode = false});
  factory _DevelopmentConfig.fromJson(Map<String, dynamic> json) => _$DevelopmentConfigFromJson(json);

/// Whether to perform full reset of all settings
@override@JsonKey() final  bool resetAllSettings;
/// Whether to perform full reset of database
@override@JsonKey() final  bool resetDatabase;
/// Whether to auto-generate test data
@override@JsonKey() final  bool generateTestData;
/// Whether to enable UI development mode
@override@JsonKey() final  bool enableUiDevMode;

/// Create a copy of DevelopmentConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DevelopmentConfigCopyWith<_DevelopmentConfig> get copyWith => __$DevelopmentConfigCopyWithImpl<_DevelopmentConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DevelopmentConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DevelopmentConfig&&(identical(other.resetAllSettings, resetAllSettings) || other.resetAllSettings == resetAllSettings)&&(identical(other.resetDatabase, resetDatabase) || other.resetDatabase == resetDatabase)&&(identical(other.generateTestData, generateTestData) || other.generateTestData == generateTestData)&&(identical(other.enableUiDevMode, enableUiDevMode) || other.enableUiDevMode == enableUiDevMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,resetAllSettings,resetDatabase,generateTestData,enableUiDevMode);

@override
String toString() {
  return 'DevelopmentConfig(resetAllSettings: $resetAllSettings, resetDatabase: $resetDatabase, generateTestData: $generateTestData, enableUiDevMode: $enableUiDevMode)';
}


}

/// @nodoc
abstract mixin class _$DevelopmentConfigCopyWith<$Res> implements $DevelopmentConfigCopyWith<$Res> {
  factory _$DevelopmentConfigCopyWith(_DevelopmentConfig value, $Res Function(_DevelopmentConfig) _then) = __$DevelopmentConfigCopyWithImpl;
@override @useResult
$Res call({
 bool resetAllSettings, bool resetDatabase, bool generateTestData, bool enableUiDevMode
});




}
/// @nodoc
class __$DevelopmentConfigCopyWithImpl<$Res>
    implements _$DevelopmentConfigCopyWith<$Res> {
  __$DevelopmentConfigCopyWithImpl(this._self, this._then);

  final _DevelopmentConfig _self;
  final $Res Function(_DevelopmentConfig) _then;

/// Create a copy of DevelopmentConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? resetAllSettings = null,Object? resetDatabase = null,Object? generateTestData = null,Object? enableUiDevMode = null,}) {
  return _then(_DevelopmentConfig(
resetAllSettings: null == resetAllSettings ? _self.resetAllSettings : resetAllSettings // ignore: cast_nullable_to_non_nullable
as bool,resetDatabase: null == resetDatabase ? _self.resetDatabase : resetDatabase // ignore: cast_nullable_to_non_nullable
as bool,generateTestData: null == generateTestData ? _self.generateTestData : generateTestData // ignore: cast_nullable_to_non_nullable
as bool,enableUiDevMode: null == enableUiDevMode ? _self.enableUiDevMode : enableUiDevMode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
