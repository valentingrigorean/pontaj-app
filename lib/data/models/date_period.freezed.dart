// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_period.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DatePeriod {

 DateTime get startDate; DateTime get endDate; PeriodType get type;
/// Create a copy of DatePeriod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatePeriodCopyWith<DatePeriod> get copyWith => _$DatePeriodCopyWithImpl<DatePeriod>(this as DatePeriod, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DatePeriod&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,startDate,endDate,type);

@override
String toString() {
  return 'DatePeriod(startDate: $startDate, endDate: $endDate, type: $type)';
}


}

/// @nodoc
abstract mixin class $DatePeriodCopyWith<$Res>  {
  factory $DatePeriodCopyWith(DatePeriod value, $Res Function(DatePeriod) _then) = _$DatePeriodCopyWithImpl;
@useResult
$Res call({
 DateTime startDate, DateTime endDate, PeriodType type
});




}
/// @nodoc
class _$DatePeriodCopyWithImpl<$Res>
    implements $DatePeriodCopyWith<$Res> {
  _$DatePeriodCopyWithImpl(this._self, this._then);

  final DatePeriod _self;
  final $Res Function(DatePeriod) _then;

/// Create a copy of DatePeriod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startDate = null,Object? endDate = null,Object? type = null,}) {
  return _then(_self.copyWith(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PeriodType,
  ));
}

}


/// Adds pattern-matching-related methods to [DatePeriod].
extension DatePeriodPatterns on DatePeriod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DatePeriod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DatePeriod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DatePeriod value)  $default,){
final _that = this;
switch (_that) {
case _DatePeriod():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DatePeriod value)?  $default,){
final _that = this;
switch (_that) {
case _DatePeriod() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime startDate,  DateTime endDate,  PeriodType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DatePeriod() when $default != null:
return $default(_that.startDate,_that.endDate,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime startDate,  DateTime endDate,  PeriodType type)  $default,) {final _that = this;
switch (_that) {
case _DatePeriod():
return $default(_that.startDate,_that.endDate,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime startDate,  DateTime endDate,  PeriodType type)?  $default,) {final _that = this;
switch (_that) {
case _DatePeriod() when $default != null:
return $default(_that.startDate,_that.endDate,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _DatePeriod extends DatePeriod {
  const _DatePeriod({required this.startDate, required this.endDate, required this.type}): super._();
  

@override final  DateTime startDate;
@override final  DateTime endDate;
@override final  PeriodType type;

/// Create a copy of DatePeriod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DatePeriodCopyWith<_DatePeriod> get copyWith => __$DatePeriodCopyWithImpl<_DatePeriod>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DatePeriod&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,startDate,endDate,type);

@override
String toString() {
  return 'DatePeriod(startDate: $startDate, endDate: $endDate, type: $type)';
}


}

/// @nodoc
abstract mixin class _$DatePeriodCopyWith<$Res> implements $DatePeriodCopyWith<$Res> {
  factory _$DatePeriodCopyWith(_DatePeriod value, $Res Function(_DatePeriod) _then) = __$DatePeriodCopyWithImpl;
@override @useResult
$Res call({
 DateTime startDate, DateTime endDate, PeriodType type
});




}
/// @nodoc
class __$DatePeriodCopyWithImpl<$Res>
    implements _$DatePeriodCopyWith<$Res> {
  __$DatePeriodCopyWithImpl(this._self, this._then);

  final _DatePeriod _self;
  final $Res Function(_DatePeriod) _then;

/// Create a copy of DatePeriod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startDate = null,Object? endDate = null,Object? type = null,}) {
  return _then(_DatePeriod(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PeriodType,
  ));
}


}

// dart format on
