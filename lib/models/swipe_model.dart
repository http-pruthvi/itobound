import 'package:cloud_firestore/cloud_firestore.dart';

/// SwipeModel represents a swipe action (like/dislike/super connect) in ItoBound.
class SwipeModel {
  final String swipeId;
  final String swiperId;
  final String targetId;
  final String action; // 'like', 'dislike', 'super_connect'
  final Timestamp swipedAt;

  SwipeModel({
    required this.swipeId,
    required this.swiperId,
    required this.targetId,
    required this.action,
    required this.swipedAt,
  });

  /// Converts Firestore document to SwipeModel
  factory SwipeModel.fromJson(Map<String, dynamic> json) => SwipeModel(
    swipeId: json['swipeId'] as String,
    swiperId: json['swiperId'] as String,
    targetId: json['targetId'] as String,
    action: json['action'] as String,
    swipedAt: json['swipedAt'] as Timestamp,
  );

  /// Converts SwipeModel to JSON for Firestore
  Map<String, dynamic> toJson() => {
    'swipeId': swipeId,
    'swiperId': swiperId,
    'targetId': targetId,
    'action': action,
    'swipedAt': swipedAt,
  };
}
