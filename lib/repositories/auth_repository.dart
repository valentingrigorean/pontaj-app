import '../core/storage/local_storage.dart';
import '../models/user.dart';
import '../models/enums.dart';

class AuthRepository {
  final LocalStorage _storage;

  AuthRepository({LocalStorage? storage}) : _storage = storage ?? LocalStorage();

  static const _usersKey = 'users';

  List<User> getUsers() {
    final usersJson = _storage.read<List<dynamic>>(_usersKey);
    if (usersJson == null) return [];
    return usersJson
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveUsers(List<User> users) async {
    await _storage.write(_usersKey, users.map((u) => u.toJson()).toList());
  }

  Future<User?> authenticate(String username, String password) async {
    final users = getUsers();
    try {
      final user = users.firstWhere(
        (u) => u.username.toLowerCase() == username.toLowerCase(),
      );
      if (user.password == password) {
        return user;
      }
    } catch (_) {}
    return null;
  }

  Future<String?> register(String username, String password) async {
    final trimmed = username.trim();
    if (trimmed.isEmpty || password.length < 4) {
      return 'Completati un nume si o parola (>= 4).';
    }

    final users = getUsers();
    final exists = users.any(
      (u) => u.username.toLowerCase() == trimmed.toLowerCase(),
    );
    if (exists) {
      return 'Utilizatorul exista deja.';
    }

    final newUser = User(
      username: trimmed,
      password: password,
      role: Role.user,
    );
    users.add(newUser);
    await saveUsers(users);
    return null;
  }

  Future<void> ensureDefaults() async {
    final users = getUsers();
    final hasAdmin = users.any(
      (u) => u.username.toLowerCase().contains('ilie'),
    );
    if (!hasAdmin) {
      users.add(const User(
        username: 'Ilie',
        password: '1234',
        role: Role.admin,
      ));
      await saveUsers(users);
    }
  }

  Future<void> updateUser(User user) async {
    final users = getUsers();
    final index = users.indexWhere(
      (u) => u.username.toLowerCase() == user.username.toLowerCase(),
    );
    if (index != -1) {
      users[index] = user;
      await saveUsers(users);
    }
  }

  User? getUserByUsername(String username) {
    final users = getUsers();
    try {
      return users.firstWhere(
        (u) => u.username.toLowerCase() == username.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
