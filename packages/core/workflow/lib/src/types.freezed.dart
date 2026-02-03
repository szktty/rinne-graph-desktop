// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'types.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TaskProgress {
  /// Progress rate (0.0 to 1.0)
  double get value => throw _privateConstructorUsedError;

  /// Message regarding progress (optional)
  String? get message => throw _privateConstructorUsedError;

  /// Current step (optional)
  String? get currentStep => throw _privateConstructorUsedError;

  /// Total number of steps (optional)
  int? get totalSteps => throw _privateConstructorUsedError;

  /// Current step number (optional)
  int? get currentStepNumber => throw _privateConstructorUsedError;

  /// Create a copy of TaskProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskProgressCopyWith<TaskProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskProgressCopyWith<$Res> {
  factory $TaskProgressCopyWith(
    TaskProgress value,
    $Res Function(TaskProgress) then,
  ) = _$TaskProgressCopyWithImpl<$Res, TaskProgress>;
  @useResult
  $Res call({
    double value,
    String? message,
    String? currentStep,
    int? totalSteps,
    int? currentStepNumber,
  });
}

/// @nodoc
class _$TaskProgressCopyWithImpl<$Res, $Val extends TaskProgress>
    implements $TaskProgressCopyWith<$Res> {
  _$TaskProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? message = freezed,
    Object? currentStep = freezed,
    Object? totalSteps = freezed,
    Object? currentStepNumber = freezed,
  }) {
    return _then(
      _value.copyWith(
            value:
                null == value
                    ? _value.value
                    : value // ignore: cast_nullable_to_non_nullable
                        as double,
            message:
                freezed == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String?,
            currentStep:
                freezed == currentStep
                    ? _value.currentStep
                    : currentStep // ignore: cast_nullable_to_non_nullable
                        as String?,
            totalSteps:
                freezed == totalSteps
                    ? _value.totalSteps
                    : totalSteps // ignore: cast_nullable_to_non_nullable
                        as int?,
            currentStepNumber:
                freezed == currentStepNumber
                    ? _value.currentStepNumber
                    : currentStepNumber // ignore: cast_nullable_to_non_nullable
                        as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskProgressImplCopyWith<$Res>
    implements $TaskProgressCopyWith<$Res> {
  factory _$$TaskProgressImplCopyWith(
    _$TaskProgressImpl value,
    $Res Function(_$TaskProgressImpl) then,
  ) = __$$TaskProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double value,
    String? message,
    String? currentStep,
    int? totalSteps,
    int? currentStepNumber,
  });
}

/// @nodoc
class __$$TaskProgressImplCopyWithImpl<$Res>
    extends _$TaskProgressCopyWithImpl<$Res, _$TaskProgressImpl>
    implements _$$TaskProgressImplCopyWith<$Res> {
  __$$TaskProgressImplCopyWithImpl(
    _$TaskProgressImpl _value,
    $Res Function(_$TaskProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? message = freezed,
    Object? currentStep = freezed,
    Object? totalSteps = freezed,
    Object? currentStepNumber = freezed,
  }) {
    return _then(
      _$TaskProgressImpl(
        value:
            null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                    as double,
        message:
            freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String?,
        currentStep:
            freezed == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                    as String?,
        totalSteps:
            freezed == totalSteps
                ? _value.totalSteps
                : totalSteps // ignore: cast_nullable_to_non_nullable
                    as int?,
        currentStepNumber:
            freezed == currentStepNumber
                ? _value.currentStepNumber
                : currentStepNumber // ignore: cast_nullable_to_non_nullable
                    as int?,
      ),
    );
  }
}

/// @nodoc

class _$TaskProgressImpl implements _TaskProgress {
  const _$TaskProgressImpl({
    required this.value,
    this.message,
    this.currentStep,
    this.totalSteps,
    this.currentStepNumber,
  });

  /// Progress rate (0.0 to 1.0)
  @override
  final double value;

  /// Message regarding progress (optional)
  @override
  final String? message;

  /// Current step (optional)
  @override
  final String? currentStep;

  /// Total number of steps (optional)
  @override
  final int? totalSteps;

  /// Current step number (optional)
  @override
  final int? currentStepNumber;

  @override
  String toString() {
    return 'TaskProgress(value: $value, message: $message, currentStep: $currentStep, totalSteps: $totalSteps, currentStepNumber: $currentStepNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskProgressImpl &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.totalSteps, totalSteps) ||
                other.totalSteps == totalSteps) &&
            (identical(other.currentStepNumber, currentStepNumber) ||
                other.currentStepNumber == currentStepNumber));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    value,
    message,
    currentStep,
    totalSteps,
    currentStepNumber,
  );

  /// Create a copy of TaskProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskProgressImplCopyWith<_$TaskProgressImpl> get copyWith =>
      __$$TaskProgressImplCopyWithImpl<_$TaskProgressImpl>(this, _$identity);
}

abstract class _TaskProgress implements TaskProgress {
  const factory _TaskProgress({
    required final double value,
    final String? message,
    final String? currentStep,
    final int? totalSteps,
    final int? currentStepNumber,
  }) = _$TaskProgressImpl;

  /// Progress rate (0.0 to 1.0)
  @override
  double get value;

  /// Message regarding progress (optional)
  @override
  String? get message;

  /// Current step (optional)
  @override
  String? get currentStep;

  /// Total number of steps (optional)
  @override
  int? get totalSteps;

  /// Current step number (optional)
  @override
  int? get currentStepNumber;

  /// Create a copy of TaskProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskProgressImplCopyWith<_$TaskProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TaskError {
  /// Error message
  String get message => throw _privateConstructorUsedError;

  /// Original error object (optional)
  Object? get error => throw _privateConstructorUsedError;

  /// Stack trace (optional)
  StackTrace? get stackTrace => throw _privateConstructorUsedError;

  /// Create a copy of TaskError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskErrorCopyWith<TaskError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskErrorCopyWith<$Res> {
  factory $TaskErrorCopyWith(TaskError value, $Res Function(TaskError) then) =
      _$TaskErrorCopyWithImpl<$Res, TaskError>;
  @useResult
  $Res call({String message, Object? error, StackTrace? stackTrace});
}

/// @nodoc
class _$TaskErrorCopyWithImpl<$Res, $Val extends TaskError>
    implements $TaskErrorCopyWith<$Res> {
  _$TaskErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(
      _value.copyWith(
            message:
                null == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String,
            error: freezed == error ? _value.error : error,
            stackTrace:
                freezed == stackTrace
                    ? _value.stackTrace
                    : stackTrace // ignore: cast_nullable_to_non_nullable
                        as StackTrace?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskErrorImplCopyWith<$Res>
    implements $TaskErrorCopyWith<$Res> {
  factory _$$TaskErrorImplCopyWith(
    _$TaskErrorImpl value,
    $Res Function(_$TaskErrorImpl) then,
  ) = __$$TaskErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Object? error, StackTrace? stackTrace});
}

/// @nodoc
class __$$TaskErrorImplCopyWithImpl<$Res>
    extends _$TaskErrorCopyWithImpl<$Res, _$TaskErrorImpl>
    implements _$$TaskErrorImplCopyWith<$Res> {
  __$$TaskErrorImplCopyWithImpl(
    _$TaskErrorImpl _value,
    $Res Function(_$TaskErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(
      _$TaskErrorImpl(
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
        error: freezed == error ? _value.error : error,
        stackTrace:
            freezed == stackTrace
                ? _value.stackTrace
                : stackTrace // ignore: cast_nullable_to_non_nullable
                    as StackTrace?,
      ),
    );
  }
}

/// @nodoc

class _$TaskErrorImpl implements _TaskError {
  const _$TaskErrorImpl({required this.message, this.error, this.stackTrace});

  /// Error message
  @override
  final String message;

  /// Original error object (optional)
  @override
  final Object? error;

  /// Stack trace (optional)
  @override
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'TaskError(message: $message, error: $error, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(error),
    stackTrace,
  );

  /// Create a copy of TaskError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskErrorImplCopyWith<_$TaskErrorImpl> get copyWith =>
      __$$TaskErrorImplCopyWithImpl<_$TaskErrorImpl>(this, _$identity);
}

abstract class _TaskError implements TaskError {
  const factory _TaskError({
    required final String message,
    final Object? error,
    final StackTrace? stackTrace,
  }) = _$TaskErrorImpl;

  /// Error message
  @override
  String get message;

  /// Original error object (optional)
  @override
  Object? get error;

  /// Stack trace (optional)
  @override
  StackTrace? get stackTrace;

  /// Create a copy of TaskError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskErrorImplCopyWith<_$TaskErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TaskResult<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) success,
    required TResult Function(TaskError error) failure,
    required TResult Function() cancelled,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T data)? success,
    TResult? Function(TaskError error)? failure,
    TResult? Function()? cancelled,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? success,
    TResult Function(TaskError error)? failure,
    TResult Function()? cancelled,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskSuccess<T> value) success,
    required TResult Function(TaskFailure<T> value) failure,
    required TResult Function(TaskCancelled<T> value) cancelled,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskSuccess<T> value)? success,
    TResult? Function(TaskFailure<T> value)? failure,
    TResult? Function(TaskCancelled<T> value)? cancelled,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskSuccess<T> value)? success,
    TResult Function(TaskFailure<T> value)? failure,
    TResult Function(TaskCancelled<T> value)? cancelled,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskResultCopyWith<T, $Res> {
  factory $TaskResultCopyWith(
    TaskResult<T> value,
    $Res Function(TaskResult<T>) then,
  ) = _$TaskResultCopyWithImpl<T, $Res, TaskResult<T>>;
}

/// @nodoc
class _$TaskResultCopyWithImpl<T, $Res, $Val extends TaskResult<T>>
    implements $TaskResultCopyWith<T, $Res> {
  _$TaskResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$TaskSuccessImplCopyWith<T, $Res> {
  factory _$$TaskSuccessImplCopyWith(
    _$TaskSuccessImpl<T> value,
    $Res Function(_$TaskSuccessImpl<T>) then,
  ) = __$$TaskSuccessImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$TaskSuccessImplCopyWithImpl<T, $Res>
    extends _$TaskResultCopyWithImpl<T, $Res, _$TaskSuccessImpl<T>>
    implements _$$TaskSuccessImplCopyWith<T, $Res> {
  __$$TaskSuccessImplCopyWithImpl(
    _$TaskSuccessImpl<T> _value,
    $Res Function(_$TaskSuccessImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = freezed}) {
    return _then(
      _$TaskSuccessImpl<T>(
        data:
            freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                    as T,
      ),
    );
  }
}

/// @nodoc

class _$TaskSuccessImpl<T> implements TaskSuccess<T> {
  const _$TaskSuccessImpl({required this.data});

  @override
  final T data;

  @override
  String toString() {
    return 'TaskResult<$T>.success(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskSuccessImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  /// Create a copy of TaskResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskSuccessImplCopyWith<T, _$TaskSuccessImpl<T>> get copyWith =>
      __$$TaskSuccessImplCopyWithImpl<T, _$TaskSuccessImpl<T>>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) success,
    required TResult Function(TaskError error) failure,
    required TResult Function() cancelled,
  }) {
    return success(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T data)? success,
    TResult? Function(TaskError error)? failure,
    TResult? Function()? cancelled,
  }) {
    return success?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? success,
    TResult Function(TaskError error)? failure,
    TResult Function()? cancelled,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskSuccess<T> value) success,
    required TResult Function(TaskFailure<T> value) failure,
    required TResult Function(TaskCancelled<T> value) cancelled,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskSuccess<T> value)? success,
    TResult? Function(TaskFailure<T> value)? failure,
    TResult? Function(TaskCancelled<T> value)? cancelled,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskSuccess<T> value)? success,
    TResult Function(TaskFailure<T> value)? failure,
    TResult Function(TaskCancelled<T> value)? cancelled,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class TaskSuccess<T> implements TaskResult<T> {
  const factory TaskSuccess({required final T data}) = _$TaskSuccessImpl<T>;

  T get data;

  /// Create a copy of TaskResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskSuccessImplCopyWith<T, _$TaskSuccessImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TaskFailureImplCopyWith<T, $Res> {
  factory _$$TaskFailureImplCopyWith(
    _$TaskFailureImpl<T> value,
    $Res Function(_$TaskFailureImpl<T>) then,
  ) = __$$TaskFailureImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({TaskError error});

  $TaskErrorCopyWith<$Res> get error;
}

/// @nodoc
class __$$TaskFailureImplCopyWithImpl<T, $Res>
    extends _$TaskResultCopyWithImpl<T, $Res, _$TaskFailureImpl<T>>
    implements _$$TaskFailureImplCopyWith<T, $Res> {
  __$$TaskFailureImplCopyWithImpl(
    _$TaskFailureImpl<T> _value,
    $Res Function(_$TaskFailureImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null}) {
    return _then(
      _$TaskFailureImpl<T>(
        error:
            null == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as TaskError,
      ),
    );
  }

  /// Create a copy of TaskResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaskErrorCopyWith<$Res> get error {
    return $TaskErrorCopyWith<$Res>(_value.error, (value) {
      return _then(_value.copyWith(error: value));
    });
  }
}

/// @nodoc

class _$TaskFailureImpl<T> implements TaskFailure<T> {
  const _$TaskFailureImpl({required this.error});

  @override
  final TaskError error;

  @override
  String toString() {
    return 'TaskResult<$T>.failure(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskFailureImpl<T> &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of TaskResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskFailureImplCopyWith<T, _$TaskFailureImpl<T>> get copyWith =>
      __$$TaskFailureImplCopyWithImpl<T, _$TaskFailureImpl<T>>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) success,
    required TResult Function(TaskError error) failure,
    required TResult Function() cancelled,
  }) {
    return failure(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T data)? success,
    TResult? Function(TaskError error)? failure,
    TResult? Function()? cancelled,
  }) {
    return failure?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? success,
    TResult Function(TaskError error)? failure,
    TResult Function()? cancelled,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskSuccess<T> value) success,
    required TResult Function(TaskFailure<T> value) failure,
    required TResult Function(TaskCancelled<T> value) cancelled,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskSuccess<T> value)? success,
    TResult? Function(TaskFailure<T> value)? failure,
    TResult? Function(TaskCancelled<T> value)? cancelled,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskSuccess<T> value)? success,
    TResult Function(TaskFailure<T> value)? failure,
    TResult Function(TaskCancelled<T> value)? cancelled,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class TaskFailure<T> implements TaskResult<T> {
  const factory TaskFailure({required final TaskError error}) =
      _$TaskFailureImpl<T>;

  TaskError get error;

  /// Create a copy of TaskResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskFailureImplCopyWith<T, _$TaskFailureImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TaskCancelledImplCopyWith<T, $Res> {
  factory _$$TaskCancelledImplCopyWith(
    _$TaskCancelledImpl<T> value,
    $Res Function(_$TaskCancelledImpl<T>) then,
  ) = __$$TaskCancelledImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$TaskCancelledImplCopyWithImpl<T, $Res>
    extends _$TaskResultCopyWithImpl<T, $Res, _$TaskCancelledImpl<T>>
    implements _$$TaskCancelledImplCopyWith<T, $Res> {
  __$$TaskCancelledImplCopyWithImpl(
    _$TaskCancelledImpl<T> _value,
    $Res Function(_$TaskCancelledImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TaskCancelledImpl<T> implements TaskCancelled<T> {
  const _$TaskCancelledImpl();

  @override
  String toString() {
    return 'TaskResult<$T>.cancelled()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TaskCancelledImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) success,
    required TResult Function(TaskError error) failure,
    required TResult Function() cancelled,
  }) {
    return cancelled();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T data)? success,
    TResult? Function(TaskError error)? failure,
    TResult? Function()? cancelled,
  }) {
    return cancelled?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? success,
    TResult Function(TaskError error)? failure,
    TResult Function()? cancelled,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TaskSuccess<T> value) success,
    required TResult Function(TaskFailure<T> value) failure,
    required TResult Function(TaskCancelled<T> value) cancelled,
  }) {
    return cancelled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TaskSuccess<T> value)? success,
    TResult? Function(TaskFailure<T> value)? failure,
    TResult? Function(TaskCancelled<T> value)? cancelled,
  }) {
    return cancelled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TaskSuccess<T> value)? success,
    TResult Function(TaskFailure<T> value)? failure,
    TResult Function(TaskCancelled<T> value)? cancelled,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled(this);
    }
    return orElse();
  }
}

abstract class TaskCancelled<T> implements TaskResult<T> {
  const factory TaskCancelled() = _$TaskCancelledImpl<T>;
}

/// @nodoc
mixin _$TaskEvent {
  /// Type of event
  TaskEventType get type => throw _privateConstructorUsedError;

  /// Task ID
  String get taskId => throw _privateConstructorUsedError;

  /// Time when the event occurred
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Task progress information (for progress update events)
  TaskProgress? get progress => throw _privateConstructorUsedError;

  /// Task error information (for failure events)
  TaskError? get error => throw _privateConstructorUsedError;

  /// Task result (for completion events)
  dynamic get result => throw _privateConstructorUsedError;

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskEventCopyWith<TaskEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskEventCopyWith<$Res> {
  factory $TaskEventCopyWith(TaskEvent value, $Res Function(TaskEvent) then) =
      _$TaskEventCopyWithImpl<$Res, TaskEvent>;
  @useResult
  $Res call({
    TaskEventType type,
    String taskId,
    DateTime timestamp,
    TaskProgress? progress,
    TaskError? error,
    dynamic result,
  });

  $TaskProgressCopyWith<$Res>? get progress;
  $TaskErrorCopyWith<$Res>? get error;
}

/// @nodoc
class _$TaskEventCopyWithImpl<$Res, $Val extends TaskEvent>
    implements $TaskEventCopyWith<$Res> {
  _$TaskEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? taskId = null,
    Object? timestamp = null,
    Object? progress = freezed,
    Object? error = freezed,
    Object? result = freezed,
  }) {
    return _then(
      _value.copyWith(
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as TaskEventType,
            taskId:
                null == taskId
                    ? _value.taskId
                    : taskId // ignore: cast_nullable_to_non_nullable
                        as String,
            timestamp:
                null == timestamp
                    ? _value.timestamp
                    : timestamp // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            progress:
                freezed == progress
                    ? _value.progress
                    : progress // ignore: cast_nullable_to_non_nullable
                        as TaskProgress?,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as TaskError?,
            result:
                freezed == result
                    ? _value.result
                    : result // ignore: cast_nullable_to_non_nullable
                        as dynamic,
          )
          as $Val,
    );
  }

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaskProgressCopyWith<$Res>? get progress {
    if (_value.progress == null) {
      return null;
    }

    return $TaskProgressCopyWith<$Res>(_value.progress!, (value) {
      return _then(_value.copyWith(progress: value) as $Val);
    });
  }

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaskErrorCopyWith<$Res>? get error {
    if (_value.error == null) {
      return null;
    }

    return $TaskErrorCopyWith<$Res>(_value.error!, (value) {
      return _then(_value.copyWith(error: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskEventImplCopyWith<$Res>
    implements $TaskEventCopyWith<$Res> {
  factory _$$TaskEventImplCopyWith(
    _$TaskEventImpl value,
    $Res Function(_$TaskEventImpl) then,
  ) = __$$TaskEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    TaskEventType type,
    String taskId,
    DateTime timestamp,
    TaskProgress? progress,
    TaskError? error,
    dynamic result,
  });

  @override
  $TaskProgressCopyWith<$Res>? get progress;
  @override
  $TaskErrorCopyWith<$Res>? get error;
}

/// @nodoc
class __$$TaskEventImplCopyWithImpl<$Res>
    extends _$TaskEventCopyWithImpl<$Res, _$TaskEventImpl>
    implements _$$TaskEventImplCopyWith<$Res> {
  __$$TaskEventImplCopyWithImpl(
    _$TaskEventImpl _value,
    $Res Function(_$TaskEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? taskId = null,
    Object? timestamp = null,
    Object? progress = freezed,
    Object? error = freezed,
    Object? result = freezed,
  }) {
    return _then(
      _$TaskEventImpl(
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as TaskEventType,
        taskId:
            null == taskId
                ? _value.taskId
                : taskId // ignore: cast_nullable_to_non_nullable
                    as String,
        timestamp:
            null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        progress:
            freezed == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                    as TaskProgress?,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as TaskError?,
        result:
            freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                    as dynamic,
      ),
    );
  }
}

/// @nodoc

class _$TaskEventImpl implements _TaskEvent {
  const _$TaskEventImpl({
    required this.type,
    required this.taskId,
    required this.timestamp,
    this.progress,
    this.error,
    this.result,
  });

  /// Type of event
  @override
  final TaskEventType type;

  /// Task ID
  @override
  final String taskId;

  /// Time when the event occurred
  @override
  final DateTime timestamp;

  /// Task progress information (for progress update events)
  @override
  final TaskProgress? progress;

  /// Task error information (for failure events)
  @override
  final TaskError? error;

  /// Task result (for completion events)
  @override
  final dynamic result;

  @override
  String toString() {
    return 'TaskEvent(type: $type, taskId: $taskId, timestamp: $timestamp, progress: $progress, error: $error, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskEventImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality().equals(other.result, result));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    taskId,
    timestamp,
    progress,
    error,
    const DeepCollectionEquality().hash(result),
  );

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskEventImplCopyWith<_$TaskEventImpl> get copyWith =>
      __$$TaskEventImplCopyWithImpl<_$TaskEventImpl>(this, _$identity);
}

abstract class _TaskEvent implements TaskEvent {
  const factory _TaskEvent({
    required final TaskEventType type,
    required final String taskId,
    required final DateTime timestamp,
    final TaskProgress? progress,
    final TaskError? error,
    final dynamic result,
  }) = _$TaskEventImpl;

  /// Type of event
  @override
  TaskEventType get type;

  /// Task ID
  @override
  String get taskId;

  /// Time when the event occurred
  @override
  DateTime get timestamp;

  /// Task progress information (for progress update events)
  @override
  TaskProgress? get progress;

  /// Task error information (for failure events)
  @override
  TaskError? get error;

  /// Task result (for completion events)
  @override
  dynamic get result;

  /// Create a copy of TaskEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskEventImplCopyWith<_$TaskEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
