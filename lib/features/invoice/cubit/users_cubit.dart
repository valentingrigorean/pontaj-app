import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user.dart';
import '../../../data/repositories/firebase_auth_repository.dart';

/// State for users loading
sealed class UsersState {
  const UsersState();
}

final class UsersInitial extends UsersState {
  const UsersInitial();
}

final class UsersLoading extends UsersState {
  const UsersLoading();
}

final class UsersLoaded extends UsersState {
  final List<User> users;

  const UsersLoaded(this.users);
}

final class UsersError extends UsersState {
  final String message;

  const UsersError(this.message);
}

/// Cubit for loading users list (for invoice creation dropdown)
class UsersCubit extends Cubit<UsersState> {
  final FirebaseAuthRepository _authRepository;
  final String? _excludeUserId;
  StreamSubscription<List<User>>? _usersSubscription;

  UsersCubit({
    required FirebaseAuthRepository authRepository,
    String? excludeUserId,
  }) : _authRepository = authRepository,
       _excludeUserId = excludeUserId,
       super(const UsersInitial());

  void loadUsers() {
    emit(const UsersLoading());

    _usersSubscription?.cancel();
    _usersSubscription = _authRepository.getAllUsersStream().listen(
      (users) {
        // Filter out current user if specified
        final filteredUsers = _excludeUserId != null
            ? users.where((u) => u.id != _excludeUserId).toList()
            : users;
        emit(UsersLoaded(filteredUsers));
      },
      onError: (e) {
        emit(UsersError(e.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    return super.close();
  }
}
