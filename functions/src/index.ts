import * as admin from "firebase-admin";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { logger } from "firebase-functions";

// Initialize Firebase Admin SDK
admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

/**
 * Cloud Function that triggers on new notification documents
 * and sends FCM push notifications to the target user.
 * Supports multiple devices (web + mobile) by sending to all stored tokens.
 */
export const sendNotification = onDocumentCreated(
  "notifications/{notificationId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      logger.error("No data associated with the event");
      return;
    }

    const notificationId = event.params.notificationId;
    const data = snapshot.data();

    // Skip if already processed
    if (data.processed === true) {
      logger.info(`Notification ${notificationId} already processed, skipping`);
      return;
    }

    const userId = data.userId as string;
    const title = data.title as string;
    const body = data.body as string;
    const notificationData = data.data as Record<string, string> | undefined;

    logger.info(`Processing notification ${notificationId} for user ${userId}`);

    try {
      // Get user's FCM tokens from Firestore
      const userDoc = await db.collection("users").doc(userId).get();

      if (!userDoc.exists) {
        throw new Error(`User ${userId} not found`);
      }

      const userData = userDoc.data();
      const fcmTokens = userData?.fcmTokens as string[] | undefined;

      if (!fcmTokens || fcmTokens.length === 0) {
        throw new Error(`No FCM tokens for user ${userId}`);
      }

      logger.info(`Found ${fcmTokens.length} token(s) for user ${userId}`);

      // Build the base message payload
      const messagePayload = {
        notification: {
          title: title,
          body: body,
        },
        data: notificationData ? {
          ...notificationData,
          type: data.type?.toString() || "",
        } : undefined,
        // iOS specific settings
        apns: {
          payload: {
            aps: {
              badge: 1,
              sound: "default",
            },
          },
        },
        // Android specific settings
        android: {
          priority: "high" as const,
          notification: {
            sound: "default",
            channelId: "invoices",
          },
        },
        // Web specific settings
        webpush: {
          notification: {
            icon: "/icons/icon-192x192.png",
          },
        },
      };

      // Send to all tokens and collect results
      const sendResults = await Promise.allSettled(
        fcmTokens.map(token =>
          messaging.send({ ...messagePayload, token })
        )
      );

      // Process results
      const successCount = sendResults.filter(r => r.status === "fulfilled").length;
      const failedTokens: string[] = [];

      sendResults.forEach((result, index) => {
        if (result.status === "rejected") {
          const error = result.reason;
          // Check if token is invalid/expired
          if (
            error.code === "messaging/invalid-registration-token" ||
            error.code === "messaging/registration-token-not-registered"
          ) {
            failedTokens.push(fcmTokens[index]);
          }
          logger.warn(`Failed to send to token ${index}: ${error.message}`);
        }
      });

      // Remove invalid tokens from user document
      if (failedTokens.length > 0) {
        logger.info(`Removing ${failedTokens.length} invalid token(s)`);
        await db.collection("users").doc(userId).update({
          fcmTokens: admin.firestore.FieldValue.arrayRemove(...failedTokens),
        });
      }

      logger.info(`FCM messages sent: ${successCount}/${fcmTokens.length} successful`);

      // Mark notification as processed
      await snapshot.ref.update({
        processed: true,
        processedAt: admin.firestore.FieldValue.serverTimestamp(),
        sentCount: successCount,
        totalTokens: fcmTokens.length,
      });

      logger.info(`Notification ${notificationId} processed successfully`);
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : String(error);
      logger.error(`Error processing notification ${notificationId}: ${errorMessage}`);

      // Update document with error status
      await snapshot.ref.update({
        processed: true,
        processedAt: admin.firestore.FieldValue.serverTimestamp(),
        error: errorMessage,
      });
    }
  }
);
