// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InvoiceEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InvoiceEvent()';
}


}

/// @nodoc
class $InvoiceEventCopyWith<$Res>  {
$InvoiceEventCopyWith(InvoiceEvent _, $Res Function(InvoiceEvent) __);
}


/// Adds pattern-matching-related methods to [InvoiceEvent].
extension InvoiceEventPatterns on InvoiceEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadInvoices value)?  loadInvoices,TResult Function( CreateInvoice value)?  createInvoice,TResult Function( UpdateInvoiceStatus value)?  updateStatus,TResult Function( GenerateInvoicePdf value)?  generatePdf,TResult Function( DeleteInvoice value)?  deleteInvoice,TResult Function( SendInvoice value)?  sendInvoice,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadInvoices() when loadInvoices != null:
return loadInvoices(_that);case CreateInvoice() when createInvoice != null:
return createInvoice(_that);case UpdateInvoiceStatus() when updateStatus != null:
return updateStatus(_that);case GenerateInvoicePdf() when generatePdf != null:
return generatePdf(_that);case DeleteInvoice() when deleteInvoice != null:
return deleteInvoice(_that);case SendInvoice() when sendInvoice != null:
return sendInvoice(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadInvoices value)  loadInvoices,required TResult Function( CreateInvoice value)  createInvoice,required TResult Function( UpdateInvoiceStatus value)  updateStatus,required TResult Function( GenerateInvoicePdf value)  generatePdf,required TResult Function( DeleteInvoice value)  deleteInvoice,required TResult Function( SendInvoice value)  sendInvoice,}){
final _that = this;
switch (_that) {
case LoadInvoices():
return loadInvoices(_that);case CreateInvoice():
return createInvoice(_that);case UpdateInvoiceStatus():
return updateStatus(_that);case GenerateInvoicePdf():
return generatePdf(_that);case DeleteInvoice():
return deleteInvoice(_that);case SendInvoice():
return sendInvoice(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadInvoices value)?  loadInvoices,TResult? Function( CreateInvoice value)?  createInvoice,TResult? Function( UpdateInvoiceStatus value)?  updateStatus,TResult? Function( GenerateInvoicePdf value)?  generatePdf,TResult? Function( DeleteInvoice value)?  deleteInvoice,TResult? Function( SendInvoice value)?  sendInvoice,}){
final _that = this;
switch (_that) {
case LoadInvoices() when loadInvoices != null:
return loadInvoices(_that);case CreateInvoice() when createInvoice != null:
return createInvoice(_that);case UpdateInvoiceStatus() when updateStatus != null:
return updateStatus(_that);case GenerateInvoicePdf() when generatePdf != null:
return generatePdf(_that);case DeleteInvoice() when deleteInvoice != null:
return deleteInvoice(_that);case SendInvoice() when sendInvoice != null:
return sendInvoice(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? userId,  bool isAdmin)?  loadInvoices,TResult Function( PeriodSummary summary,  String createdBy,  DateTime? dueDate,  String? notes)?  createInvoice,TResult Function( String invoiceId,  InvoiceStatus status)?  updateStatus,TResult Function( Invoice invoice)?  generatePdf,TResult Function( String invoiceId)?  deleteInvoice,TResult Function( Invoice invoice)?  sendInvoice,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadInvoices() when loadInvoices != null:
return loadInvoices(_that.userId,_that.isAdmin);case CreateInvoice() when createInvoice != null:
return createInvoice(_that.summary,_that.createdBy,_that.dueDate,_that.notes);case UpdateInvoiceStatus() when updateStatus != null:
return updateStatus(_that.invoiceId,_that.status);case GenerateInvoicePdf() when generatePdf != null:
return generatePdf(_that.invoice);case DeleteInvoice() when deleteInvoice != null:
return deleteInvoice(_that.invoiceId);case SendInvoice() when sendInvoice != null:
return sendInvoice(_that.invoice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? userId,  bool isAdmin)  loadInvoices,required TResult Function( PeriodSummary summary,  String createdBy,  DateTime? dueDate,  String? notes)  createInvoice,required TResult Function( String invoiceId,  InvoiceStatus status)  updateStatus,required TResult Function( Invoice invoice)  generatePdf,required TResult Function( String invoiceId)  deleteInvoice,required TResult Function( Invoice invoice)  sendInvoice,}) {final _that = this;
switch (_that) {
case LoadInvoices():
return loadInvoices(_that.userId,_that.isAdmin);case CreateInvoice():
return createInvoice(_that.summary,_that.createdBy,_that.dueDate,_that.notes);case UpdateInvoiceStatus():
return updateStatus(_that.invoiceId,_that.status);case GenerateInvoicePdf():
return generatePdf(_that.invoice);case DeleteInvoice():
return deleteInvoice(_that.invoiceId);case SendInvoice():
return sendInvoice(_that.invoice);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? userId,  bool isAdmin)?  loadInvoices,TResult? Function( PeriodSummary summary,  String createdBy,  DateTime? dueDate,  String? notes)?  createInvoice,TResult? Function( String invoiceId,  InvoiceStatus status)?  updateStatus,TResult? Function( Invoice invoice)?  generatePdf,TResult? Function( String invoiceId)?  deleteInvoice,TResult? Function( Invoice invoice)?  sendInvoice,}) {final _that = this;
switch (_that) {
case LoadInvoices() when loadInvoices != null:
return loadInvoices(_that.userId,_that.isAdmin);case CreateInvoice() when createInvoice != null:
return createInvoice(_that.summary,_that.createdBy,_that.dueDate,_that.notes);case UpdateInvoiceStatus() when updateStatus != null:
return updateStatus(_that.invoiceId,_that.status);case GenerateInvoicePdf() when generatePdf != null:
return generatePdf(_that.invoice);case DeleteInvoice() when deleteInvoice != null:
return deleteInvoice(_that.invoiceId);case SendInvoice() when sendInvoice != null:
return sendInvoice(_that.invoice);case _:
  return null;

}
}

}

/// @nodoc


class LoadInvoices implements InvoiceEvent {
  const LoadInvoices({this.userId, this.isAdmin = false});
  

 final  String? userId;
@JsonKey() final  bool isAdmin;

/// Create a copy of InvoiceEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadInvoicesCopyWith<LoadInvoices> get copyWith => _$LoadInvoicesCopyWithImpl<LoadInvoices>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadInvoices&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin));
}


@override
int get hashCode => Object.hash(runtimeType,userId,isAdmin);

@override
String toString() {
  return 'InvoiceEvent.loadInvoices(userId: $userId, isAdmin: $isAdmin)';
}


}

/// @nodoc
abstract mixin class $LoadInvoicesCopyWith<$Res> implements $InvoiceEventCopyWith<$Res> {
  factory $LoadInvoicesCopyWith(LoadInvoices value, $Res Function(LoadInvoices) _then) = _$LoadInvoicesCopyWithImpl;
@useResult
$Res call({
 String? userId, bool isAdmin
});




}
/// @nodoc
class _$LoadInvoicesCopyWithImpl<$Res>
    implements $LoadInvoicesCopyWith<$Res> {
  _$LoadInvoicesCopyWithImpl(this._self, this._then);

  final LoadInvoices _self;
  final $Res Function(LoadInvoices) _then;

/// Create a copy of InvoiceEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = freezed,Object? isAdmin = null,}) {
  return _then(LoadInvoices(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class CreateInvoice implements InvoiceEvent {
  const CreateInvoice({required this.summary, required this.createdBy, this.dueDate, this.notes});
  

 final  PeriodSummary summary;
 final  String createdBy;
 final  DateTime? dueDate;
 final  String? notes;

/// Create a copy of InvoiceEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateInvoiceCopyWith<CreateInvoice> get copyWith => _$CreateInvoiceCopyWithImpl<CreateInvoice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateInvoice&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode => Object.hash(runtimeType,summary,createdBy,dueDate,notes);

@override
String toString() {
  return 'InvoiceEvent.createInvoice(summary: $summary, createdBy: $createdBy, dueDate: $dueDate, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $CreateInvoiceCopyWith<$Res> implements $InvoiceEventCopyWith<$Res> {
  factory $CreateInvoiceCopyWith(CreateInvoice value, $Res Function(CreateInvoice) _then) = _$CreateInvoiceCopyWithImpl;
@useResult
$Res call({
 PeriodSummary summary, String createdBy, DateTime? dueDate, String? notes
});


$PeriodSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$CreateInvoiceCopyWithImpl<$Res>
    implements $CreateInvoiceCopyWith<$Res> {
  _$CreateInvoiceCopyWithImpl(this._self, this._then);

  final CreateInvoice _self;
  final $Res Function(CreateInvoice) _then;

/// Create a copy of InvoiceEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? createdBy = null,Object? dueDate = freezed,Object? notes = freezed,}) {
  return _then(CreateInvoice(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as PeriodSummary,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of InvoiceEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PeriodSummaryCopyWith<$Res> get summary {
  
  return $PeriodSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

/// @nodoc


class UpdateInvoiceStatus implements InvoiceEvent {
  const UpdateInvoiceStatus({required this.invoiceId, required this.status});
  

 final  String invoiceId;
 final  InvoiceStatus status;

/// Create a copy of InvoiceEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateInvoiceStatusCopyWith<UpdateInvoiceStatus> get copyWith => _$UpdateInvoiceStatusCopyWithImpl<UpdateInvoiceStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateInvoiceStatus&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,invoiceId,status);

@override
String toString() {
  return 'InvoiceEvent.updateStatus(invoiceId: $invoiceId, status: $status)';
}


}

/// @nodoc
abstract mixin class $UpdateInvoiceStatusCopyWith<$Res> implements $InvoiceEventCopyWith<$Res> {
  factory $UpdateInvoiceStatusCopyWith(UpdateInvoiceStatus value, $Res Function(UpdateInvoiceStatus) _then) = _$UpdateInvoiceStatusCopyWithImpl;
@useResult
$Res call({
 String invoiceId, InvoiceStatus status
});




}
/// @nodoc
class _$UpdateInvoiceStatusCopyWithImpl<$Res>
    implements $UpdateInvoiceStatusCopyWith<$Res> {
  _$UpdateInvoiceStatusCopyWithImpl(this._self, this._then);

  final UpdateInvoiceStatus _self;
  final $Res Function(UpdateInvoiceStatus) _then;

/// Create a copy of InvoiceEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? invoiceId = null,Object? status = null,}) {
  return _then(UpdateInvoiceStatus(
invoiceId: null == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InvoiceStatus,
  ));
}


}

/// @nodoc


class GenerateInvoicePdf implements InvoiceEvent {
  const GenerateInvoicePdf({required this.invoice});
  

 final  Invoice invoice;

/// Create a copy of InvoiceEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerateInvoicePdfCopyWith<GenerateInvoicePdf> get copyWith => _$GenerateInvoicePdfCopyWithImpl<GenerateInvoicePdf>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerateInvoicePdf&&(identical(other.invoice, invoice) || other.invoice == invoice));
}


@override
int get hashCode => Object.hash(runtimeType,invoice);

@override
String toString() {
  return 'InvoiceEvent.generatePdf(invoice: $invoice)';
}


}

/// @nodoc
abstract mixin class $GenerateInvoicePdfCopyWith<$Res> implements $InvoiceEventCopyWith<$Res> {
  factory $GenerateInvoicePdfCopyWith(GenerateInvoicePdf value, $Res Function(GenerateInvoicePdf) _then) = _$GenerateInvoicePdfCopyWithImpl;
@useResult
$Res call({
 Invoice invoice
});


$InvoiceCopyWith<$Res> get invoice;

}
/// @nodoc
class _$GenerateInvoicePdfCopyWithImpl<$Res>
    implements $GenerateInvoicePdfCopyWith<$Res> {
  _$GenerateInvoicePdfCopyWithImpl(this._self, this._then);

  final GenerateInvoicePdf _self;
  final $Res Function(GenerateInvoicePdf) _then;

/// Create a copy of InvoiceEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? invoice = null,}) {
  return _then(GenerateInvoicePdf(
invoice: null == invoice ? _self.invoice : invoice // ignore: cast_nullable_to_non_nullable
as Invoice,
  ));
}

/// Create a copy of InvoiceEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvoiceCopyWith<$Res> get invoice {
  
  return $InvoiceCopyWith<$Res>(_self.invoice, (value) {
    return _then(_self.copyWith(invoice: value));
  });
}
}

/// @nodoc


class DeleteInvoice implements InvoiceEvent {
  const DeleteInvoice({required this.invoiceId});
  

 final  String invoiceId;

/// Create a copy of InvoiceEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteInvoiceCopyWith<DeleteInvoice> get copyWith => _$DeleteInvoiceCopyWithImpl<DeleteInvoice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteInvoice&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId));
}


@override
int get hashCode => Object.hash(runtimeType,invoiceId);

@override
String toString() {
  return 'InvoiceEvent.deleteInvoice(invoiceId: $invoiceId)';
}


}

/// @nodoc
abstract mixin class $DeleteInvoiceCopyWith<$Res> implements $InvoiceEventCopyWith<$Res> {
  factory $DeleteInvoiceCopyWith(DeleteInvoice value, $Res Function(DeleteInvoice) _then) = _$DeleteInvoiceCopyWithImpl;
@useResult
$Res call({
 String invoiceId
});




}
/// @nodoc
class _$DeleteInvoiceCopyWithImpl<$Res>
    implements $DeleteInvoiceCopyWith<$Res> {
  _$DeleteInvoiceCopyWithImpl(this._self, this._then);

  final DeleteInvoice _self;
  final $Res Function(DeleteInvoice) _then;

/// Create a copy of InvoiceEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? invoiceId = null,}) {
  return _then(DeleteInvoice(
invoiceId: null == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SendInvoice implements InvoiceEvent {
  const SendInvoice({required this.invoice});
  

 final  Invoice invoice;

/// Create a copy of InvoiceEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendInvoiceCopyWith<SendInvoice> get copyWith => _$SendInvoiceCopyWithImpl<SendInvoice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendInvoice&&(identical(other.invoice, invoice) || other.invoice == invoice));
}


@override
int get hashCode => Object.hash(runtimeType,invoice);

@override
String toString() {
  return 'InvoiceEvent.sendInvoice(invoice: $invoice)';
}


}

/// @nodoc
abstract mixin class $SendInvoiceCopyWith<$Res> implements $InvoiceEventCopyWith<$Res> {
  factory $SendInvoiceCopyWith(SendInvoice value, $Res Function(SendInvoice) _then) = _$SendInvoiceCopyWithImpl;
@useResult
$Res call({
 Invoice invoice
});


$InvoiceCopyWith<$Res> get invoice;

}
/// @nodoc
class _$SendInvoiceCopyWithImpl<$Res>
    implements $SendInvoiceCopyWith<$Res> {
  _$SendInvoiceCopyWithImpl(this._self, this._then);

  final SendInvoice _self;
  final $Res Function(SendInvoice) _then;

/// Create a copy of InvoiceEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? invoice = null,}) {
  return _then(SendInvoice(
invoice: null == invoice ? _self.invoice : invoice // ignore: cast_nullable_to_non_nullable
as Invoice,
  ));
}

/// Create a copy of InvoiceEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvoiceCopyWith<$Res> get invoice {
  
  return $InvoiceCopyWith<$Res>(_self.invoice, (value) {
    return _then(_self.copyWith(invoice: value));
  });
}
}

// dart format on
