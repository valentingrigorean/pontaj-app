import 'package:flutter_test/flutter_test.dart';
import 'package:pontaj_app/data/models/enums.dart';
import 'package:pontaj_app/data/models/time_entry.dart';
import 'package:pontaj_app/data/models/user.dart';

void main() {
  group('TimeEntry', () {
    test('formatDuration formats correctly', () {
      expect(TimeEntry.formatDuration(const Duration(hours: 8)), '8h');
      expect(
        TimeEntry.formatDuration(const Duration(hours: 8, minutes: 30)),
        '8h 30m',
      );
      expect(
        TimeEntry.formatDuration(const Duration(hours: 0, minutes: 45)),
        '0h 45m',
      );
    });

    test('toJson and fromJson work correctly', () {
      final entry = TimeEntry(
        id: '123',
        userId: 'user-123',
        userName: 'TestUser',
        location: 'Office',
        intervalText: '08:00 - 17:00',
        breakMinutes: 30,
        date: DateTime(2024, 1, 15),
        totalWorked: const Duration(hours: 8, minutes: 30),
      );

      final json = entry.toJson();
      final restored = TimeEntry.fromJson(json);

      expect(restored.id, entry.id);
      expect(restored.userId, entry.userId);
      expect(restored.userName, entry.userName);
      expect(restored.location, entry.location);
      expect(restored.intervalText, entry.intervalText);
      expect(restored.breakMinutes, entry.breakMinutes);
      expect(restored.totalWorked, entry.totalWorked);
    });
  });

  group('User', () {
    test('toJson and fromJson work correctly', () {
      const user = User(
        id: 'user-123',
        email: 'test@example.com',
        displayName: 'Test User',
        role: Role.admin,
        salaryAmount: 50.0,
        salaryType: SalaryType.hourly,
        currency: Currency.lei,
      );

      final json = user.toJson();
      final restored = User.fromJson(json);

      expect(restored.id, user.id);
      expect(restored.email, user.email);
      expect(restored.displayName, user.displayName);
      expect(restored.role, user.role);
      expect(restored.salaryAmount, user.salaryAmount);
      expect(restored.salaryType, user.salaryType);
      expect(restored.currency, user.currency);
    });

    test('isAdmin returns correct value', () {
      const admin = User(id: '1', email: 'admin@test.com', role: Role.admin);
      const user = User(id: '2', email: 'user@test.com', role: Role.user);

      expect(admin.isAdmin, true);
      expect(user.isAdmin, false);
    });

    test('displayNameOrEmail returns correct value', () {
      const userWithName = User(
        id: '1',
        email: 'test@example.com',
        displayName: 'Test User',
        role: Role.user,
      );
      const userWithoutName = User(
        id: '2',
        email: 'another@example.com',
        role: Role.user,
      );

      expect(userWithName.displayNameOrEmail, 'Test User');
      expect(userWithoutName.displayNameOrEmail, 'another');
    });
  });
}
