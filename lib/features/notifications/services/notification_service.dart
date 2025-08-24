import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  
  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> initialize(BuildContext context) async {
    // Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
      return;
    }

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        _handleNotificationTap(response.payload, context);
      },
    );

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    _saveTokenToFirestore(token);

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen(_saveTokenToFirestore);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    // Handle background/terminated messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message.data['route'], context);
    });

    // Check for initial message (app opened from terminated state)
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage.data['route'], context);
    }
  }

  Future<void> _saveTokenToFirestore(String? token) async {
    if (token == null) return;
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'fcmTokens': FieldValue.arrayUnion([token]),
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'ito_bound_channel',
            'ItoBound Notifications',
            channelDescription: 'Notifications from ItoBound app',
            importance: Importance.max,
            priority: Priority.high,
            icon: android.smallIcon,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data['route'],
      );
    }
  }

  void _handleNotificationTap(String? route, BuildContext context) {
    if (route == null || route.isEmpty) return;

    // Parse the route and navigate accordingly
    // This is a simple example, you might want to use a more sophisticated routing system
    if (route.startsWith('/chat/')) {
      final matchId = route.substring(6);
      // Navigate to chat page with matchId
      // Navigator.pushNamed(context, '/chat', arguments: {'matchId': matchId});
    } else if (route == '/matches') {
      // Navigate to matches page
      // Navigator.pushNamed(context, '/matches');
    }
    // Add more route handlers as needed
  }

  // Subscribe to topic for targeted notifications
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  // Method to handle sending notifications (typically called from server/cloud functions)
  // This is just for reference, actual implementation would be in Firebase Cloud Functions
  static Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    String? route,
    Map<String, dynamic>? data,
  }) async {
    // Get user's FCM tokens
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final tokens = List<String>.from(userDoc.data()?['fcmTokens'] ?? []);

    if (tokens.isEmpty) return;

    // Prepare notification data
    final notificationData = {
      'title': title,
      'body': body,
      'route': route,
      ...?data,
    };

    // In a real implementation, you would call a Cloud Function to send the notification
    // This is just a placeholder to show the concept
    print('Would send notification to tokens: $tokens with data: $notificationData');
  }
}