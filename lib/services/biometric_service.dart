import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Biometric authentication service for fingerprint/face recognition
class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();

  final LocalAuthentication _auth = LocalAuthentication();

  /// Check if device supports biometric authentication
  Future<bool> isBiometricAvailable() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  /// Check if device is capable of authentication
  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Authenticate with biometrics
  Future<BiometricResult> authenticate({
    String reason = 'Please authenticate to access Pontaj PRO',
    bool useErrorDialogs = true,
    bool stickyAuth = true,
  }) async {
    try {
      // Check if biometrics are available
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return BiometricResult(
          success: false,
          message: 'Biometric authentication not available on this device',
        );
      }

      // Check available biometric types
      final availableBiometrics = await getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        return BiometricResult(
          success: false,
          message: 'No biometric methods enrolled. Please set up fingerprint or face recognition.',
        );
      }

      // Attempt authentication
      final authenticated = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );

      if (authenticated) {
        return BiometricResult(
          success: true,
          message: 'Authentication successful',
        );
      } else {
        return BiometricResult(
          success: false,
          message: 'Authentication failed',
        );
      }

    } on PlatformException catch (e) {
      return _handleError(e);
    } catch (e) {
      return BiometricResult(
        success: false,
        message: 'Unexpected error: $e',
      );
    }
  }

  BiometricResult _handleError(PlatformException e) {
    String message;

    switch (e.code) {
      case 'NotAvailable':
      case 'notAvailable':
        message = 'Biometric authentication not available';
        break;
      case 'NotEnrolled':
      case 'notEnrolled':
        message = 'No biometrics enrolled. Please set up fingerprint or face recognition.';
        break;
      case 'PasscodeNotSet':
      case 'passcodeNotSet':
        message = 'Please set up a passcode on your device first';
        break;
      case 'LockedOut':
      case 'lockedOut':
        message = 'Too many failed attempts. Please try again later.';
        break;
      case 'PermanentlyLockedOut':
      case 'permanentlyLockedOut':
        message = 'Biometric authentication permanently locked. Please use passcode.';
        break;
      default:
        message = 'Authentication error: ${e.message}';
    }

    return BiometricResult(
      success: false,
      message: message,
      errorCode: e.code,
    );
  }

  /// Get a human-readable description of available biometrics
  Future<String> getBiometricDescription() async {
    final biometrics = await getAvailableBiometrics();

    if (biometrics.isEmpty) {
      return 'No biometric authentication available';
    }

    final types = <String>[];
    for (final biometric in biometrics) {
      switch (biometric) {
        case BiometricType.face:
          types.add('Face Recognition');
          break;
        case BiometricType.fingerprint:
          types.add('Fingerprint');
          break;
        case BiometricType.iris:
          types.add('Iris Scanner');
          break;
        case BiometricType.strong:
          types.add('Strong Biometric');
          break;
        case BiometricType.weak:
          types.add('Weak Biometric');
          break;
      }
    }

    return types.join(', ');
  }

  /// Stop ongoing authentication
  Future<void> stopAuthentication() async {
    try {
      await _auth.stopAuthentication();
    } catch (e) {
      // Ignore errors
    }
  }
}

/// Result of biometric authentication attempt
class BiometricResult {
  final bool success;
  final String message;
  final String? errorCode;

  BiometricResult({
    required this.success,
    required this.message,
    this.errorCode,
  });
}
