import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

Future<void> uploadDummyProfiles() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final String data = await rootBundle.loadString('dummy_profiles.json');
  final List<dynamic> profiles = json.decode(data);

  for (final profile in profiles) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(profile['uid'])
        .set(profile);
  }
}

// To use: call uploadDummyProfiles() from main() or a debug button.
