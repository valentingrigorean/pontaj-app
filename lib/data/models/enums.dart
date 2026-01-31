import 'package:json_annotation/json_annotation.dart';

@JsonEnum(alwaysCreate: true)
enum Role {
  user,
  admin;

  bool get isAdmin => this == .admin;
}

@JsonEnum(alwaysCreate: true)
enum SalaryType { hourly, monthly }

@JsonEnum(alwaysCreate: true)
enum Currency {
  lei,
  euro;

  /// Display symbol for UI (uses € for euro)
  String get symbol => this == .euro ? '\u20AC' : 'RON';

  /// PDF-safe symbol (uses EUR text instead of € symbol)
  String get pdfSymbol => this == .euro ? 'EUR' : 'RON';
}

@JsonEnum(alwaysCreate: true)
enum InvoiceStatus {
  draft,
  sent,
  paid,
  overdue,
  cancelled;

  bool get isFinal => this == .paid || this == .cancelled;
}
