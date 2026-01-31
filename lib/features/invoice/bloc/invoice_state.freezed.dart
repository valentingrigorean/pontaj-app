// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InvoiceState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InvoiceState()';
}


}

/// @nodoc
class $InvoiceStateCopyWith<$Res>  {
$InvoiceStateCopyWith(InvoiceState _, $Res Function(InvoiceState) __);
}


/// Adds pattern-matching-related methods to [InvoiceState].
extension InvoiceStatePatterns on InvoiceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InvoiceInitial value)?  initial,TResult Function( InvoiceLoading value)?  loading,TResult Function( InvoiceLoaded value)?  loaded,TResult Function( InvoiceError value)?  error,TResult Function( InvoicePdfGenerating value)?  pdfGenerating,TResult Function( InvoicePdfGenerated value)?  pdfGenerated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InvoiceInitial() when initial != null:
return initial(_that);case InvoiceLoading() when loading != null:
return loading(_that);case InvoiceLoaded() when loaded != null:
return loaded(_that);case InvoiceError() when error != null:
return error(_that);case InvoicePdfGenerating() when pdfGenerating != null:
return pdfGenerating(_that);case InvoicePdfGenerated() when pdfGenerated != null:
return pdfGenerated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InvoiceInitial value)  initial,required TResult Function( InvoiceLoading value)  loading,required TResult Function( InvoiceLoaded value)  loaded,required TResult Function( InvoiceError value)  error,required TResult Function( InvoicePdfGenerating value)  pdfGenerating,required TResult Function( InvoicePdfGenerated value)  pdfGenerated,}){
final _that = this;
switch (_that) {
case InvoiceInitial():
return initial(_that);case InvoiceLoading():
return loading(_that);case InvoiceLoaded():
return loaded(_that);case InvoiceError():
return error(_that);case InvoicePdfGenerating():
return pdfGenerating(_that);case InvoicePdfGenerated():
return pdfGenerated(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InvoiceInitial value)?  initial,TResult? Function( InvoiceLoading value)?  loading,TResult? Function( InvoiceLoaded value)?  loaded,TResult? Function( InvoiceError value)?  error,TResult? Function( InvoicePdfGenerating value)?  pdfGenerating,TResult? Function( InvoicePdfGenerated value)?  pdfGenerated,}){
final _that = this;
switch (_that) {
case InvoiceInitial() when initial != null:
return initial(_that);case InvoiceLoading() when loading != null:
return loading(_that);case InvoiceLoaded() when loaded != null:
return loaded(_that);case InvoiceError() when error != null:
return error(_that);case InvoicePdfGenerating() when pdfGenerating != null:
return pdfGenerating(_that);case InvoicePdfGenerated() when pdfGenerated != null:
return pdfGenerated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Invoice> invoices,  bool isAdmin)?  loaded,TResult Function( String message,  List<Invoice>? previousInvoices)?  error,TResult Function( List<Invoice> invoices,  String invoiceId)?  pdfGenerating,TResult Function( List<Invoice> invoices,  String invoiceId,  String downloadUrl)?  pdfGenerated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InvoiceInitial() when initial != null:
return initial();case InvoiceLoading() when loading != null:
return loading();case InvoiceLoaded() when loaded != null:
return loaded(_that.invoices,_that.isAdmin);case InvoiceError() when error != null:
return error(_that.message,_that.previousInvoices);case InvoicePdfGenerating() when pdfGenerating != null:
return pdfGenerating(_that.invoices,_that.invoiceId);case InvoicePdfGenerated() when pdfGenerated != null:
return pdfGenerated(_that.invoices,_that.invoiceId,_that.downloadUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Invoice> invoices,  bool isAdmin)  loaded,required TResult Function( String message,  List<Invoice>? previousInvoices)  error,required TResult Function( List<Invoice> invoices,  String invoiceId)  pdfGenerating,required TResult Function( List<Invoice> invoices,  String invoiceId,  String downloadUrl)  pdfGenerated,}) {final _that = this;
switch (_that) {
case InvoiceInitial():
return initial();case InvoiceLoading():
return loading();case InvoiceLoaded():
return loaded(_that.invoices,_that.isAdmin);case InvoiceError():
return error(_that.message,_that.previousInvoices);case InvoicePdfGenerating():
return pdfGenerating(_that.invoices,_that.invoiceId);case InvoicePdfGenerated():
return pdfGenerated(_that.invoices,_that.invoiceId,_that.downloadUrl);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Invoice> invoices,  bool isAdmin)?  loaded,TResult? Function( String message,  List<Invoice>? previousInvoices)?  error,TResult? Function( List<Invoice> invoices,  String invoiceId)?  pdfGenerating,TResult? Function( List<Invoice> invoices,  String invoiceId,  String downloadUrl)?  pdfGenerated,}) {final _that = this;
switch (_that) {
case InvoiceInitial() when initial != null:
return initial();case InvoiceLoading() when loading != null:
return loading();case InvoiceLoaded() when loaded != null:
return loaded(_that.invoices,_that.isAdmin);case InvoiceError() when error != null:
return error(_that.message,_that.previousInvoices);case InvoicePdfGenerating() when pdfGenerating != null:
return pdfGenerating(_that.invoices,_that.invoiceId);case InvoicePdfGenerated() when pdfGenerated != null:
return pdfGenerated(_that.invoices,_that.invoiceId,_that.downloadUrl);case _:
  return null;

}
}

}

/// @nodoc


class InvoiceInitial implements InvoiceState {
  const InvoiceInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InvoiceState.initial()';
}


}




/// @nodoc


class InvoiceLoading implements InvoiceState {
  const InvoiceLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InvoiceState.loading()';
}


}




/// @nodoc


class InvoiceLoaded implements InvoiceState {
  const InvoiceLoaded({required final  List<Invoice> invoices, this.isAdmin = false}): _invoices = invoices;
  

 final  List<Invoice> _invoices;
 List<Invoice> get invoices {
  if (_invoices is EqualUnmodifiableListView) return _invoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invoices);
}

@JsonKey() final  bool isAdmin;

/// Create a copy of InvoiceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceLoadedCopyWith<InvoiceLoaded> get copyWith => _$InvoiceLoadedCopyWithImpl<InvoiceLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceLoaded&&const DeepCollectionEquality().equals(other._invoices, _invoices)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_invoices),isAdmin);

@override
String toString() {
  return 'InvoiceState.loaded(invoices: $invoices, isAdmin: $isAdmin)';
}


}

/// @nodoc
abstract mixin class $InvoiceLoadedCopyWith<$Res> implements $InvoiceStateCopyWith<$Res> {
  factory $InvoiceLoadedCopyWith(InvoiceLoaded value, $Res Function(InvoiceLoaded) _then) = _$InvoiceLoadedCopyWithImpl;
@useResult
$Res call({
 List<Invoice> invoices, bool isAdmin
});




}
/// @nodoc
class _$InvoiceLoadedCopyWithImpl<$Res>
    implements $InvoiceLoadedCopyWith<$Res> {
  _$InvoiceLoadedCopyWithImpl(this._self, this._then);

  final InvoiceLoaded _self;
  final $Res Function(InvoiceLoaded) _then;

/// Create a copy of InvoiceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? invoices = null,Object? isAdmin = null,}) {
  return _then(InvoiceLoaded(
invoices: null == invoices ? _self._invoices : invoices // ignore: cast_nullable_to_non_nullable
as List<Invoice>,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class InvoiceError implements InvoiceState {
  const InvoiceError({required this.message, final  List<Invoice>? previousInvoices}): _previousInvoices = previousInvoices;
  

 final  String message;
 final  List<Invoice>? _previousInvoices;
 List<Invoice>? get previousInvoices {
  final value = _previousInvoices;
  if (value == null) return null;
  if (_previousInvoices is EqualUnmodifiableListView) return _previousInvoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of InvoiceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceErrorCopyWith<InvoiceError> get copyWith => _$InvoiceErrorCopyWithImpl<InvoiceError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._previousInvoices, _previousInvoices));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_previousInvoices));

@override
String toString() {
  return 'InvoiceState.error(message: $message, previousInvoices: $previousInvoices)';
}


}

/// @nodoc
abstract mixin class $InvoiceErrorCopyWith<$Res> implements $InvoiceStateCopyWith<$Res> {
  factory $InvoiceErrorCopyWith(InvoiceError value, $Res Function(InvoiceError) _then) = _$InvoiceErrorCopyWithImpl;
@useResult
$Res call({
 String message, List<Invoice>? previousInvoices
});




}
/// @nodoc
class _$InvoiceErrorCopyWithImpl<$Res>
    implements $InvoiceErrorCopyWith<$Res> {
  _$InvoiceErrorCopyWithImpl(this._self, this._then);

  final InvoiceError _self;
  final $Res Function(InvoiceError) _then;

/// Create a copy of InvoiceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? previousInvoices = freezed,}) {
  return _then(InvoiceError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,previousInvoices: freezed == previousInvoices ? _self._previousInvoices : previousInvoices // ignore: cast_nullable_to_non_nullable
as List<Invoice>?,
  ));
}


}

/// @nodoc


class InvoicePdfGenerating implements InvoiceState {
  const InvoicePdfGenerating({required final  List<Invoice> invoices, required this.invoiceId}): _invoices = invoices;
  

 final  List<Invoice> _invoices;
 List<Invoice> get invoices {
  if (_invoices is EqualUnmodifiableListView) return _invoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invoices);
}

 final  String invoiceId;

/// Create a copy of InvoiceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoicePdfGeneratingCopyWith<InvoicePdfGenerating> get copyWith => _$InvoicePdfGeneratingCopyWithImpl<InvoicePdfGenerating>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoicePdfGenerating&&const DeepCollectionEquality().equals(other._invoices, _invoices)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_invoices),invoiceId);

@override
String toString() {
  return 'InvoiceState.pdfGenerating(invoices: $invoices, invoiceId: $invoiceId)';
}


}

/// @nodoc
abstract mixin class $InvoicePdfGeneratingCopyWith<$Res> implements $InvoiceStateCopyWith<$Res> {
  factory $InvoicePdfGeneratingCopyWith(InvoicePdfGenerating value, $Res Function(InvoicePdfGenerating) _then) = _$InvoicePdfGeneratingCopyWithImpl;
@useResult
$Res call({
 List<Invoice> invoices, String invoiceId
});




}
/// @nodoc
class _$InvoicePdfGeneratingCopyWithImpl<$Res>
    implements $InvoicePdfGeneratingCopyWith<$Res> {
  _$InvoicePdfGeneratingCopyWithImpl(this._self, this._then);

  final InvoicePdfGenerating _self;
  final $Res Function(InvoicePdfGenerating) _then;

/// Create a copy of InvoiceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? invoices = null,Object? invoiceId = null,}) {
  return _then(InvoicePdfGenerating(
invoices: null == invoices ? _self._invoices : invoices // ignore: cast_nullable_to_non_nullable
as List<Invoice>,invoiceId: null == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class InvoicePdfGenerated implements InvoiceState {
  const InvoicePdfGenerated({required final  List<Invoice> invoices, required this.invoiceId, required this.downloadUrl}): _invoices = invoices;
  

 final  List<Invoice> _invoices;
 List<Invoice> get invoices {
  if (_invoices is EqualUnmodifiableListView) return _invoices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_invoices);
}

 final  String invoiceId;
 final  String downloadUrl;

/// Create a copy of InvoiceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoicePdfGeneratedCopyWith<InvoicePdfGenerated> get copyWith => _$InvoicePdfGeneratedCopyWithImpl<InvoicePdfGenerated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoicePdfGenerated&&const DeepCollectionEquality().equals(other._invoices, _invoices)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_invoices),invoiceId,downloadUrl);

@override
String toString() {
  return 'InvoiceState.pdfGenerated(invoices: $invoices, invoiceId: $invoiceId, downloadUrl: $downloadUrl)';
}


}

/// @nodoc
abstract mixin class $InvoicePdfGeneratedCopyWith<$Res> implements $InvoiceStateCopyWith<$Res> {
  factory $InvoicePdfGeneratedCopyWith(InvoicePdfGenerated value, $Res Function(InvoicePdfGenerated) _then) = _$InvoicePdfGeneratedCopyWithImpl;
@useResult
$Res call({
 List<Invoice> invoices, String invoiceId, String downloadUrl
});




}
/// @nodoc
class _$InvoicePdfGeneratedCopyWithImpl<$Res>
    implements $InvoicePdfGeneratedCopyWith<$Res> {
  _$InvoicePdfGeneratedCopyWithImpl(this._self, this._then);

  final InvoicePdfGenerated _self;
  final $Res Function(InvoicePdfGenerated) _then;

/// Create a copy of InvoiceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? invoices = null,Object? invoiceId = null,Object? downloadUrl = null,}) {
  return _then(InvoicePdfGenerated(
invoices: null == invoices ? _self._invoices : invoices // ignore: cast_nullable_to_non_nullable
as List<Invoice>,invoiceId: null == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
