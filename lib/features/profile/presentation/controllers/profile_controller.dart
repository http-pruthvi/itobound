import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final profileControllerProvider =
    Provider<ProfileController>((ref) => ProfileController());

class ProfileController {
  final _usersRef = FirebaseFirestore.instance.collection('users');

  Future<void> saveProfile({
    required String name,
    required String bio,
    required int age,
    required String gender,
    required List photos,
    required dynamic videoIntro,
    required dynamic voiceIntro,
    required String zodiacSign,
    required List interests,
    required Map<String, dynamic> preferences,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _usersRef.doc(uid).set({
      'name': name,
      'bio': bio,
      'age': age,
      'gender': gender,
      'photos': photos,
      'videoIntro': videoIntro,
      'voiceIntro': voiceIntro,
      'zodiacSign': zodiacSign,
      'interests': interests,
      'preferences': preferences,
    }, SetOptions(merge: true));
  }
}
