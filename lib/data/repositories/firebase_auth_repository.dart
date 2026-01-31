import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/config/env.dart';
import '../models/enums.dart';
import '../models/user.dart';

/// Firebase Authentication repository for handling user authentication
/// and Firestore user profile management.
class FirebaseAuthRepository {
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  /// Admin registration secret code - loaded from .env file via envied
  /// If not set, admin registration is disabled
  static String get adminSecretCode => Env.adminCode;

  FirebaseAuthRepository({
    firebase_auth.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _auth = auth ?? firebase_auth.FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  /// Stream for auth state changes (for auto-login)
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  /// Get current Firebase user
  firebase_auth.User? get currentFirebaseUser => _auth.currentUser;

  /// Sign in with email/password
  /// Returns User on success, null on failure
  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user != null) {
        return await getUserProfile(credential.user!.uid);
      }
      return null;
    } on firebase_auth.FirebaseAuthException {
      rethrow;
    }
  }

  /// Register new user with email/password
  /// Pass adminCode to create admin user (must match [adminSecretCode])
  Future<User?> register(
    String email,
    String password, {
    String? adminCode,
    String? displayName,
  }) async {
    try {
      // Determine role based on admin code
      // Admin registration only works if ADMIN_CODE is set via --dart-define
      final Role role =
          (adminCode != null &&
              adminCode.isNotEmpty &&
              adminSecretCode.isNotEmpty &&
              adminCode == adminSecretCode)
          ? Role.admin
          : Role.user;

      // Create Firebase Auth user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user == null) return null;

      final uid = credential.user!.uid;

      // Create user profile in Firestore
      final user = User(
        id: uid,
        email: email.trim(),
        displayName: displayName,
        role: role,
        salaryType: SalaryType.hourly,
        currency: Currency.lei,
      );

      await _firestore.collection('users').doc(uid).set(user.toFirestore());

      return user;
    } on firebase_auth.FirebaseAuthException {
      rethrow;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.signOut();
    } catch (_) {
      // Ignore Google Sign-In sign out errors
    }
    await _auth.signOut();
  }

  /// Sign in with Google (auto-registers new users)
  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn.instance;

    // Authenticate with Google
    GoogleSignInAccount? googleUser;
    if (googleSignIn.supportsAuthenticate()) {
      googleUser = await googleSignIn.authenticate();
    } else {
      // For platforms that don't support authenticate, try lightweight auth
      googleUser = await googleSignIn.attemptLightweightAuthentication();
    }

    if (googleUser == null) return null; // User cancelled

    // Get authentication token (idToken)
    // Note: google_sign_in v7.x only provides idToken, not accessToken
    final googleAuth = googleUser.authentication;

    // Create Firebase credential with ID token
    final credential = firebase_auth.GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final firebaseUser = userCredential.user;
    if (firebaseUser == null) return null;

    // Auto-register: Get existing profile or create new one
    var user = await getUserProfile(firebaseUser.uid);
    if (user == null) {
      // New user - create default profile
      user = User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName,
        role: Role.user,
        salaryType: SalaryType.hourly,
        currency: Currency.lei,
      );
      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(user.toFirestore());
    }
    return user;
  }

  /// Get user profile from Firestore
  Future<User?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return User.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Stream user profile for real-time updates
  Stream<User?> getUserProfileStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return User.fromFirestore(doc);
      }
      return null;
    });
  }

  /// Update user profile in Firestore
  Future<void> updateUserProfile(User user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .update(user.toFirestoreUpdate());
  }

  /// Update FCM token for push notifications
  Future<void> updateFcmToken(String userId, String? token) async {
    if (token != null) {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
      });
    } else {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': FieldValue.delete(),
      });
    }
  }

  /// Update notification preferences
  Future<void> updateNotificationPrefs(
    String userId,
    NotificationPrefs prefs,
  ) async {
    await _firestore.collection('users').doc(userId).update({
      'notificationPrefs': prefs.toJson(),
    });
  }

  /// Get all users (admin only)
  Future<List<User>> getAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
  }

  /// Stream all users (admin only)
  Stream<List<User>> getAllUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
    });
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Ban a user (admin only)
  Future<void> banUser(String userId, {String? reason}) async {
    await _firestore.collection('users').doc(userId).update({
      'banned': true,
      'bannedAt': FieldValue.serverTimestamp(),
      'bannedReason': ?reason,
    });
  }

  /// Unban a user (admin only)
  Future<void> unbanUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'banned': false,
      'bannedAt': FieldValue.delete(),
      'bannedReason': FieldValue.delete(),
    });
  }

  /// Delete a user completely (admin only)
  /// This only deletes the Firestore profile, not the Firebase Auth account
  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  /// Translate Firebase Auth error codes to user-friendly messages
  static String getErrorMessage(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak (min 6 characters)';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'invalid-credential':
        return 'Invalid email or password';
      default:
        return e.message ?? 'Authentication failed';
    }
  }
}
