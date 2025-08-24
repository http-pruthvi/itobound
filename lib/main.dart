import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';
import 'core/app.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Initialize Hive for local storage
    await Hive.initFlutter();
    
    // Request permissions
    await _requestPermissions();
    
    // Initialize notification service
    await NotificationService.initialize();
  } catch (e) {
    print('Initialization error: $e');
    // Continue anyway for demo purposes
  }
  
  runApp(
    const ProviderScope(
      child: ItoBoundApp(),
    ),
  );
}

Future<void> _requestPermissions() async {
  await [
    Permission.camera,
    Permission.microphone,
    Permission.photos,
    Permission.location,
    Permission.notification,
  ].request();
}