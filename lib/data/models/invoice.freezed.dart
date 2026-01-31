// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Invoice {

 String? get id; String get userId; String get userName;@TimestampConverter() DateTime get periodStart;@TimestampConverter() DateTime get periodEnd; double get totalHours; double get hourlyRate; double get totalAmount; Currency get currency; InvoiceStatus get status; String get invoiceNumber;@NullableTimestampConverter() DateTime? get dueDate; String? get pdfStoragePath; String? get pdfDownloadUrl; List<String> get entryIds;@ServerTimestampConverter() DateTime? get createdAt; String get createdBy; String? get notes;
/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceCopyWith<Invoice> get copyWith => _$InvoiceCopyWithImpl<Invoice>(this as Invoice, _$identity);

  /// Serializes this Invoice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Invoice&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.totalHours, totalHours) || other.totalHours == totalHours)&&(identical(other.hourlyRate, hourlyRate) || other.hourlyRate == hourlyRate)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.pdfStoragePath, pdfStoragePath) || other.pdfStoragePath == pdfStoragePath)&&(identical(other.pdfDownloadUrl, pdfDownloadUrl) || other.pdfDownloadUrl == pdfDownloadUrl)&&const DeepCollectionEquality().equals(other.entryIds, entryIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,periodStart,periodEnd,totalHours,hourlyRate,totalAmount,currency,status,invoiceNumber,dueDate,pdfStoragePath,pdfDownloadUrl,const DeepCollectionEquality().hash(entryIds),createdAt,createdBy,notes);

@override
String toString() {
  return 'Invoice(id: $id, userId: $userId, userName: $userName, periodStart: $periodStart, periodEnd: $periodEnd, totalHours: $totalHours, hourlyRate: $hourlyRate, totalAmount: $totalAmount, currency: $currency, status: $status, invoiceNumber: $invoiceNumber, dueDate: $dueDate, pdfStoragePath: $pdfStoragePath, pdfDownloadUrl: $pdfDownloadUrl, entryIds: $entryIds, createdAt: $createdAt, createdBy: $createdBy, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $InvoiceCopyWith<$Res>  {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) _then) = _$InvoiceCopyWithImpl;
@useResult
$Res call({
 String? id, String userId, String userName,@TimestampConverter() DateTime periodStart,@TimestampConverter() DateTime periodEnd, double totalHours, double hourlyRate, double totalAmount, Currency currency, InvoiceStatus status, String invoiceNumber,@NullableTimestampConverter() DateTime? dueDate, String? pdfStoragePath, String? pdfDownloadUrl, List<String> entryIds,@ServerTimestampConverter() DateTime? createdAt, String createdBy, String? notes
});




}
/// @nodoc
class _$InvoiceCopyWithImpl<$Res>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._self, this._then);

  final Invoice _self;
  final $Res Function(Invoice) _then;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = null,Object? userName = null,Object? periodStart = null,Object? periodEnd = null,Object? totalHours = null,Object? hourlyRate = null,Object? totalAmount = null,Object? currency = null,Object? status = null,Object? invoiceNumber = null,Object? dueDate = freezed,Object? pdfStoragePath = freezed,Object? pdfDownloadUrl = freezed,Object? entryIds = null,Object? createdAt = freezed,Object? createdBy = null,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,totalHours: null == totalHours ? _self.totalHours : totalHours // ignore: cast_nullable_to_non_nullable
as double,hourlyRate: null == hourlyRate ? _self.hourlyRate : hourlyRate // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InvoiceStatus,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,pdfStoragePath: freezed == pdfStoragePath ? _self.pdfStoragePath : pdfStoragePath // ignore: cast_nullable_to_non_nullable
as String?,pdfDownloadUrl: freezed == pdfDownloadUrl ? _self.pdfDownloadUrl : pdfDownloadUrl // ignore: cast_nullable_to_non_nullable
as String?,entryIds: null == entryIds ? _self.entryIds : entryIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Invoice].
extension InvoicePatterns on Invoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Invoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Invoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Invoice value)  $default,){
final _that = this;
switch (_that) {
case _Invoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Invoice value)?  $default,){
final _that = this;
switch (_that) {
case _Invoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String userId,  String userName, @TimestampConverter()  DateTime periodStart, @TimestampConverter()  DateTime periodEnd,  double totalHours,  double hourlyRate,  double totalAmount,  Currency currency,  InvoiceStatus status,  String invoiceNumber, @NullableTimestampConverter()  DateTime? dueDate,  String? pdfStoragePath,  String? pdfDownloadUrl,  List<String> entryIds, @ServerTimestampConverter()  DateTime? createdAt,  String createdBy,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.periodStart,_that.periodEnd,_that.totalHours,_that.hourlyRate,_that.totalAmount,_that.currency,_that.status,_that.invoiceNumber,_that.dueDate,_that.pdfStoragePath,_that.pdfDownloadUrl,_that.entryIds,_that.createdAt,_that.createdBy,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String userId,  String userName, @TimestampConverter()  DateTime periodStart, @TimestampConverter()  DateTime periodEnd,  double totalHours,  double hourlyRate,  double totalAmount,  Currency currency,  InvoiceStatus status,  String invoiceNumber, @NullableTimestampConverter()  DateTime? dueDate,  String? pdfStoragePath,  String? pdfDownloadUrl,  List<String> entryIds, @ServerTimestampConverter()  DateTime? createdAt,  String createdBy,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _Invoice():
return $default(_that.id,_that.userId,_that.userName,_that.periodStart,_that.periodEnd,_that.totalHours,_that.hourlyRate,_that.totalAmount,_that.currency,_that.status,_that.invoiceNumber,_that.dueDate,_that.pdfStoragePath,_that.pdfDownloadUrl,_that.entryIds,_that.createdAt,_that.createdBy,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String userId,  String userName, @TimestampConverter()  DateTime periodStart, @TimestampConverter()  DateTime periodEnd,  double totalHours,  double hourlyRate,  double totalAmount,  Currency currency,  InvoiceStatus status,  String invoiceNumber, @NullableTimestampConverter()  DateTime? dueDate,  String? pdfStoragePath,  String? pdfDownloadUrl,  List<String> entryIds, @ServerTimestampConverter()  DateTime? createdAt,  String createdBy,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.periodStart,_that.periodEnd,_that.totalHours,_that.hourlyRate,_that.totalAmount,_that.currency,_that.status,_that.invoiceNumber,_that.dueDate,_that.pdfStoragePath,_that.pdfDownloadUrl,_that.entryIds,_that.createdAt,_that.createdBy,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Invoice extends Invoice {
  const _Invoice({this.id, required this.userId, required this.userName, @TimestampConverter() required this.periodStart, @TimestampConverter() required this.periodEnd, required this.totalHours, required this.hourlyRate, required this.totalAmount, this.currency = Currency.lei, this.status = InvoiceStatus.draft, required this.invoiceNumber, @NullableTimestampConverter() this.dueDate, this.pdfStoragePath, this.pdfDownloadUrl, final  List<String> entryIds = const [], @ServerTimestampConverter() this.createdAt, required this.createdBy, this.notes}): _entryIds = entryIds,super._();
  factory _Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);

@override final  String? id;
@override final  String userId;
@override final  String userName;
@override@TimestampConverter() final  DateTime periodStart;
@override@TimestampConverter() final  DateTime periodEnd;
@override final  double totalHours;
@override final  double hourlyRate;
@override final  double totalAmount;
@override@JsonKey() final  Currency currency;
@override@JsonKey() final  InvoiceStatus status;
@override final  String invoiceNumber;
@override@NullableTimestampConverter() final  DateTime? dueDate;
@override final  String? pdfStoragePath;
@override final  String? pdfDownloadUrl;
 final  List<String> _entryIds;
@override@JsonKey() List<String> get entryIds {
  if (_entryIds is EqualUnmodifiableListView) return _entryIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entryIds);
}

@override@ServerTimestampConverter() final  DateTime? createdAt;
@override final  String createdBy;
@override final  String? notes;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceCopyWith<_Invoice> get copyWith => __$InvoiceCopyWithImpl<_Invoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Invoice&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.totalHours, totalHours) || other.totalHours == totalHours)&&(identical(other.hourlyRate, hourlyRate) || other.hourlyRate == hourlyRate)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.pdfStoragePath, pdfStoragePath) || other.pdfStoragePath == pdfStoragePath)&&(identical(other.pdfDownloadUrl, pdfDownloadUrl) || other.pdfDownloadUrl == pdfDownloadUrl)&&const DeepCollectionEquality().equals(other._entryIds, _entryIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,periodStart,periodEnd,totalHours,hourlyRate,totalAmount,currency,status,invoiceNumber,dueDate,pdfStoragePath,pdfDownloadUrl,const DeepCollectionEquality().hash(_entryIds),createdAt,createdBy,notes);

@override
String toString() {
  return 'Invoice(id: $id, userId: $userId, userName: $userName, periodStart: $periodStart, periodEnd: $periodEnd, totalHours: $totalHours, hourlyRate: $hourlyRate, totalAmount: $totalAmount, currency: $currency, status: $status, invoiceNumber: $invoiceNumber, dueDate: $dueDate, pdfStoragePath: $pdfStoragePath, pdfDownloadUrl: $pdfDownloadUrl, entryIds: $entryIds, createdAt: $createdAt, createdBy: $createdBy, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$InvoiceCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$InvoiceCopyWith(_Invoice value, $Res Function(_Invoice) _then) = __$InvoiceCopyWithImpl;
@override @useResult
$Res call({
 String? id, String userId, String userName,@TimestampConverter() DateTime periodStart,@TimestampConverter() DateTime periodEnd, double totalHours, double hourlyRate, double totalAmount, Currency currency, InvoiceStatus status, String invoiceNumber,@NullableTimestampConverter() DateTime? dueDate, String? pdfStoragePath, String? pdfDownloadUrl, List<String> entryIds,@ServerTimestampConverter() DateTime? createdAt, String createdBy, String? notes
});




}
/// @nodoc
class __$InvoiceCopyWithImpl<$Res>
    implements _$InvoiceCopyWith<$Res> {
  __$InvoiceCopyWithImpl(this._self, this._then);

  final _Invoice _self;
  final $Res Function(_Invoice) _then;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = null,Object? userName = null,Object? periodStart = null,Object? periodEnd = null,Object? totalHours = null,Object? hourlyRate = null,Object? totalAmount = null,Object? currency = null,Object? status = null,Object? invoiceNumber = null,Object? dueDate = freezed,Object? pdfStoragePath = freezed,Object? pdfDownloadUrl = freezed,Object? entryIds = null,Object? createdAt = freezed,Object? createdBy = null,Object? notes = freezed,}) {
  return _then(_Invoice(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,totalHours: null == totalHours ? _self.totalHours : totalHours // ignore: cast_nullable_to_non_nullable
as double,hourlyRate: null == hourlyRate ? _self.hourlyRate : hourlyRate // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InvoiceStatus,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,pdfStoragePath: freezed == pdfStoragePath ? _self.pdfStoragePath : pdfStoragePath // ignore: cast_nullable_to_non_nullable
as String?,pdfDownloadUrl: freezed == pdfDownloadUrl ? _self.pdfDownloadUrl : pdfDownloadUrl // ignore: cast_nullable_to_non_nullable
as String?,entryIds: null == entryIds ? _self._entryIds : entryIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
