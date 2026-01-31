// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'period_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PeriodSummary {

 String get userId; String get userName; DateTime get periodStart; DateTime get periodEnd;@DurationConverter() Duration get totalWorked; int get entryCount; List<String> get entryIds; double? get hourlyRate; Currency get currency;
/// Create a copy of PeriodSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PeriodSummaryCopyWith<PeriodSummary> get copyWith => _$PeriodSummaryCopyWithImpl<PeriodSummary>(this as PeriodSummary, _$identity);

  /// Serializes this PeriodSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PeriodSummary&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.totalWorked, totalWorked) || other.totalWorked == totalWorked)&&(identical(other.entryCount, entryCount) || other.entryCount == entryCount)&&const DeepCollectionEquality().equals(other.entryIds, entryIds)&&(identical(other.hourlyRate, hourlyRate) || other.hourlyRate == hourlyRate)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,userName,periodStart,periodEnd,totalWorked,entryCount,const DeepCollectionEquality().hash(entryIds),hourlyRate,currency);

@override
String toString() {
  return 'PeriodSummary(userId: $userId, userName: $userName, periodStart: $periodStart, periodEnd: $periodEnd, totalWorked: $totalWorked, entryCount: $entryCount, entryIds: $entryIds, hourlyRate: $hourlyRate, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $PeriodSummaryCopyWith<$Res>  {
  factory $PeriodSummaryCopyWith(PeriodSummary value, $Res Function(PeriodSummary) _then) = _$PeriodSummaryCopyWithImpl;
@useResult
$Res call({
 String userId, String userName, DateTime periodStart, DateTime periodEnd,@DurationConverter() Duration totalWorked, int entryCount, List<String> entryIds, double? hourlyRate, Currency currency
});




}
/// @nodoc
class _$PeriodSummaryCopyWithImpl<$Res>
    implements $PeriodSummaryCopyWith<$Res> {
  _$PeriodSummaryCopyWithImpl(this._self, this._then);

  final PeriodSummary _self;
  final $Res Function(PeriodSummary) _then;

/// Create a copy of PeriodSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? userName = null,Object? periodStart = null,Object? periodEnd = null,Object? totalWorked = null,Object? entryCount = null,Object? entryIds = null,Object? hourlyRate = freezed,Object? currency = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,totalWorked: null == totalWorked ? _self.totalWorked : totalWorked // ignore: cast_nullable_to_non_nullable
as Duration,entryCount: null == entryCount ? _self.entryCount : entryCount // ignore: cast_nullable_to_non_nullable
as int,entryIds: null == entryIds ? _self.entryIds : entryIds // ignore: cast_nullable_to_non_nullable
as List<String>,hourlyRate: freezed == hourlyRate ? _self.hourlyRate : hourlyRate // ignore: cast_nullable_to_non_nullable
as double?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,
  ));
}

}


/// Adds pattern-matching-related methods to [PeriodSummary].
extension PeriodSummaryPatterns on PeriodSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PeriodSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PeriodSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PeriodSummary value)  $default,){
final _that = this;
switch (_that) {
case _PeriodSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PeriodSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PeriodSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String userName,  DateTime periodStart,  DateTime periodEnd, @DurationConverter()  Duration totalWorked,  int entryCount,  List<String> entryIds,  double? hourlyRate,  Currency currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PeriodSummary() when $default != null:
return $default(_that.userId,_that.userName,_that.periodStart,_that.periodEnd,_that.totalWorked,_that.entryCount,_that.entryIds,_that.hourlyRate,_that.currency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String userName,  DateTime periodStart,  DateTime periodEnd, @DurationConverter()  Duration totalWorked,  int entryCount,  List<String> entryIds,  double? hourlyRate,  Currency currency)  $default,) {final _that = this;
switch (_that) {
case _PeriodSummary():
return $default(_that.userId,_that.userName,_that.periodStart,_that.periodEnd,_that.totalWorked,_that.entryCount,_that.entryIds,_that.hourlyRate,_that.currency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String userName,  DateTime periodStart,  DateTime periodEnd, @DurationConverter()  Duration totalWorked,  int entryCount,  List<String> entryIds,  double? hourlyRate,  Currency currency)?  $default,) {final _that = this;
switch (_that) {
case _PeriodSummary() when $default != null:
return $default(_that.userId,_that.userName,_that.periodStart,_that.periodEnd,_that.totalWorked,_that.entryCount,_that.entryIds,_that.hourlyRate,_that.currency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PeriodSummary extends PeriodSummary {
  const _PeriodSummary({required this.userId, required this.userName, required this.periodStart, required this.periodEnd, @DurationConverter() required this.totalWorked, required this.entryCount, required final  List<String> entryIds, this.hourlyRate, this.currency = Currency.lei}): _entryIds = entryIds,super._();
  factory _PeriodSummary.fromJson(Map<String, dynamic> json) => _$PeriodSummaryFromJson(json);

@override final  String userId;
@override final  String userName;
@override final  DateTime periodStart;
@override final  DateTime periodEnd;
@override@DurationConverter() final  Duration totalWorked;
@override final  int entryCount;
 final  List<String> _entryIds;
@override List<String> get entryIds {
  if (_entryIds is EqualUnmodifiableListView) return _entryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entryIds);
}

@override final  double? hourlyRate;
@override@JsonKey() final  Currency currency;

/// Create a copy of PeriodSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PeriodSummaryCopyWith<_PeriodSummary> get copyWith => __$PeriodSummaryCopyWithImpl<_PeriodSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PeriodSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PeriodSummary&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.totalWorked, totalWorked) || other.totalWorked == totalWorked)&&(identical(other.entryCount, entryCount) || other.entryCount == entryCount)&&const DeepCollectionEquality().equals(other._entryIds, _entryIds)&&(identical(other.hourlyRate, hourlyRate) || other.hourlyRate == hourlyRate)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,userName,periodStart,periodEnd,totalWorked,entryCount,const DeepCollectionEquality().hash(_entryIds),hourlyRate,currency);

@override
String toString() {
  return 'PeriodSummary(userId: $userId, userName: $userName, periodStart: $periodStart, periodEnd: $periodEnd, totalWorked: $totalWorked, entryCount: $entryCount, entryIds: $entryIds, hourlyRate: $hourlyRate, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$PeriodSummaryCopyWith<$Res> implements $PeriodSummaryCopyWith<$Res> {
  factory _$PeriodSummaryCopyWith(_PeriodSummary value, $Res Function(_PeriodSummary) _then) = __$PeriodSummaryCopyWithImpl;
@override @useResult
$Res call({
 String userId, String userName, DateTime periodStart, DateTime periodEnd,@DurationConverter() Duration totalWorked, int entryCount, List<String> entryIds, double? hourlyRate, Currency currency
});




}
/// @nodoc
class __$PeriodSummaryCopyWithImpl<$Res>
    implements _$PeriodSummaryCopyWith<$Res> {
  __$PeriodSummaryCopyWithImpl(this._self, this._then);

  final _PeriodSummary _self;
  final $Res Function(_PeriodSummary) _then;

/// Create a copy of PeriodSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? userName = null,Object? periodStart = null,Object? periodEnd = null,Object? totalWorked = null,Object? entryCount = null,Object? entryIds = null,Object? hourlyRate = freezed,Object? currency = null,}) {
  return _then(_PeriodSummary(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,totalWorked: null == totalWorked ? _self.totalWorked : totalWorked // ignore: cast_nullable_to_non_nullable
as Duration,entryCount: null == entryCount ? _self.entryCount : entryCount // ignore: cast_nullable_to_non_nullable
as int,entryIds: null == entryIds ? _self._entryIds : entryIds // ignore: cast_nullable_to_non_nullable
as List<String>,hourlyRate: freezed == hourlyRate ? _self.hourlyRate : hourlyRate // ignore: cast_nullable_to_non_nullable
as double?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,
  ));
}


}

// dart format on
