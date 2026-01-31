import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/config/env.dart';
import '../../core/platform/web_platform.dart';
import '../models/enums.dart';
import '../models/user.dart';

class FirebaseAuthRepository {
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static String get adminSecretCode => Env.adminCode;

  FirebaseAuthRepository({
    firebase_auth.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _auth = auth ?? firebase_auth.FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  firebase_auth.User? get currentFirebaseUser => _auth.currentUser;

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

  Future<User?> register(
    String email,
    String password, {
    String? adminCode,
    String? displayName,
  }) async {
    try {
      final Role role =
          (adminCode != null &&
              adminCode.isNotEmpty &&
              adminSecretCode.isNotEmpty &&
              adminCode == adminSecretCode)
          ? Role.admin
          : Role.user;

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user == null) return null;

      final uid = credential.user!.uid;
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

  Future<void> signOut() async {
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  Future<User?> signInWithGoogle() async {
    firebase_auth.UserCredential userCredential;

    if (kIsWeb) {
      final provider = firebase_auth.GoogleAuthProvider();

      if (isMobileWebBrowser()) {
        await _auth.signInWithRedirect(provider);
        return null;
      } else {
        userCredential = await _auth.signInWithPopup(provider);
      }
    } else {
      final googleSignIn = GoogleSignIn.instance;
      GoogleSignInAccount? googleUser;

      if (googleSignIn.supportsAuthenticate()) {
        googleUser = await googleSignIn.authenticate();
      } else {
        googleUser = await googleSignIn.attemptLightweightAuthentication();
        if (googleUser == null) {
          throw Exception('Google Sign-In not supported on this platform');
        }
      }

      final googleAuth = googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      userCredential = await _auth.signInWithCredential(credential);
    }

    return _processGoogleSignInResult(userCredential);
  }

  Future<User?> getGoogleRedirectResult() async {
    if (!kIsWeb) return null;

    final userCredential = await _auth.getRedirectResult();
    if (userCredential.user == null) return null;

    return _processGoogleSignInResult(userCredential);
  }

  Future<User?> _processGoogleSignInResult(
    firebase_auth.UserCredential userCredential,
  ) async {
    final firebaseUser = userCredential.user;
    if (firebaseUser == null) return null;

    var user = await getUserProfile(firebaseUser.uid);
    if (user == null) {
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

  Stream<User?> getUserProfileStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return User.fromFirestore(doc);
      }
      return null;
    });
  }

  Future<void> updateUserProfile(User user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .update(user.toFirestoreUpdate());
  }

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

  Future<void> updateNotificationPrefs(
    String userId,
    NotificationPrefs prefs,
  ) async {
    await _firestore.collection('users').doc(userId).update({
      'notificationPrefs': prefs.toJson(),
    });
  }

  Future<List<User>> getAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
  }

  Stream<List<User>> getAllUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
    });
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> banUser(String userId, {String? reason}) async {
    await _firestore.collection('users').doc(userId).update({
      'banned': true,
      'bannedAt': FieldValue.serverTimestamp(),
      'bannedReason': ?reason,
    });
  }

  Future<void> unbanUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'banned': false,
      'bannedAt': FieldValue.delete(),
      'bannedReason': FieldValue.delete(),
    });
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

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
