import 'package:cloud_firestore/cloud_firestore.dart';

/// SuccessStoryModel represents a success story shared by users in ItoBound.
class SuccessStoryModel {
  final String storyId;
  final String userA;
  final String userB;
  final String storyText;
  final List<String> mediaUrls;
  final Timestamp sharedAt;

  SuccessStoryModel({
    required this.storyId,
    required this.userA,
    required this.userB,
    required this.storyText,
    required this.mediaUrls,
    required this.sharedAt,
  });

  /// Converts Firestore document to SuccessStoryModel
  factory SuccessStoryModel.fromJson(Map<String, dynamic> json) =>
      SuccessStoryModel(
        storyId: json['storyId'] as String,
        userA: json['userA'] as String,
        userB: json['userB'] as String,
        storyText: json['storyText'] as String,
        mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
        sharedAt: json['sharedAt'] as Timestamp,
      );

  /// Converts SuccessStoryModel to JSON for Firestore
  Map<String, dynamic> toJson() => {
    'storyId': storyId,
    'userA': userA,
    'userB': userB,
    'storyText': storyText,
    'mediaUrls': mediaUrls,
    'sharedAt': sharedAt,
  };
}
