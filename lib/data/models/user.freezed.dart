// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationPrefs {

 bool get dailyReminder; bool get weeklyReport; bool get invoiceAlerts;
/// Create a copy of NotificationPrefs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPrefsCopyWith<NotificationPrefs> get copyWith => _$NotificationPrefsCopyWithImpl<NotificationPrefs>(this as NotificationPrefs, _$identity);

  /// Serializes this NotificationPrefs to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPrefs&&(identical(other.dailyReminder, dailyReminder) || other.dailyReminder == dailyReminder)&&(identical(other.weeklyReport, weeklyReport) || other.weeklyReport == weeklyReport)&&(identical(other.invoiceAlerts, invoiceAlerts) || other.invoiceAlerts == invoiceAlerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dailyReminder,weeklyReport,invoiceAlerts);

@override
String toString() {
  return 'NotificationPrefs(dailyReminder: $dailyReminder, weeklyReport: $weeklyReport, invoiceAlerts: $invoiceAlerts)';
}


}

/// @nodoc
abstract mixin class $NotificationPrefsCopyWith<$Res>  {
  factory $NotificationPrefsCopyWith(NotificationPrefs value, $Res Function(NotificationPrefs) _then) = _$NotificationPrefsCopyWithImpl;
@useResult
$Res call({
 bool dailyReminder, bool weeklyReport, bool invoiceAlerts
});




}
/// @nodoc
class _$NotificationPrefsCopyWithImpl<$Res>
    implements $NotificationPrefsCopyWith<$Res> {
  _$NotificationPrefsCopyWithImpl(this._self, this._then);

  final NotificationPrefs _self;
  final $Res Function(NotificationPrefs) _then;

/// Create a copy of NotificationPrefs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dailyReminder = null,Object? weeklyReport = null,Object? invoiceAlerts = null,}) {
  return _then(_self.copyWith(
dailyReminder: null == dailyReminder ? _self.dailyReminder : dailyReminder // ignore: cast_nullable_to_non_nullable
as bool,weeklyReport: null == weeklyReport ? _self.weeklyReport : weeklyReport // ignore: cast_nullable_to_non_nullable
as bool,invoiceAlerts: null == invoiceAlerts ? _self.invoiceAlerts : invoiceAlerts // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPrefs].
extension NotificationPrefsPatterns on NotificationPrefs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPrefs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPrefs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPrefs value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPrefs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPrefs value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPrefs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool dailyReminder,  bool weeklyReport,  bool invoiceAlerts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPrefs() when $default != null:
return $default(_that.dailyReminder,_that.weeklyReport,_that.invoiceAlerts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool dailyReminder,  bool weeklyReport,  bool invoiceAlerts)  $default,) {final _that = this;
switch (_that) {
case _NotificationPrefs():
return $default(_that.dailyReminder,_that.weeklyReport,_that.invoiceAlerts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool dailyReminder,  bool weeklyReport,  bool invoiceAlerts)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPrefs() when $default != null:
return $default(_that.dailyReminder,_that.weeklyReport,_that.invoiceAlerts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPrefs implements NotificationPrefs {
  const _NotificationPrefs({this.dailyReminder = true, this.weeklyReport = true, this.invoiceAlerts = true});
  factory _NotificationPrefs.fromJson(Map<String, dynamic> json) => _$NotificationPrefsFromJson(json);

@override@JsonKey() final  bool dailyReminder;
@override@JsonKey() final  bool weeklyReport;
@override@JsonKey() final  bool invoiceAlerts;

/// Create a copy of NotificationPrefs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPrefsCopyWith<_NotificationPrefs> get copyWith => __$NotificationPrefsCopyWithImpl<_NotificationPrefs>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPrefsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPrefs&&(identical(other.dailyReminder, dailyReminder) || other.dailyReminder == dailyReminder)&&(identical(other.weeklyReport, weeklyReport) || other.weeklyReport == weeklyReport)&&(identical(other.invoiceAlerts, invoiceAlerts) || other.invoiceAlerts == invoiceAlerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dailyReminder,weeklyReport,invoiceAlerts);

@override
String toString() {
  return 'NotificationPrefs(dailyReminder: $dailyReminder, weeklyReport: $weeklyReport, invoiceAlerts: $invoiceAlerts)';
}


}

/// @nodoc
abstract mixin class _$NotificationPrefsCopyWith<$Res> implements $NotificationPrefsCopyWith<$Res> {
  factory _$NotificationPrefsCopyWith(_NotificationPrefs value, $Res Function(_NotificationPrefs) _then) = __$NotificationPrefsCopyWithImpl;
@override @useResult
$Res call({
 bool dailyReminder, bool weeklyReport, bool invoiceAlerts
});




}
/// @nodoc
class __$NotificationPrefsCopyWithImpl<$Res>
    implements _$NotificationPrefsCopyWith<$Res> {
  __$NotificationPrefsCopyWithImpl(this._self, this._then);

  final _NotificationPrefs _self;
  final $Res Function(_NotificationPrefs) _then;

/// Create a copy of NotificationPrefs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dailyReminder = null,Object? weeklyReport = null,Object? invoiceAlerts = null,}) {
  return _then(_NotificationPrefs(
dailyReminder: null == dailyReminder ? _self.dailyReminder : dailyReminder // ignore: cast_nullable_to_non_nullable
as bool,weeklyReport: null == weeklyReport ? _self.weeklyReport : weeklyReport // ignore: cast_nullable_to_non_nullable
as bool,invoiceAlerts: null == invoiceAlerts ? _self.invoiceAlerts : invoiceAlerts // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$User {

 String? get id; String get email; String? get displayName; Role get role; double? get salaryAmount; SalaryType get salaryType; Currency get currency; String? get fcmToken; NotificationPrefs? get notificationPrefs; bool get banned;@ServerTimestampConverter() DateTime? get bannedAt; String? get bannedReason;@ServerTimestampConverter() DateTime? get createdAt;@ServerTimestampConverter() DateTime? get updatedAt;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.role, role) || other.role == role)&&(identical(other.salaryAmount, salaryAmount) || other.salaryAmount == salaryAmount)&&(identical(other.salaryType, salaryType) || other.salaryType == salaryType)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.notificationPrefs, notificationPrefs) || other.notificationPrefs == notificationPrefs)&&(identical(other.banned, banned) || other.banned == banned)&&(identical(other.bannedAt, bannedAt) || other.bannedAt == bannedAt)&&(identical(other.bannedReason, bannedReason) || other.bannedReason == bannedReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,displayName,role,salaryAmount,salaryType,currency,fcmToken,notificationPrefs,banned,bannedAt,bannedReason,createdAt,updatedAt);

@override
String toString() {
  return 'User(id: $id, email: $email, displayName: $displayName, role: $role, salaryAmount: $salaryAmount, salaryType: $salaryType, currency: $currency, fcmToken: $fcmToken, notificationPrefs: $notificationPrefs, banned: $banned, bannedAt: $bannedAt, bannedReason: $bannedReason, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String? id, String email, String? displayName, Role role, double? salaryAmount, SalaryType salaryType, Currency currency, String? fcmToken, NotificationPrefs? notificationPrefs, bool banned,@ServerTimestampConverter() DateTime? bannedAt, String? bannedReason,@ServerTimestampConverter() DateTime? createdAt,@ServerTimestampConverter() DateTime? updatedAt
});


$NotificationPrefsCopyWith<$Res>? get notificationPrefs;

}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? email = null,Object? displayName = freezed,Object? role = null,Object? salaryAmount = freezed,Object? salaryType = null,Object? currency = null,Object? fcmToken = freezed,Object? notificationPrefs = freezed,Object? banned = null,Object? bannedAt = freezed,Object? bannedReason = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,salaryAmount: freezed == salaryAmount ? _self.salaryAmount : salaryAmount // ignore: cast_nullable_to_non_nullable
as double?,salaryType: null == salaryType ? _self.salaryType : salaryType // ignore: cast_nullable_to_non_nullable
as SalaryType,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,notificationPrefs: freezed == notificationPrefs ? _self.notificationPrefs : notificationPrefs // ignore: cast_nullable_to_non_nullable
as NotificationPrefs?,banned: null == banned ? _self.banned : banned // ignore: cast_nullable_to_non_nullable
as bool,bannedAt: freezed == bannedAt ? _self.bannedAt : bannedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,bannedReason: freezed == bannedReason ? _self.bannedReason : bannedReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationPrefsCopyWith<$Res>? get notificationPrefs {
    if (_self.notificationPrefs == null) {
    return null;
  }

  return $NotificationPrefsCopyWith<$Res>(_self.notificationPrefs!, (value) {
    return _then(_self.copyWith(notificationPrefs: value));
  });
}
}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String email,  String? displayName,  Role role,  double? salaryAmount,  SalaryType salaryType,  Currency currency,  String? fcmToken,  NotificationPrefs? notificationPrefs,  bool banned, @ServerTimestampConverter()  DateTime? bannedAt,  String? bannedReason, @ServerTimestampConverter()  DateTime? createdAt, @ServerTimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.role,_that.salaryAmount,_that.salaryType,_that.currency,_that.fcmToken,_that.notificationPrefs,_that.banned,_that.bannedAt,_that.bannedReason,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String email,  String? displayName,  Role role,  double? salaryAmount,  SalaryType salaryType,  Currency currency,  String? fcmToken,  NotificationPrefs? notificationPrefs,  bool banned, @ServerTimestampConverter()  DateTime? bannedAt,  String? bannedReason, @ServerTimestampConverter()  DateTime? createdAt, @ServerTimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.email,_that.displayName,_that.role,_that.salaryAmount,_that.salaryType,_that.currency,_that.fcmToken,_that.notificationPrefs,_that.banned,_that.bannedAt,_that.bannedReason,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String email,  String? displayName,  Role role,  double? salaryAmount,  SalaryType salaryType,  Currency currency,  String? fcmToken,  NotificationPrefs? notificationPrefs,  bool banned, @ServerTimestampConverter()  DateTime? bannedAt,  String? bannedReason, @ServerTimestampConverter()  DateTime? createdAt, @ServerTimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.email,_that.displayName,_that.role,_that.salaryAmount,_that.salaryType,_that.currency,_that.fcmToken,_that.notificationPrefs,_that.banned,_that.bannedAt,_that.bannedReason,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User extends User {
  const _User({this.id, required this.email, this.displayName, this.role = Role.user, this.salaryAmount, this.salaryType = SalaryType.hourly, this.currency = Currency.lei, this.fcmToken, this.notificationPrefs, this.banned = false, @ServerTimestampConverter() this.bannedAt, this.bannedReason, @ServerTimestampConverter() this.createdAt, @ServerTimestampConverter() this.updatedAt}): super._();
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  String? id;
@override final  String email;
@override final  String? displayName;
@override@JsonKey() final  Role role;
@override final  double? salaryAmount;
@override@JsonKey() final  SalaryType salaryType;
@override@JsonKey() final  Currency currency;
@override final  String? fcmToken;
@override final  NotificationPrefs? notificationPrefs;
@override@JsonKey() final  bool banned;
@override@ServerTimestampConverter() final  DateTime? bannedAt;
@override final  String? bannedReason;
@override@ServerTimestampConverter() final  DateTime? createdAt;
@override@ServerTimestampConverter() final  DateTime? updatedAt;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.role, role) || other.role == role)&&(identical(other.salaryAmount, salaryAmount) || other.salaryAmount == salaryAmount)&&(identical(other.salaryType, salaryType) || other.salaryType == salaryType)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.notificationPrefs, notificationPrefs) || other.notificationPrefs == notificationPrefs)&&(identical(other.banned, banned) || other.banned == banned)&&(identical(other.bannedAt, bannedAt) || other.bannedAt == bannedAt)&&(identical(other.bannedReason, bannedReason) || other.bannedReason == bannedReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,displayName,role,salaryAmount,salaryType,currency,fcmToken,notificationPrefs,banned,bannedAt,bannedReason,createdAt,updatedAt);

@override
String toString() {
  return 'User(id: $id, email: $email, displayName: $displayName, role: $role, salaryAmount: $salaryAmount, salaryType: $salaryType, currency: $currency, fcmToken: $fcmToken, notificationPrefs: $notificationPrefs, banned: $banned, bannedAt: $bannedAt, bannedReason: $bannedReason, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String? id, String email, String? displayName, Role role, double? salaryAmount, SalaryType salaryType, Currency currency, String? fcmToken, NotificationPrefs? notificationPrefs, bool banned,@ServerTimestampConverter() DateTime? bannedAt, String? bannedReason,@ServerTimestampConverter() DateTime? createdAt,@ServerTimestampConverter() DateTime? updatedAt
});


@override $NotificationPrefsCopyWith<$Res>? get notificationPrefs;

}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? email = null,Object? displayName = freezed,Object? role = null,Object? salaryAmount = freezed,Object? salaryType = null,Object? currency = null,Object? fcmToken = freezed,Object? notificationPrefs = freezed,Object? banned = null,Object? bannedAt = freezed,Object? bannedReason = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_User(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as Role,salaryAmount: freezed == salaryAmount ? _self.salaryAmount : salaryAmount // ignore: cast_nullable_to_non_nullable
as double?,salaryType: null == salaryType ? _self.salaryType : salaryType // ignore: cast_nullable_to_non_nullable
as SalaryType,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,notificationPrefs: freezed == notificationPrefs ? _self.notificationPrefs : notificationPrefs // ignore: cast_nullable_to_non_nullable
as NotificationPrefs?,banned: null == banned ? _self.banned : banned // ignore: cast_nullable_to_non_nullable
as bool,bannedAt: freezed == bannedAt ? _self.bannedAt : bannedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,bannedReason: freezed == bannedReason ? _self.bannedReason : bannedReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationPrefsCopyWith<$Res>? get notificationPrefs {
    if (_self.notificationPrefs == null) {
    return null;
  }

  return $NotificationPrefsCopyWith<$Res>(_self.notificationPrefs!, (value) {
    return _then(_self.copyWith(notificationPrefs: value));
  });
}
}

// dart format on
