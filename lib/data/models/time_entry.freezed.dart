// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimeEntry {

 String? get id; String? get userId; String get userName; String get location; String get intervalText; int get breakMinutes;@TimestampConverter() DateTime get date;@DurationConverter() Duration get totalWorked;@ServerTimestampConverter() DateTime? get createdAt;
/// Create a copy of TimeEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeEntryCopyWith<TimeEntry> get copyWith => _$TimeEntryCopyWithImpl<TimeEntry>(this as TimeEntry, _$identity);

  /// Serializes this TimeEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.location, location) || other.location == location)&&(identical(other.intervalText, intervalText) || other.intervalText == intervalText)&&(identical(other.breakMinutes, breakMinutes) || other.breakMinutes == breakMinutes)&&(identical(other.date, date) || other.date == date)&&(identical(other.totalWorked, totalWorked) || other.totalWorked == totalWorked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,location,intervalText,breakMinutes,date,totalWorked,createdAt);

@override
String toString() {
  return 'TimeEntry(id: $id, userId: $userId, userName: $userName, location: $location, intervalText: $intervalText, breakMinutes: $breakMinutes, date: $date, totalWorked: $totalWorked, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TimeEntryCopyWith<$Res>  {
  factory $TimeEntryCopyWith(TimeEntry value, $Res Function(TimeEntry) _then) = _$TimeEntryCopyWithImpl;
@useResult
$Res call({
 String? id, String? userId, String userName, String location, String intervalText, int breakMinutes,@TimestampConverter() DateTime date,@DurationConverter() Duration totalWorked,@ServerTimestampConverter() DateTime? createdAt
});




}
/// @nodoc
class _$TimeEntryCopyWithImpl<$Res>
    implements $TimeEntryCopyWith<$Res> {
  _$TimeEntryCopyWithImpl(this._self, this._then);

  final TimeEntry _self;
  final $Res Function(TimeEntry) _then;

/// Create a copy of TimeEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? userName = null,Object? location = null,Object? intervalText = null,Object? breakMinutes = null,Object? date = null,Object? totalWorked = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,intervalText: null == intervalText ? _self.intervalText : intervalText // ignore: cast_nullable_to_non_nullable
as String,breakMinutes: null == breakMinutes ? _self.breakMinutes : breakMinutes // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,totalWorked: null == totalWorked ? _self.totalWorked : totalWorked // ignore: cast_nullable_to_non_nullable
as Duration,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeEntry].
extension TimeEntryPatterns on TimeEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeEntry value)  $default,){
final _that = this;
switch (_that) {
case _TimeEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeEntry value)?  $default,){
final _that = this;
switch (_that) {
case _TimeEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? userId,  String userName,  String location,  String intervalText,  int breakMinutes, @TimestampConverter()  DateTime date, @DurationConverter()  Duration totalWorked, @ServerTimestampConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeEntry() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.location,_that.intervalText,_that.breakMinutes,_that.date,_that.totalWorked,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? userId,  String userName,  String location,  String intervalText,  int breakMinutes, @TimestampConverter()  DateTime date, @DurationConverter()  Duration totalWorked, @ServerTimestampConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _TimeEntry():
return $default(_that.id,_that.userId,_that.userName,_that.location,_that.intervalText,_that.breakMinutes,_that.date,_that.totalWorked,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? userId,  String userName,  String location,  String intervalText,  int breakMinutes, @TimestampConverter()  DateTime date, @DurationConverter()  Duration totalWorked, @ServerTimestampConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TimeEntry() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.location,_that.intervalText,_that.breakMinutes,_that.date,_that.totalWorked,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeEntry extends TimeEntry {
  const _TimeEntry({this.id, this.userId, required this.userName, required this.location, required this.intervalText, this.breakMinutes = 0, @TimestampConverter() required this.date, @DurationConverter() required this.totalWorked, @ServerTimestampConverter() this.createdAt}): super._();
  factory _TimeEntry.fromJson(Map<String, dynamic> json) => _$TimeEntryFromJson(json);

@override final  String? id;
@override final  String? userId;
@override final  String userName;
@override final  String location;
@override final  String intervalText;
@override@JsonKey() final  int breakMinutes;
@override@TimestampConverter() final  DateTime date;
@override@DurationConverter() final  Duration totalWorked;
@override@ServerTimestampConverter() final  DateTime? createdAt;

/// Create a copy of TimeEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeEntryCopyWith<_TimeEntry> get copyWith => __$TimeEntryCopyWithImpl<_TimeEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.location, location) || other.location == location)&&(identical(other.intervalText, intervalText) || other.intervalText == intervalText)&&(identical(other.breakMinutes, breakMinutes) || other.breakMinutes == breakMinutes)&&(identical(other.date, date) || other.date == date)&&(identical(other.totalWorked, totalWorked) || other.totalWorked == totalWorked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,location,intervalText,breakMinutes,date,totalWorked,createdAt);

@override
String toString() {
  return 'TimeEntry(id: $id, userId: $userId, userName: $userName, location: $location, intervalText: $intervalText, breakMinutes: $breakMinutes, date: $date, totalWorked: $totalWorked, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TimeEntryCopyWith<$Res> implements $TimeEntryCopyWith<$Res> {
  factory _$TimeEntryCopyWith(_TimeEntry value, $Res Function(_TimeEntry) _then) = __$TimeEntryCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? userId, String userName, String location, String intervalText, int breakMinutes,@TimestampConverter() DateTime date,@DurationConverter() Duration totalWorked,@ServerTimestampConverter() DateTime? createdAt
});




}
/// @nodoc
class __$TimeEntryCopyWithImpl<$Res>
    implements _$TimeEntryCopyWith<$Res> {
  __$TimeEntryCopyWithImpl(this._self, this._then);

  final _TimeEntry _self;
  final $Res Function(_TimeEntry) _then;

/// Create a copy of TimeEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? userName = null,Object? location = null,Object? intervalText = null,Object? breakMinutes = null,Object? date = null,Object? totalWorked = null,Object? createdAt = freezed,}) {
  return _then(_TimeEntry(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,intervalText: null == intervalText ? _self.intervalText : intervalText // ignore: cast_nullable_to_non_nullable
as String,breakMinutes: null == breakMinutes ? _self.breakMinutes : breakMinutes // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,totalWorked: null == totalWorked ? _self.totalWorked : totalWorked // ignore: cast_nullable_to_non_nullable
as Duration,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
