// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'types.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskProgress {

/// Progress rate (0.0 to 1.0)
 double get value;/// Message regarding progress (optional)
 String? get message;/// Current step (optional)
 String? get currentStep;/// Total number of steps (optional)
 int? get totalSteps;/// Current step number (optional)
 int? get currentStepNumber;
/// Create a copy of TaskProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskProgressCopyWith<TaskProgress> get copyWith => _$TaskProgressCopyWithImpl<TaskProgress>(this as TaskProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskProgress&&(identical(other.value, value) || other.value == value)&&(identical(other.message, message) || other.message == message)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.totalSteps, totalSteps) || other.totalSteps == totalSteps)&&(identical(other.currentStepNumber, currentStepNumber) || other.currentStepNumber == currentStepNumber));
}


@override
int get hashCode => Object.hash(runtimeType,value,message,currentStep,totalSteps,currentStepNumber);

@override
String toString() {
  return 'TaskProgress(value: $value, message: $message, currentStep: $currentStep, totalSteps: $totalSteps, currentStepNumber: $currentStepNumber)';
}


}

/// @nodoc
abstract mixin class $TaskProgressCopyWith<$Res>  {
  factory $TaskProgressCopyWith(TaskProgress value, $Res Function(TaskProgress) _then) = _$TaskProgressCopyWithImpl;
@useResult
$Res call({
 double value, String? message, String? currentStep, int? totalSteps, int? currentStepNumber
});




}
/// @nodoc
class _$TaskProgressCopyWithImpl<$Res>
    implements $TaskProgressCopyWith<$Res> {
  _$TaskProgressCopyWithImpl(this._self, this._then);

  final TaskProgress _self;
  final $Res Function(TaskProgress) _then;

/// Create a copy of TaskProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? message = freezed,Object? currentStep = freezed,Object? totalSteps = freezed,Object? currentStepNumber = freezed,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,currentStep: freezed == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as String?,totalSteps: freezed == totalSteps ? _self.totalSteps : totalSteps // ignore: cast_nullable_to_non_nullable
as int?,currentStepNumber: freezed == currentStepNumber ? _self.currentStepNumber : currentStepNumber // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskProgress].
extension TaskProgressPatterns on TaskProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskProgress value)  $default,){
final _that = this;
switch (_that) {
case _TaskProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskProgress value)?  $default,){
final _that = this;
switch (_that) {
case _TaskProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double value,  String? message,  String? currentStep,  int? totalSteps,  int? currentStepNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskProgress() when $default != null:
return $default(_that.value,_that.message,_that.currentStep,_that.totalSteps,_that.currentStepNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double value,  String? message,  String? currentStep,  int? totalSteps,  int? currentStepNumber)  $default,) {final _that = this;
switch (_that) {
case _TaskProgress():
return $default(_that.value,_that.message,_that.currentStep,_that.totalSteps,_that.currentStepNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double value,  String? message,  String? currentStep,  int? totalSteps,  int? currentStepNumber)?  $default,) {final _that = this;
switch (_that) {
case _TaskProgress() when $default != null:
return $default(_that.value,_that.message,_that.currentStep,_that.totalSteps,_that.currentStepNumber);case _:
  return null;

}
}

}

/// @nodoc


class _TaskProgress implements TaskProgress {
  const _TaskProgress({required this.value, this.message, this.currentStep, this.totalSteps, this.currentStepNumber});
  

/// Progress rate (0.0 to 1.0)
@override final  double value;
/// Message regarding progress (optional)
@override final  String? message;
/// Current step (optional)
@override final  String? currentStep;
/// Total number of steps (optional)
@override final  int? totalSteps;
/// Current step number (optional)
@override final  int? currentStepNumber;

/// Create a copy of TaskProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskProgressCopyWith<_TaskProgress> get copyWith => __$TaskProgressCopyWithImpl<_TaskProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskProgress&&(identical(other.value, value) || other.value == value)&&(identical(other.message, message) || other.message == message)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.totalSteps, totalSteps) || other.totalSteps == totalSteps)&&(identical(other.currentStepNumber, currentStepNumber) || other.currentStepNumber == currentStepNumber));
}


@override
int get hashCode => Object.hash(runtimeType,value,message,currentStep,totalSteps,currentStepNumber);

@override
String toString() {
  return 'TaskProgress(value: $value, message: $message, currentStep: $currentStep, totalSteps: $totalSteps, currentStepNumber: $currentStepNumber)';
}


}

/// @nodoc
abstract mixin class _$TaskProgressCopyWith<$Res> implements $TaskProgressCopyWith<$Res> {
  factory _$TaskProgressCopyWith(_TaskProgress value, $Res Function(_TaskProgress) _then) = __$TaskProgressCopyWithImpl;
@override @useResult
$Res call({
 double value, String? message, String? currentStep, int? totalSteps, int? currentStepNumber
});




}
/// @nodoc
class __$TaskProgressCopyWithImpl<$Res>
    implements _$TaskProgressCopyWith<$Res> {
  __$TaskProgressCopyWithImpl(this._self, this._then);

  final _TaskProgress _self;
  final $Res Function(_TaskProgress) _then;

/// Create a copy of TaskProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? message = freezed,Object? currentStep = freezed,Object? totalSteps = freezed,Object? currentStepNumber = freezed,}) {
  return _then(_TaskProgress(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,currentStep: freezed == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as String?,totalSteps: freezed == totalSteps ? _self.totalSteps : totalSteps // ignore: cast_nullable_to_non_nullable
as int?,currentStepNumber: freezed == currentStepNumber ? _self.currentStepNumber : currentStepNumber // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$TaskError {

/// Error message
 String get message;/// Original error object (optional)
 Object? get error;/// Stack trace (optional)
 StackTrace? get stackTrace;
/// Create a copy of TaskError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskErrorCopyWith<TaskError> get copyWith => _$TaskErrorCopyWithImpl<TaskError>(this as TaskError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'TaskError(message: $message, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $TaskErrorCopyWith<$Res>  {
  factory $TaskErrorCopyWith(TaskError value, $Res Function(TaskError) _then) = _$TaskErrorCopyWithImpl;
@useResult
$Res call({
 String message, Object? error, StackTrace? stackTrace
});




}
/// @nodoc
class _$TaskErrorCopyWithImpl<$Res>
    implements $TaskErrorCopyWith<$Res> {
  _$TaskErrorCopyWithImpl(this._self, this._then);

  final TaskError _self;
  final $Res Function(TaskError) _then;

/// Create a copy of TaskError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error ,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskError].
extension TaskErrorPatterns on TaskError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskError value)  $default,){
final _that = this;
switch (_that) {
case _TaskError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskError value)?  $default,){
final _that = this;
switch (_that) {
case _TaskError() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  Object? error,  StackTrace? stackTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskError() when $default != null:
return $default(_that.message,_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  Object? error,  StackTrace? stackTrace)  $default,) {final _that = this;
switch (_that) {
case _TaskError():
return $default(_that.message,_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  Object? error,  StackTrace? stackTrace)?  $default,) {final _that = this;
switch (_that) {
case _TaskError() when $default != null:
return $default(_that.message,_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class _TaskError implements TaskError {
  const _TaskError({required this.message, this.error, this.stackTrace});
  

/// Error message
@override final  String message;
/// Original error object (optional)
@override final  Object? error;
/// Stack trace (optional)
@override final  StackTrace? stackTrace;

/// Create a copy of TaskError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskErrorCopyWith<_TaskError> get copyWith => __$TaskErrorCopyWithImpl<_TaskError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'TaskError(message: $message, error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class _$TaskErrorCopyWith<$Res> implements $TaskErrorCopyWith<$Res> {
  factory _$TaskErrorCopyWith(_TaskError value, $Res Function(_TaskError) _then) = __$TaskErrorCopyWithImpl;
@override @useResult
$Res call({
 String message, Object? error, StackTrace? stackTrace
});




}
/// @nodoc
class __$TaskErrorCopyWithImpl<$Res>
    implements _$TaskErrorCopyWith<$Res> {
  __$TaskErrorCopyWithImpl(this._self, this._then);

  final _TaskError _self;
  final $Res Function(_TaskError) _then;

/// Create a copy of TaskError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? error = freezed,Object? stackTrace = freezed,}) {
  return _then(_TaskError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error ,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

/// @nodoc
mixin _$TaskResult<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskResult<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskResult<$T>()';
}


}

/// @nodoc
class $TaskResultCopyWith<T,$Res>  {
$TaskResultCopyWith(TaskResult<T> _, $Res Function(TaskResult<T>) __);
}


/// Adds pattern-matching-related methods to [TaskResult].
extension TaskResultPatterns<T> on TaskResult<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TaskSuccess<T> value)?  success,TResult Function( TaskFailure<T> value)?  failure,TResult Function( TaskCancelled<T> value)?  cancelled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TaskSuccess() when success != null:
return success(_that);case TaskFailure() when failure != null:
return failure(_that);case TaskCancelled() when cancelled != null:
return cancelled(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TaskSuccess<T> value)  success,required TResult Function( TaskFailure<T> value)  failure,required TResult Function( TaskCancelled<T> value)  cancelled,}){
final _that = this;
switch (_that) {
case TaskSuccess():
return success(_that);case TaskFailure():
return failure(_that);case TaskCancelled():
return cancelled(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TaskSuccess<T> value)?  success,TResult? Function( TaskFailure<T> value)?  failure,TResult? Function( TaskCancelled<T> value)?  cancelled,}){
final _that = this;
switch (_that) {
case TaskSuccess() when success != null:
return success(_that);case TaskFailure() when failure != null:
return failure(_that);case TaskCancelled() when cancelled != null:
return cancelled(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( T data)?  success,TResult Function( TaskError error)?  failure,TResult Function()?  cancelled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TaskSuccess() when success != null:
return success(_that.data);case TaskFailure() when failure != null:
return failure(_that.error);case TaskCancelled() when cancelled != null:
return cancelled();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( T data)  success,required TResult Function( TaskError error)  failure,required TResult Function()  cancelled,}) {final _that = this;
switch (_that) {
case TaskSuccess():
return success(_that.data);case TaskFailure():
return failure(_that.error);case TaskCancelled():
return cancelled();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( T data)?  success,TResult? Function( TaskError error)?  failure,TResult? Function()?  cancelled,}) {final _that = this;
switch (_that) {
case TaskSuccess() when success != null:
return success(_that.data);case TaskFailure() when failure != null:
return failure(_that.error);case TaskCancelled() when cancelled != null:
return cancelled();case _:
  return null;

}
}

}

/// @nodoc


class TaskSuccess<T> implements TaskResult<T> {
  const TaskSuccess({required this.data});
  

 final  T data;

/// Create a copy of TaskResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskSuccessCopyWith<T, TaskSuccess<T>> get copyWith => _$TaskSuccessCopyWithImpl<T, TaskSuccess<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSuccess<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'TaskResult<$T>.success(data: $data)';
}


}

/// @nodoc
abstract mixin class $TaskSuccessCopyWith<T,$Res> implements $TaskResultCopyWith<T, $Res> {
  factory $TaskSuccessCopyWith(TaskSuccess<T> value, $Res Function(TaskSuccess<T>) _then) = _$TaskSuccessCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class _$TaskSuccessCopyWithImpl<T,$Res>
    implements $TaskSuccessCopyWith<T, $Res> {
  _$TaskSuccessCopyWithImpl(this._self, this._then);

  final TaskSuccess<T> _self;
  final $Res Function(TaskSuccess<T>) _then;

/// Create a copy of TaskResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(TaskSuccess<T>(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class TaskFailure<T> implements TaskResult<T> {
  const TaskFailure({required this.error});
  

 final  TaskError error;

/// Create a copy of TaskResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskFailureCopyWith<T, TaskFailure<T>> get copyWith => _$TaskFailureCopyWithImpl<T, TaskFailure<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFailure<T>&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'TaskResult<$T>.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class $TaskFailureCopyWith<T,$Res> implements $TaskResultCopyWith<T, $Res> {
  factory $TaskFailureCopyWith(TaskFailure<T> value, $Res Function(TaskFailure<T>) _then) = _$TaskFailureCopyWithImpl;
@useResult
$Res call({
 TaskError error
});


$TaskErrorCopyWith<$Res> get error;

}
/// @nodoc
class _$TaskFailureCopyWithImpl<T,$Res>
    implements $TaskFailureCopyWith<T, $Res> {
  _$TaskFailureCopyWithImpl(this._self, this._then);

  final TaskFailure<T> _self;
  final $Res Function(TaskFailure<T>) _then;

/// Create a copy of TaskResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(TaskFailure<T>(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as TaskError,
  ));
}

/// Create a copy of TaskResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskErrorCopyWith<$Res> get error {
  
  return $TaskErrorCopyWith<$Res>(_self.error, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

/// @nodoc


class TaskCancelled<T> implements TaskResult<T> {
  const TaskCancelled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskCancelled<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskResult<$T>.cancelled()';
}


}




/// @nodoc
mixin _$TaskEvent {

/// Type of event
 TaskEventType get type;/// Task ID
 String get taskId;/// Time when the event occurred
 DateTime get timestamp;/// Task progress information (for progress update events)
 TaskProgress? get progress;/// Task error information (for failure events)
 TaskError? get error;/// Task result (for completion events)
 dynamic get result;
/// Create a copy of TaskEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskEventCopyWith<TaskEvent> get copyWith => _$TaskEventCopyWithImpl<TaskEvent>(this as TaskEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskEvent&&(identical(other.type, type) || other.type == type)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other.result, result));
}


@override
int get hashCode => Object.hash(runtimeType,type,taskId,timestamp,progress,error,const DeepCollectionEquality().hash(result));

@override
String toString() {
  return 'TaskEvent(type: $type, taskId: $taskId, timestamp: $timestamp, progress: $progress, error: $error, result: $result)';
}


}

/// @nodoc
abstract mixin class $TaskEventCopyWith<$Res>  {
  factory $TaskEventCopyWith(TaskEvent value, $Res Function(TaskEvent) _then) = _$TaskEventCopyWithImpl;
@useResult
$Res call({
 TaskEventType type, String taskId, DateTime timestamp, TaskProgress? progress, TaskError? error, dynamic result
});


$TaskProgressCopyWith<$Res>? get progress;$TaskErrorCopyWith<$Res>? get error;

}
/// @nodoc
class _$TaskEventCopyWithImpl<$Res>
    implements $TaskEventCopyWith<$Res> {
  _$TaskEventCopyWithImpl(this._self, this._then);

  final TaskEvent _self;
  final $Res Function(TaskEvent) _then;

/// Create a copy of TaskEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? taskId = null,Object? timestamp = null,Object? progress = freezed,Object? error = freezed,Object? result = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskEventType,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as TaskProgress?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as TaskError?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}
/// Create a copy of TaskEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $TaskProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}/// Create a copy of TaskEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskErrorCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $TaskErrorCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskEvent].
extension TaskEventPatterns on TaskEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskEvent value)  $default,){
final _that = this;
switch (_that) {
case _TaskEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskEvent value)?  $default,){
final _that = this;
switch (_that) {
case _TaskEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskEventType type,  String taskId,  DateTime timestamp,  TaskProgress? progress,  TaskError? error,  dynamic result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskEvent() when $default != null:
return $default(_that.type,_that.taskId,_that.timestamp,_that.progress,_that.error,_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskEventType type,  String taskId,  DateTime timestamp,  TaskProgress? progress,  TaskError? error,  dynamic result)  $default,) {final _that = this;
switch (_that) {
case _TaskEvent():
return $default(_that.type,_that.taskId,_that.timestamp,_that.progress,_that.error,_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskEventType type,  String taskId,  DateTime timestamp,  TaskProgress? progress,  TaskError? error,  dynamic result)?  $default,) {final _that = this;
switch (_that) {
case _TaskEvent() when $default != null:
return $default(_that.type,_that.taskId,_that.timestamp,_that.progress,_that.error,_that.result);case _:
  return null;

}
}

}

/// @nodoc


class _TaskEvent implements TaskEvent {
  const _TaskEvent({required this.type, required this.taskId, required this.timestamp, this.progress, this.error, this.result});
  

/// Type of event
@override final  TaskEventType type;
/// Task ID
@override final  String taskId;
/// Time when the event occurred
@override final  DateTime timestamp;
/// Task progress information (for progress update events)
@override final  TaskProgress? progress;
/// Task error information (for failure events)
@override final  TaskError? error;
/// Task result (for completion events)
@override final  dynamic result;

/// Create a copy of TaskEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskEventCopyWith<_TaskEvent> get copyWith => __$TaskEventCopyWithImpl<_TaskEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskEvent&&(identical(other.type, type) || other.type == type)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other.result, result));
}


@override
int get hashCode => Object.hash(runtimeType,type,taskId,timestamp,progress,error,const DeepCollectionEquality().hash(result));

@override
String toString() {
  return 'TaskEvent(type: $type, taskId: $taskId, timestamp: $timestamp, progress: $progress, error: $error, result: $result)';
}


}

/// @nodoc
abstract mixin class _$TaskEventCopyWith<$Res> implements $TaskEventCopyWith<$Res> {
  factory _$TaskEventCopyWith(_TaskEvent value, $Res Function(_TaskEvent) _then) = __$TaskEventCopyWithImpl;
@override @useResult
$Res call({
 TaskEventType type, String taskId, DateTime timestamp, TaskProgress? progress, TaskError? error, dynamic result
});


@override $TaskProgressCopyWith<$Res>? get progress;@override $TaskErrorCopyWith<$Res>? get error;

}
/// @nodoc
class __$TaskEventCopyWithImpl<$Res>
    implements _$TaskEventCopyWith<$Res> {
  __$TaskEventCopyWithImpl(this._self, this._then);

  final _TaskEvent _self;
  final $Res Function(_TaskEvent) _then;

/// Create a copy of TaskEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? taskId = null,Object? timestamp = null,Object? progress = freezed,Object? error = freezed,Object? result = freezed,}) {
  return _then(_TaskEvent(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TaskEventType,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as TaskProgress?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as TaskError?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

/// Create a copy of TaskEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $TaskProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}/// Create a copy of TaskEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskErrorCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $TaskErrorCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

// dart format on
