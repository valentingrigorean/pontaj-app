import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Service for Firebase Cloud Messaging (FCM) notifications.
class NotificationService {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;

  NotificationService({
    FirebaseMessaging? messaging,
    FirebaseFirestore? firestore,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Initialize FCM and request permissions.
  Future<void> initialize() async {
    // Request permission (iOS/web)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('FCM: User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('FCM: User granted provisional permission');
    } else {
      debugPrint('FCM: User declined permission');
      return;
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background message tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Check if app was opened from a notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  /// Get and save FCM token for the user.
  Future<String?> getAndSaveToken(String userId) async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _saveTokenToFirestore(userId, token);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        _saveTokenToFirestore(userId, newToken);
      });

      return token;
    } catch (e) {
      debugPrint('FCM: Error getting token: $e');
      return null;
    }
  }

  /// Save FCM token to user's Firestore document.
  Future<void> _saveTokenToFirestore(String userId, String token) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
      });
      debugPrint('FCM: Token saved for user $userId');
    } catch (e) {
      debugPrint('FCM: Error saving token: $e');
    }
  }

  /// Remove FCM token on logout.
  Future<void> removeToken(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': FieldValue.delete(),
      });
      await _messaging.deleteToken();
    } catch (e) {
      debugPrint('FCM: Error removing token: $e');
    }
  }

  /// Send invoice notification to a user.
  /// Note: In production, this should be done via Cloud Functions.
  /// This method just prepares the data - actual sending is via FCM.
  Future<void> sendInvoiceNotification({
    required String userId,
    required String invoiceNumber,
    required String amount,
  }) async {
    // In a real app, this would trigger a Cloud Function
    // that sends the FCM message to the user's device.
    // For now, we just log the intent.
    debugPrint(
      'FCM: Would send invoice notification to $userId: '
      '$invoiceNumber for $amount',
    );

    // Store notification in Firestore for Cloud Function to process
    await _firestore.collection('notifications').add({
      'type': 'invoice_created',
      'userId': userId,
      'title': 'New Invoice',
      'body': 'Invoice $invoiceNumber for $amount is ready',
      'data': {
        'invoiceNumber': invoiceNumber,
        'amount': amount,
      },
      'createdAt': FieldValue.serverTimestamp(),
      'processed': false,
    });
  }

  /// Send reminder notification to a user.
  Future<void> sendReminder({
    required String userId,
    required String message,
  }) async {
    debugPrint('FCM: Would send reminder to $userId: $message');

    await _firestore.collection('notifications').add({
      'type': 'reminder',
      'userId': userId,
      'title': 'Reminder',
      'body': message,
      'createdAt': FieldValue.serverTimestamp(),
      'processed': false,
    });
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('FCM: Foreground message received');
    debugPrint('FCM: Title: ${message.notification?.title}');
    debugPrint('FCM: Body: ${message.notification?.body}');
    debugPrint('FCM: Data: ${message.data}');

    // TODO: Show in-app notification or update UI
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('FCM: App opened from notification');
    debugPrint('FCM: Data: ${message.data}');

    // TODO: Navigate to relevant screen based on message data
    // e.g., if message.data['invoiceId'] exists, navigate to invoice detail
  }

  /// Subscribe to a topic (e.g., 'admin' for admin-only notifications).
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}
