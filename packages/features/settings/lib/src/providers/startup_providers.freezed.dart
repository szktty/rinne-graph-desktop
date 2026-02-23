// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'startup_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StartupSettings {

/// Whether to automatically open the last opened stack on startup.
 bool get autoOpenLastStack;/// Path of the last opened stack.
 String? get lastOpenedStackPath;/// Behavior when stack is not found.
 StartupErrorBehavior get errorBehavior;/// Whether it is the first launch of the app.
 bool get isFirstLaunch;/// Whether to enable sample stack auto-generation.
 bool get enableSampleStackAutoGeneration;
/// Create a copy of StartupSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartupSettingsCopyWith<StartupSettings> get copyWith => _$StartupSettingsCopyWithImpl<StartupSettings>(this as StartupSettings, _$identity);

  /// Serializes this StartupSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartupSettings&&(identical(other.autoOpenLastStack, autoOpenLastStack) || other.autoOpenLastStack == autoOpenLastStack)&&(identical(other.lastOpenedStackPath, lastOpenedStackPath) || other.lastOpenedStackPath == lastOpenedStackPath)&&(identical(other.errorBehavior, errorBehavior) || other.errorBehavior == errorBehavior)&&(identical(other.isFirstLaunch, isFirstLaunch) || other.isFirstLaunch == isFirstLaunch)&&(identical(other.enableSampleStackAutoGeneration, enableSampleStackAutoGeneration) || other.enableSampleStackAutoGeneration == enableSampleStackAutoGeneration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,autoOpenLastStack,lastOpenedStackPath,errorBehavior,isFirstLaunch,enableSampleStackAutoGeneration);

@override
String toString() {
  return 'StartupSettings(autoOpenLastStack: $autoOpenLastStack, lastOpenedStackPath: $lastOpenedStackPath, errorBehavior: $errorBehavior, isFirstLaunch: $isFirstLaunch, enableSampleStackAutoGeneration: $enableSampleStackAutoGeneration)';
}


}

/// @nodoc
abstract mixin class $StartupSettingsCopyWith<$Res>  {
  factory $StartupSettingsCopyWith(StartupSettings value, $Res Function(StartupSettings) _then) = _$StartupSettingsCopyWithImpl;
@useResult
$Res call({
 bool autoOpenLastStack, String? lastOpenedStackPath, StartupErrorBehavior errorBehavior, bool isFirstLaunch, bool enableSampleStackAutoGeneration
});




}
/// @nodoc
class _$StartupSettingsCopyWithImpl<$Res>
    implements $StartupSettingsCopyWith<$Res> {
  _$StartupSettingsCopyWithImpl(this._self, this._then);

  final StartupSettings _self;
  final $Res Function(StartupSettings) _then;

/// Create a copy of StartupSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? autoOpenLastStack = null,Object? lastOpenedStackPath = freezed,Object? errorBehavior = null,Object? isFirstLaunch = null,Object? enableSampleStackAutoGeneration = null,}) {
  return _then(_self.copyWith(
autoOpenLastStack: null == autoOpenLastStack ? _self.autoOpenLastStack : autoOpenLastStack // ignore: cast_nullable_to_non_nullable
as bool,lastOpenedStackPath: freezed == lastOpenedStackPath ? _self.lastOpenedStackPath : lastOpenedStackPath // ignore: cast_nullable_to_non_nullable
as String?,errorBehavior: null == errorBehavior ? _self.errorBehavior : errorBehavior // ignore: cast_nullable_to_non_nullable
as StartupErrorBehavior,isFirstLaunch: null == isFirstLaunch ? _self.isFirstLaunch : isFirstLaunch // ignore: cast_nullable_to_non_nullable
as bool,enableSampleStackAutoGeneration: null == enableSampleStackAutoGeneration ? _self.enableSampleStackAutoGeneration : enableSampleStackAutoGeneration // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StartupSettings].
extension StartupSettingsPatterns on StartupSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StartupSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StartupSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StartupSettings value)  $default,){
final _that = this;
switch (_that) {
case _StartupSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StartupSettings value)?  $default,){
final _that = this;
switch (_that) {
case _StartupSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool autoOpenLastStack,  String? lastOpenedStackPath,  StartupErrorBehavior errorBehavior,  bool isFirstLaunch,  bool enableSampleStackAutoGeneration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StartupSettings() when $default != null:
return $default(_that.autoOpenLastStack,_that.lastOpenedStackPath,_that.errorBehavior,_that.isFirstLaunch,_that.enableSampleStackAutoGeneration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool autoOpenLastStack,  String? lastOpenedStackPath,  StartupErrorBehavior errorBehavior,  bool isFirstLaunch,  bool enableSampleStackAutoGeneration)  $default,) {final _that = this;
switch (_that) {
case _StartupSettings():
return $default(_that.autoOpenLastStack,_that.lastOpenedStackPath,_that.errorBehavior,_that.isFirstLaunch,_that.enableSampleStackAutoGeneration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool autoOpenLastStack,  String? lastOpenedStackPath,  StartupErrorBehavior errorBehavior,  bool isFirstLaunch,  bool enableSampleStackAutoGeneration)?  $default,) {final _that = this;
switch (_that) {
case _StartupSettings() when $default != null:
return $default(_that.autoOpenLastStack,_that.lastOpenedStackPath,_that.errorBehavior,_that.isFirstLaunch,_that.enableSampleStackAutoGeneration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StartupSettings implements StartupSettings {
  const _StartupSettings({this.autoOpenLastStack = false, this.lastOpenedStackPath, this.errorBehavior = StartupErrorBehavior.showWelcome, this.isFirstLaunch = true, this.enableSampleStackAutoGeneration = true});
  factory _StartupSettings.fromJson(Map<String, dynamic> json) => _$StartupSettingsFromJson(json);

/// Whether to automatically open the last opened stack on startup.
@override@JsonKey() final  bool autoOpenLastStack;
/// Path of the last opened stack.
@override final  String? lastOpenedStackPath;
/// Behavior when stack is not found.
@override@JsonKey() final  StartupErrorBehavior errorBehavior;
/// Whether it is the first launch of the app.
@override@JsonKey() final  bool isFirstLaunch;
/// Whether to enable sample stack auto-generation.
@override@JsonKey() final  bool enableSampleStackAutoGeneration;

/// Create a copy of StartupSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartupSettingsCopyWith<_StartupSettings> get copyWith => __$StartupSettingsCopyWithImpl<_StartupSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StartupSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartupSettings&&(identical(other.autoOpenLastStack, autoOpenLastStack) || other.autoOpenLastStack == autoOpenLastStack)&&(identical(other.lastOpenedStackPath, lastOpenedStackPath) || other.lastOpenedStackPath == lastOpenedStackPath)&&(identical(other.errorBehavior, errorBehavior) || other.errorBehavior == errorBehavior)&&(identical(other.isFirstLaunch, isFirstLaunch) || other.isFirstLaunch == isFirstLaunch)&&(identical(other.enableSampleStackAutoGeneration, enableSampleStackAutoGeneration) || other.enableSampleStackAutoGeneration == enableSampleStackAutoGeneration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,autoOpenLastStack,lastOpenedStackPath,errorBehavior,isFirstLaunch,enableSampleStackAutoGeneration);

@override
String toString() {
  return 'StartupSettings(autoOpenLastStack: $autoOpenLastStack, lastOpenedStackPath: $lastOpenedStackPath, errorBehavior: $errorBehavior, isFirstLaunch: $isFirstLaunch, enableSampleStackAutoGeneration: $enableSampleStackAutoGeneration)';
}


}

/// @nodoc
abstract mixin class _$StartupSettingsCopyWith<$Res> implements $StartupSettingsCopyWith<$Res> {
  factory _$StartupSettingsCopyWith(_StartupSettings value, $Res Function(_StartupSettings) _then) = __$StartupSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool autoOpenLastStack, String? lastOpenedStackPath, StartupErrorBehavior errorBehavior, bool isFirstLaunch, bool enableSampleStackAutoGeneration
});




}
/// @nodoc
class __$StartupSettingsCopyWithImpl<$Res>
    implements _$StartupSettingsCopyWith<$Res> {
  __$StartupSettingsCopyWithImpl(this._self, this._then);

  final _StartupSettings _self;
  final $Res Function(_StartupSettings) _then;

/// Create a copy of StartupSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? autoOpenLastStack = null,Object? lastOpenedStackPath = freezed,Object? errorBehavior = null,Object? isFirstLaunch = null,Object? enableSampleStackAutoGeneration = null,}) {
  return _then(_StartupSettings(
autoOpenLastStack: null == autoOpenLastStack ? _self.autoOpenLastStack : autoOpenLastStack // ignore: cast_nullable_to_non_nullable
as bool,lastOpenedStackPath: freezed == lastOpenedStackPath ? _self.lastOpenedStackPath : lastOpenedStackPath // ignore: cast_nullable_to_non_nullable
as String?,errorBehavior: null == errorBehavior ? _self.errorBehavior : errorBehavior // ignore: cast_nullable_to_non_nullable
as StartupErrorBehavior,isFirstLaunch: null == isFirstLaunch ? _self.isFirstLaunch : isFirstLaunch // ignore: cast_nullable_to_non_nullable
as bool,enableSampleStackAutoGeneration: null == enableSampleStackAutoGeneration ? _self.enableSampleStackAutoGeneration : enableSampleStackAutoGeneration // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
