import 'package:bcrypt/bcrypt.dart';
import 'database_service.dart';
import '../store.dart';

/// Professional authentication service with bcrypt password hashing
/// Replaces insecure plaintext password storage
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final DatabaseService _db = DatabaseService();

  // Current logged-in user session
  String? _currentUsername;
  Role? _currentRole;

  String? get currentUsername => _currentUsername;
  Role? get currentRole => _currentRole;
  bool get isLoggedIn => _currentUsername != null;
  bool get isAdmin => _currentRole == Role.admin;

  /// Hash a password using bcrypt with cost factor 12
  Future<String> hashPassword(String password) async {
    return BCrypt.hashpw(password, BCrypt.gensalt(logRounds: 12));
  }

  /// Verify a password against a bcrypt hash
  bool verifyPassword(String password, String hash) {
    return BCrypt.checkpw(password, hash);
  }

  /// Register a new user with encrypted password
  Future<bool> register({
    required String username,
    required String password,
    Role role = Role.user,
    double? salaryAmount,
    SalaryType salaryType = SalaryType.hourly,
    Currency currency = Currency.lei,
  }) async {
    try {
      // Check if user already exists
      final existing = await _db.getUserByUsername(username);
      if (existing != null) {
        return false; // User already exists
      }

      // Hash the password
      final passwordHash = await hashPassword(password);

      // Create user record
      final user = UserRec(
        username: username,
        password: '', // Not used with database
        role: role,
        salaryAmount: salaryAmount,
        salaryType: salaryType,
        currency: currency,
      );

      // Insert into database
      await _db.insertUser(user, passwordHash);
      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  /// Login with username and password
  Future<bool> login(String username, String password) async {
    try {
      // Get user from database
      final userRow = await _db.getUserByUsername(username);
      if (userRow == null) {
        return false; // User not found
      }

      // Verify password
      final passwordHash = userRow['password_hash'] as String;
      if (!verifyPassword(password, passwordHash)) {
        return false; // Wrong password
      }

      // Set session
      _currentUsername = username;
      _currentRole = Role.values.firstWhere(
        (r) => r.name == userRow['role'],
      );

      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  /// Special admin login (for backward compatibility)
  /// TODO: Remove hardcoded admin once migrated
  Future<bool> loginAdmin(String username, String password) async {
    // Check hardcoded admin first (backward compatibility)
    if (username.toLowerCase().contains('ilie') && password == '1234') {
      _currentUsername = 'Ilie';
      _currentRole = Role.admin;

      // Create admin user in database if doesn't exist
      final existing = await _db.getUserByUsername('Ilie');
      if (existing == null) {
        await register(
          username: 'Ilie',
          password: '1234',
          role: Role.admin,
        );
      }

      return true;
    }

    // Otherwise use normal login
    return await login(username, password);
  }

  /// Logout current user
  void logout() {
    _currentUsername = null;
    _currentRole = null;
  }

  /// Change password for current user
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (!isLoggedIn) return false;

    try {
      final userRow = await _db.getUserByUsername(_currentUsername!);
      if (userRow == null) return false;

      final oldHash = userRow['password_hash'] as String;
      if (!verifyPassword(oldPassword, oldHash)) {
        return false; // Wrong old password
      }

      final newHash = await hashPassword(newPassword);
      final users = await _db.getAllUsers();
      final user = users.firstWhere((u) => u.username == _currentUsername);

      await _db.updateUser(user, passwordHash: newHash);
      return true;
    } catch (e) {
      print('Change password error: $e');
      return false;
    }
  }

  /// Reset password for any user (admin only)
  Future<bool> resetUserPassword(String username, String newPassword) async {
    if (!isAdmin) return false;

    try {
      final newHash = await hashPassword(newPassword);
      final users = await _db.getAllUsers();
      final user = users.firstWhere((u) => u.username == username);

      await _db.updateUser(user, passwordHash: newHash);
      return true;
    } catch (e) {
      print('Reset password error: $e');
      return false;
    }
  }

  /// Check if a password meets security requirements
  bool isPasswordStrong(String password) {
    if (password.length < 8) return false;

    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChars = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasUppercase && hasLowercase && hasDigits && hasSpecialChars;
  }

  /// Get password strength score (0-4)
  int getPasswordStrength(String password) {
    int score = 0;

    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.contains(RegExp(r'[A-Z]')) && password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    return score > 4 ? 4 : score;
  }

  /// Migrate existing plaintext users to encrypted passwords
  Future<void> migrateToEncryptedPasswords(List<UserRec> oldUsers) async {
    for (final user in oldUsers) {
      final existing = await _db.getUserByUsername(user.username);
      if (existing == null) {
        // User doesn't exist in database, migrate them
        final passwordHash = await hashPassword(user.password);
        await _db.insertUser(user, passwordHash);
      }
    }
  }
}
