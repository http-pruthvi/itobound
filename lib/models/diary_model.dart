import 'package:cloud_firestore/cloud_firestore.dart';

/// DiaryModel represents a personal diary entry in ItoBound.
class DiaryModel {
  final String diaryId;
  final String userId;
  final String content;
  final Timestamp createdAt;
  final bool isEncrypted;

  DiaryModel({
    required this.diaryId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.isEncrypted,
  });

  /// Converts Firestore document to DiaryModel
  factory DiaryModel.fromJson(Map<String, dynamic> json) => DiaryModel(
    diaryId: json['diaryId'] as String,
    userId: json['userId'] as String,
    content: json['content'] as String,
    createdAt: json['createdAt'] as Timestamp,
    isEncrypted: json['isEncrypted'] as bool,
  );

  /// Converts DiaryModel to JSON for Firestore
  Map<String, dynamic> toJson() => {
    'diaryId': diaryId,
    'userId': userId,
    'content': content,
    'createdAt': createdAt,
    'isEncrypted': isEncrypted,
  };
}
