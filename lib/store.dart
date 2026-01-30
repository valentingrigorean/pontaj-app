import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';

import 'storage_driver.dart';

final AppStore appStore = AppStore();

enum Role { user, admin }

enum SalaryType { hourly, monthly } // Orar sau Lunar

enum Currency { lei, euro } // Lei sau Euro

class UserRec {
  final String username;
  final String password; // simple for now
  final Role role;
  final double? salaryAmount; // Suma (fie tarif orar, fie salariu lunar)
  final SalaryType salaryType; // Tip: orar sau lunar
  final Currency currency; // Monedă: lei sau euro

  UserRec({
    required this.username,
    required this.password,
    required this.role,
    this.salaryAmount,
    this.salaryType = SalaryType.hourly,
    this.currency = Currency.lei,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'role': role.name,
    if (salaryAmount != null) 'salaryAmount': salaryAmount,
    'salaryType': salaryType.name,
    'currency': currency.name,
  };

  factory UserRec.fromJson(Map<String, dynamic> j) => UserRec(
    username: j['username'] as String? ?? '',
    password: j['password'] as String? ?? '',
    role: (j['role'] as String?) == 'admin' ? Role.admin : Role.user,
    salaryAmount: (j['salaryAmount'] as num?)?.toDouble() ??
                  (j['hourlyRate'] as num?)?.toDouble(), // backwards compatibility
    salaryType: (j['salaryType'] as String?) == 'monthly'
        ? SalaryType.monthly
        : SalaryType.hourly,
    currency: (j['currency'] as String?) == 'euro'
        ? Currency.euro
        : Currency.lei,
  );

  UserRec copyWith({
    String? username,
    String? password,
    Role? role,
    double? salaryAmount,
    SalaryType? salaryType,
    Currency? currency,
  }) =>
      UserRec(
        username: username ?? this.username,
        password: password ?? this.password,
        role: role ?? this.role,
        salaryAmount: salaryAmount ?? this.salaryAmount,
        salaryType: salaryType ?? this.salaryType,
        currency: currency ?? this.currency,
      );
}

class AppStore extends ChangeNotifier {
  AppStore({StorageDriver? driver})
      : _storage = driver ?? createStorageDriver();

  final StorageDriver _storage;
  // ---- DATA ----
  final List<PontajEntry> _entries = [];
  final List<String> _locatii = ['Casa A', 'Casa B', 'Fabrica', 'Depozit'];
  final List<UserRec> _users = [];

  // ---- READ ----
  List<PontajEntry> get entries => List.unmodifiable(_entries);
  List<String> get locatii => List.unmodifiable(_locatii);
  List<UserRec> get users => List.unmodifiable(_users);

  // ---- USERS / AUTH ----
  Future<void> ensureDefaults() async {
    // default admin
    if (_users.indexWhere((u) => u.username.toLowerCase().contains('ilie')) ==
        -1) {
      _users.add(UserRec(username: 'Ilie', password: '1234', role: Role.admin));
      await save();
    }
  }

  Future<void> ensureDemoData() async {
    const demoUser = 'TestUser';
    if (_users.every((u) => u.username.toLowerCase() != demoUser.toLowerCase())) {
      _users.add(UserRec(username: demoUser, password: 'test', role: Role.user));
    }
    final existingDemo = _entries.where((e) => e.user == demoUser).length;
    final toGenerate = 20 - existingDemo;
    if (toGenerate <= 0) return;

    final rand = Random(42);
    for (int i = 0; i < toGenerate; i++) {
      final day = DateTime.now().subtract(Duration(days: i + 1));
      final startHour = 7 + rand.nextInt(4); // 7-10
      final startMinute = rand.nextBool() ? 0 : 30;
      final spanHours = 6 + rand.nextInt(3); // 6-8 hours
      final spanMinutes = spanHours * 60;
      final breakMinutes = [0, 30, 60][rand.nextInt(3)];
      final start = DateTime(day.year, day.month, day.day, startHour, startMinute);
      final end = start.add(Duration(minutes: spanMinutes));
      final intervalText =
          '${_twoDigits(start.hour)}:${_twoDigits(start.minute)} - ${_twoDigits(end.hour)}:${_twoDigits(end.minute)}';
      final workedMinutes =
          (spanMinutes - breakMinutes).clamp(0, 24 * 60).toInt();
      final locatie = rand.nextBool() ? 'CountryLab' : 'Giordano';

      _rememberLocatie(locatie);
      _entries.add(
        PontajEntry(
          user: demoUser,
          locatie: locatie,
          intervalText: intervalText,
          breakMinutes: breakMinutes,
          date: DateTime(day.year, day.month, day.day),
          totalWorked: Duration(minutes: workedMinutes),
        ),
      );
    }
    await save();
  }

  bool usernameExists(String u) =>
      _users.any((x) => x.username.toLowerCase() == u.toLowerCase());

  String? registerUser(String username, String password) {
    final u = username.trim();
    if (u.isEmpty || password.length < 4) {
      return 'Completati un nume si o parola (>= 4).';
    }
    if (usernameExists(u)) return 'Utilizatorul există deja.';
    _users.add(UserRec(username: u, password: password, role: Role.user));
    _autoSave();
    notifyListeners();
    return null; // success
  }

  /// returns (username, isAdmin) if ok, else null
  (String, bool)? authenticate(String username, String password) {
    final u = _users.firstWhere(
      (x) => x.username.toLowerCase() == username.toLowerCase(),
      orElse: () => UserRec(username: '', password: '', role: Role.user),
    );
    if (u.username.isEmpty) return null;
    if (u.password != password) return null;
    return (u.username, u.role == Role.admin);
  }

  // ---- ENTRIES ----
  void addEntry(PontajEntry e) {
    _entries.add(e);
    _rememberLocatie(e.locatie);
    _autoSave();
    notifyListeners();
  }

  void updateEntry(int index, PontajEntry e) {
    if (index < 0 || index >= _entries.length) return;
    _entries[index] = e;
    _rememberLocatie(e.locatie);
    _autoSave();
    notifyListeners();
  }

  void deleteEntry(int index) {
    if (index < 0 || index >= _entries.length) return;
    _entries.removeAt(index);
    _autoSave();
    notifyListeners();
  }

  String fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  // ---- SALARII ----
  /// Setează salariul pentru un utilizator
  void setUserSalary({
    required String username,
    required double amount,
    required SalaryType type,
    required Currency currency,
  }) {
    final index = _users.indexWhere(
      (u) => u.username.toLowerCase() == username.toLowerCase(),
    );
    if (index == -1) return;
    _users[index] = _users[index].copyWith(
      salaryAmount: amount,
      salaryType: type,
      currency: currency,
    );
    _autoSave();
    notifyListeners();
  }

  /// Calculează salariul pentru un utilizator pe baza pontajelor
  double calculateSalary(String username, {DateTime? startDate, DateTime? endDate}) {
    final user = _users.firstWhere(
      (u) => u.username.toLowerCase() == username.toLowerCase(),
      orElse: () => UserRec(username: '', password: '', role: Role.user),
    );
    if (user.salaryAmount == null || user.salaryAmount == 0) return 0.0;

    // Dacă e salariu lunar fix, returnează suma fixă
    if (user.salaryType == SalaryType.monthly) {
      return user.salaryAmount!;
    }

    // Dacă e tarif orar, calculează pe baza orelor lucrate
    final userEntries = _entries.where((e) {
      if (e.user.toLowerCase() != username.toLowerCase()) return false;
      if (startDate != null && e.date.isBefore(startDate)) return false;
      if (endDate != null && e.date.isAfter(endDate)) return false;
      return true;
    });

    final totalHours = userEntries.fold<double>(
      0.0,
      (sum, e) => sum + (e.totalWorked.inMinutes / 60.0),
    );

    return totalHours * user.salaryAmount!;
  }

  /// Obține toate datele de salarizare pentru toți utilizatorii
  Map<String, Map<String, dynamic>> getAllSalaries({DateTime? startDate, DateTime? endDate}) {
    final result = <String, Map<String, dynamic>>{};

    for (final user in _users) {
      final userEntries = _entries.where((e) {
        if (e.user.toLowerCase() != user.username.toLowerCase()) return false;
        if (startDate != null && e.date.isBefore(startDate)) return false;
        if (endDate != null && e.date.isAfter(endDate)) return false;
        return true;
      }).toList();

      final totalDuration = userEntries.fold<Duration>(
        Duration.zero,
        (sum, e) => sum + e.totalWorked,
      );

      final totalHours = totalDuration.inMinutes / 60.0;

      // Calculează salariul în funcție de tip
      final double salary;
      if (user.salaryType == SalaryType.monthly) {
        // Salariu fix lunar
        salary = user.salaryAmount ?? 0.0;
      } else {
        // Tarif orar × ore lucrate
        salary = (user.salaryAmount ?? 0.0) * totalHours;
      }

      result[user.username] = {
        'salaryAmount': user.salaryAmount ?? 0.0,
        'salaryType': user.salaryType,
        'currency': user.currency,
        'totalHours': totalHours,
        'totalDays': userEntries.length,
        'salary': salary,
        'entries': userEntries,
      };
    }

    return result;
  }

  Future<String> exportCSV() async {
    final buffer = StringBuffer();
    buffer.writeln('Data,Utilizator,Locatie,Interval,Pauza(min),Total');
    for (final e in _entries) {
      final d = '${e.date.day}/${e.date.month}/${e.date.year}';
      buffer.writeln(
        '$d,${_esc(e.user)},${_esc(e.locatie)},${_esc(e.intervalText)},${e.breakMinutes},${fmt(e.totalWorked)}',
      );
    }
    return _storage.exportCsv(buffer.toString());
  }

  Future<void> load() async {
    try {
      final text = await _storage.load();
      if (text != null && text.trim().isNotEmpty) {
        final map = jsonDecode(text) as Map<String, dynamic>;
        final list = (map['entries'] as List? ?? const []);
        _entries
          ..clear()
          ..addAll(
            list.map((e) => PontajEntry.fromJson(e as Map<String, dynamic>)),
          );

        final locs =
            (map['locatii'] as List?)?.cast<String>() ?? const <String>[];
        _locatii
          ..clear()
          ..addAll(
            locs.isEmpty ? ['Casa A', 'Casa B', 'Fabrica', 'Depozit'] : locs,
          );

        final us = (map['users'] as List? ?? const []);
        _users
          ..clear()
          ..addAll(
            us.map((e) => UserRec.fromJson(e as Map<String, dynamic>)),
          );
      }
    } catch (_) {}
    await ensureDefaults();
    await ensureDemoData();
    notifyListeners();
  }

  Future<void> save() async {
    final map = <String, dynamic>{
      'entries': _entries.map((e) => e.toJson()).toList(),
      'locatii': _locatii,
      'users': _users.map((u) => u.toJson()).toList(),
    };
    await _storage.save(jsonEncode(map));
  }

  void _autoSave() {
    save();
  }

  void _rememberLocatie(String v) {
    final value = v.trim();
    if (value.isEmpty) return;
    final exists = _locatii.any((e) => e.toLowerCase() == value.toLowerCase());
    if (!exists) _locatii.insert(0, value);
  }

  String _esc(String s) => s.replaceAll(',', ';');

  String _twoDigits(int value) => value.toString().padLeft(2, '0');
}

class PontajEntry {
  final String user;
  final String locatie;
  final String intervalText;
  final int breakMinutes;
  final DateTime date;
  final Duration totalWorked;

  PontajEntry({
    required this.user,
    required this.locatie,
    required this.intervalText,
    required this.breakMinutes,
    required this.date,
    required this.totalWorked,
  });

  Map<String, dynamic> toJson() => {
    'user': user,
    'locatie': locatie,
    'intervalText': intervalText,
    'breakMinutes': breakMinutes,
    'date': date.toIso8601String(),
    'totalWorked': totalWorked.inMinutes,
  };

  factory PontajEntry.fromJson(Map<String, dynamic> j) => PontajEntry(
    user: j['user'] as String? ?? '',
    locatie: j['locatie'] as String? ?? '',
    intervalText: j['intervalText'] as String? ?? '',
    breakMinutes: j['breakMinutes'] as int? ?? 0,
    date: DateTime.tryParse(j['date'] as String? ?? '') ?? DateTime.now(),
    totalWorked: Duration(minutes: (j['totalWorked'] as int?) ?? 0),
  );
}
