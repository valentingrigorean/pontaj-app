import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

/// Service for Firebase Storage operations.
class StorageService {
  final FirebaseStorage _storage;

  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  /// Upload a file to Firebase Storage.
  /// Returns the download URL.
  Future<String> uploadFile({
    required String path,
    required Uint8List data,
    String? contentType,
  }) async {
    final ref = _storage.ref(path);

    final metadata = contentType != null
        ? SettableMetadata(contentType: contentType)
        : null;

    await ref.putData(data, metadata);
    return await ref.getDownloadURL();
  }

  /// Delete a file from Firebase Storage.
  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref(path).delete();
    } catch (e) {
      // Ignore if file doesn't exist
    }
  }

  /// Get download URL for a file.
  Future<String?> getDownloadUrl(String path) async {
    try {
      return await _storage.ref(path).getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  /// Check if a file exists.
  Future<bool> fileExists(String path) async {
    try {
      await _storage.ref(path).getMetadata();
      return true;
    } catch (e) {
      return false;
    }
  }
}
