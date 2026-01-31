// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Invoice _$InvoiceFromJson(Map<String, dynamic> json) => _Invoice(
  id: json['id'] as String?,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  periodStart: const TimestampConverter().fromJson(json['periodStart']),
  periodEnd: const TimestampConverter().fromJson(json['periodEnd']),
  totalHours: (json['totalHours'] as num).toDouble(),
  hourlyRate: (json['hourlyRate'] as num).toDouble(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  currency:
      $enumDecodeNullable(_$CurrencyEnumMap, json['currency']) ?? Currency.lei,
  status:
      $enumDecodeNullable(_$InvoiceStatusEnumMap, json['status']) ??
      InvoiceStatus.draft,
  invoiceNumber: json['invoiceNumber'] as String,
  dueDate: const NullableTimestampConverter().fromJson(json['dueDate']),
  pdfStoragePath: json['pdfStoragePath'] as String?,
  pdfDownloadUrl: json['pdfDownloadUrl'] as String?,
  entryIds:
      (json['entryIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: const ServerTimestampConverter().fromJson(json['createdAt']),
  createdBy: json['createdBy'] as String,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$InvoiceToJson(_Invoice instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'userName': instance.userName,
  'periodStart': const TimestampConverter().toJson(instance.periodStart),
  'periodEnd': const TimestampConverter().toJson(instance.periodEnd),
  'totalHours': instance.totalHours,
  'hourlyRate': instance.hourlyRate,
  'totalAmount': instance.totalAmount,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'status': _$InvoiceStatusEnumMap[instance.status]!,
  'invoiceNumber': instance.invoiceNumber,
  'dueDate': const NullableTimestampConverter().toJson(instance.dueDate),
  'pdfStoragePath': instance.pdfStoragePath,
  'pdfDownloadUrl': instance.pdfDownloadUrl,
  'entryIds': instance.entryIds,
  'createdAt': const ServerTimestampConverter().toJson(instance.createdAt),
  'createdBy': instance.createdBy,
  'notes': instance.notes,
};

const _$CurrencyEnumMap = {Currency.lei: 'lei', Currency.euro: 'euro'};

const _$InvoiceStatusEnumMap = {
  InvoiceStatus.draft: 'draft',
  InvoiceStatus.sent: 'sent',
  InvoiceStatus.paid: 'paid',
  InvoiceStatus.overdue: 'overdue',
  InvoiceStatus.cancelled: 'cancelled',
};
