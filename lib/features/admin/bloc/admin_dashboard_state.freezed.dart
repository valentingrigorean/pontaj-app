// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserPeriodComparison {

 String get userName; double get hoursThisPeriod; double get hoursLastPeriod; double get changePercent;
/// Create a copy of UserPeriodComparison
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPeriodComparisonCopyWith<UserPeriodComparison> get copyWith => _$UserPeriodComparisonCopyWithImpl<UserPeriodComparison>(this as UserPeriodComparison, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPeriodComparison&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.hoursThisPeriod, hoursThisPeriod) || other.hoursThisPeriod == hoursThisPeriod)&&(identical(other.hoursLastPeriod, hoursLastPeriod) || other.hoursLastPeriod == hoursLastPeriod)&&(identical(other.changePercent, changePercent) || other.changePercent == changePercent));
}


@override
int get hashCode => Object.hash(runtimeType,userName,hoursThisPeriod,hoursLastPeriod,changePercent);

@override
String toString() {
  return 'UserPeriodComparison(userName: $userName, hoursThisPeriod: $hoursThisPeriod, hoursLastPeriod: $hoursLastPeriod, changePercent: $changePercent)';
}


}

/// @nodoc
abstract mixin class $UserPeriodComparisonCopyWith<$Res>  {
  factory $UserPeriodComparisonCopyWith(UserPeriodComparison value, $Res Function(UserPeriodComparison) _then) = _$UserPeriodComparisonCopyWithImpl;
@useResult
$Res call({
 String userName, double hoursThisPeriod, double hoursLastPeriod, double changePercent
});




}
/// @nodoc
class _$UserPeriodComparisonCopyWithImpl<$Res>
    implements $UserPeriodComparisonCopyWith<$Res> {
  _$UserPeriodComparisonCopyWithImpl(this._self, this._then);

  final UserPeriodComparison _self;
  final $Res Function(UserPeriodComparison) _then;

/// Create a copy of UserPeriodComparison
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userName = null,Object? hoursThisPeriod = null,Object? hoursLastPeriod = null,Object? changePercent = null,}) {
  return _then(_self.copyWith(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,hoursThisPeriod: null == hoursThisPeriod ? _self.hoursThisPeriod : hoursThisPeriod // ignore: cast_nullable_to_non_nullable
as double,hoursLastPeriod: null == hoursLastPeriod ? _self.hoursLastPeriod : hoursLastPeriod // ignore: cast_nullable_to_non_nullable
as double,changePercent: null == changePercent ? _self.changePercent : changePercent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [UserPeriodComparison].
extension UserPeriodComparisonPatterns on UserPeriodComparison {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserPeriodComparison value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserPeriodComparison() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserPeriodComparison value)  $default,){
final _that = this;
switch (_that) {
case _UserPeriodComparison():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserPeriodComparison value)?  $default,){
final _that = this;
switch (_that) {
case _UserPeriodComparison() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userName,  double hoursThisPeriod,  double hoursLastPeriod,  double changePercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPeriodComparison() when $default != null:
return $default(_that.userName,_that.hoursThisPeriod,_that.hoursLastPeriod,_that.changePercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userName,  double hoursThisPeriod,  double hoursLastPeriod,  double changePercent)  $default,) {final _that = this;
switch (_that) {
case _UserPeriodComparison():
return $default(_that.userName,_that.hoursThisPeriod,_that.hoursLastPeriod,_that.changePercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userName,  double hoursThisPeriod,  double hoursLastPeriod,  double changePercent)?  $default,) {final _that = this;
switch (_that) {
case _UserPeriodComparison() when $default != null:
return $default(_that.userName,_that.hoursThisPeriod,_that.hoursLastPeriod,_that.changePercent);case _:
  return null;

}
}

}

/// @nodoc


class _UserPeriodComparison implements UserPeriodComparison {
  const _UserPeriodComparison({required this.userName, required this.hoursThisPeriod, required this.hoursLastPeriod, required this.changePercent});
  

@override final  String userName;
@override final  double hoursThisPeriod;
@override final  double hoursLastPeriod;
@override final  double changePercent;

/// Create a copy of UserPeriodComparison
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPeriodComparisonCopyWith<_UserPeriodComparison> get copyWith => __$UserPeriodComparisonCopyWithImpl<_UserPeriodComparison>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPeriodComparison&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.hoursThisPeriod, hoursThisPeriod) || other.hoursThisPeriod == hoursThisPeriod)&&(identical(other.hoursLastPeriod, hoursLastPeriod) || other.hoursLastPeriod == hoursLastPeriod)&&(identical(other.changePercent, changePercent) || other.changePercent == changePercent));
}


@override
int get hashCode => Object.hash(runtimeType,userName,hoursThisPeriod,hoursLastPeriod,changePercent);

@override
String toString() {
  return 'UserPeriodComparison(userName: $userName, hoursThisPeriod: $hoursThisPeriod, hoursLastPeriod: $hoursLastPeriod, changePercent: $changePercent)';
}


}

/// @nodoc
abstract mixin class _$UserPeriodComparisonCopyWith<$Res> implements $UserPeriodComparisonCopyWith<$Res> {
  factory _$UserPeriodComparisonCopyWith(_UserPeriodComparison value, $Res Function(_UserPeriodComparison) _then) = __$UserPeriodComparisonCopyWithImpl;
@override @useResult
$Res call({
 String userName, double hoursThisPeriod, double hoursLastPeriod, double changePercent
});




}
/// @nodoc
class __$UserPeriodComparisonCopyWithImpl<$Res>
    implements _$UserPeriodComparisonCopyWith<$Res> {
  __$UserPeriodComparisonCopyWithImpl(this._self, this._then);

  final _UserPeriodComparison _self;
  final $Res Function(_UserPeriodComparison) _then;

/// Create a copy of UserPeriodComparison
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userName = null,Object? hoursThisPeriod = null,Object? hoursLastPeriod = null,Object? changePercent = null,}) {
  return _then(_UserPeriodComparison(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,hoursThisPeriod: null == hoursThisPeriod ? _self.hoursThisPeriod : hoursThisPeriod // ignore: cast_nullable_to_non_nullable
as double,hoursLastPeriod: null == hoursLastPeriod ? _self.hoursLastPeriod : hoursLastPeriod // ignore: cast_nullable_to_non_nullable
as double,changePercent: null == changePercent ? _self.changePercent : changePercent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$AdminDashboardState {

 DatePeriod get selectedPeriod; List<TimeEntry> get allEntries; bool get isLoading;
/// Create a copy of AdminDashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminDashboardStateCopyWith<AdminDashboardState> get copyWith => _$AdminDashboardStateCopyWithImpl<AdminDashboardState>(this as AdminDashboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminDashboardState&&(identical(other.selectedPeriod, selectedPeriod) || other.selectedPeriod == selectedPeriod)&&const DeepCollectionEquality().equals(other.allEntries, allEntries)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,selectedPeriod,const DeepCollectionEquality().hash(allEntries),isLoading);

@override
String toString() {
  return 'AdminDashboardState(selectedPeriod: $selectedPeriod, allEntries: $allEntries, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $AdminDashboardStateCopyWith<$Res>  {
  factory $AdminDashboardStateCopyWith(AdminDashboardState value, $Res Function(AdminDashboardState) _then) = _$AdminDashboardStateCopyWithImpl;
@useResult
$Res call({
 DatePeriod selectedPeriod, List<TimeEntry> allEntries, bool isLoading
});


$DatePeriodCopyWith<$Res> get selectedPeriod;

}
/// @nodoc
class _$AdminDashboardStateCopyWithImpl<$Res>
    implements $AdminDashboardStateCopyWith<$Res> {
  _$AdminDashboardStateCopyWithImpl(this._self, this._then);

  final AdminDashboardState _self;
  final $Res Function(AdminDashboardState) _then;

/// Create a copy of AdminDashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedPeriod = null,Object? allEntries = null,Object? isLoading = null,}) {
  return _then(_self.copyWith(
selectedPeriod: null == selectedPeriod ? _self.selectedPeriod : selectedPeriod // ignore: cast_nullable_to_non_nullable
as DatePeriod,allEntries: null == allEntries ? _self.allEntries : allEntries // ignore: cast_nullable_to_non_nullable
as List<TimeEntry>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of AdminDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DatePeriodCopyWith<$Res> get selectedPeriod {
  
  return $DatePeriodCopyWith<$Res>(_self.selectedPeriod, (value) {
    return _then(_self.copyWith(selectedPeriod: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminDashboardState].
extension AdminDashboardStatePatterns on AdminDashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminDashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminDashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminDashboardState value)  $default,){
final _that = this;
switch (_that) {
case _AdminDashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminDashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _AdminDashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DatePeriod selectedPeriod,  List<TimeEntry> allEntries,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminDashboardState() when $default != null:
return $default(_that.selectedPeriod,_that.allEntries,_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DatePeriod selectedPeriod,  List<TimeEntry> allEntries,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _AdminDashboardState():
return $default(_that.selectedPeriod,_that.allEntries,_that.isLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DatePeriod selectedPeriod,  List<TimeEntry> allEntries,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _AdminDashboardState() when $default != null:
return $default(_that.selectedPeriod,_that.allEntries,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _AdminDashboardState extends AdminDashboardState {
  const _AdminDashboardState({required this.selectedPeriod, final  List<TimeEntry> allEntries = const [], this.isLoading = false}): _allEntries = allEntries,super._();
  

@override final  DatePeriod selectedPeriod;
 final  List<TimeEntry> _allEntries;
@override@JsonKey() List<TimeEntry> get allEntries {
  if (_allEntries is EqualUnmodifiableListView) return _allEntries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allEntries);
}

@override@JsonKey() final  bool isLoading;

/// Create a copy of AdminDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminDashboardStateCopyWith<_AdminDashboardState> get copyWith => __$AdminDashboardStateCopyWithImpl<_AdminDashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminDashboardState&&(identical(other.selectedPeriod, selectedPeriod) || other.selectedPeriod == selectedPeriod)&&const DeepCollectionEquality().equals(other._allEntries, _allEntries)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,selectedPeriod,const DeepCollectionEquality().hash(_allEntries),isLoading);

@override
String toString() {
  return 'AdminDashboardState(selectedPeriod: $selectedPeriod, allEntries: $allEntries, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$AdminDashboardStateCopyWith<$Res> implements $AdminDashboardStateCopyWith<$Res> {
  factory _$AdminDashboardStateCopyWith(_AdminDashboardState value, $Res Function(_AdminDashboardState) _then) = __$AdminDashboardStateCopyWithImpl;
@override @useResult
$Res call({
 DatePeriod selectedPeriod, List<TimeEntry> allEntries, bool isLoading
});


@override $DatePeriodCopyWith<$Res> get selectedPeriod;

}
/// @nodoc
class __$AdminDashboardStateCopyWithImpl<$Res>
    implements _$AdminDashboardStateCopyWith<$Res> {
  __$AdminDashboardStateCopyWithImpl(this._self, this._then);

  final _AdminDashboardState _self;
  final $Res Function(_AdminDashboardState) _then;

/// Create a copy of AdminDashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedPeriod = null,Object? allEntries = null,Object? isLoading = null,}) {
  return _then(_AdminDashboardState(
selectedPeriod: null == selectedPeriod ? _self.selectedPeriod : selectedPeriod // ignore: cast_nullable_to_non_nullable
as DatePeriod,allEntries: null == allEntries ? _self._allEntries : allEntries // ignore: cast_nullable_to_non_nullable
as List<TimeEntry>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AdminDashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DatePeriodCopyWith<$Res> get selectedPeriod {
  
  return $DatePeriodCopyWith<$Res>(_self.selectedPeriod, (value) {
    return _then(_self.copyWith(selectedPeriod: value));
  });
}
}

// dart format on
