import 'package:cloud_firestore/cloud_firestore.dart';

/// UserModel represents a user in the ItoBound dating app.
class UserModel {
  final String uid;
  final String name;
  final String bio;
  final int age;
  final String gender;
  final List<String> photos;
  final String? videoIntroUrl;
  final String? voiceIntroUrl;
  final String zodiacSign;
  final List<String> interests;
  final Map<String, dynamic> preferences;
  final Timestamp createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.bio,
    required this.age,
    required this.gender,
    required this.photos,
    this.videoIntroUrl,
    this.voiceIntroUrl,
    required this.zodiacSign,
    required this.interests,
    required this.preferences,
    required this.createdAt,
  });

  /// Converts Firestore document to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'] as String,
    name: json['name'] as String,
    bio: json['bio'] as String,
    age: json['age'] as int,
    gender: json['gender'] as String,
    photos: List<String>.from(json['photos'] ?? []),
    videoIntroUrl: json['videoIntroUrl'] as String?,
    voiceIntroUrl: json['voiceIntroUrl'] as String?,
    zodiacSign: json['zodiacSign'] as String,
    interests: List<String>.from(json['interests'] ?? []),
    preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
    createdAt: json['createdAt'] as Timestamp,
  );

  /// Converts UserModel to JSON for Firestore
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'bio': bio,
    'age': age,
    'gender': gender,
    'photos': photos,
    'videoIntroUrl': videoIntroUrl,
    'voiceIntroUrl': voiceIntroUrl,
    'zodiacSign': zodiacSign,
    'interests': interests,
    'preferences': preferences,
    'createdAt': createdAt,
  };
}
