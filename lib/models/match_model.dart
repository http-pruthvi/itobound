import 'package:cloud_firestore/cloud_firestore.dart';

/// MatchModel represents a match between two users in ItoBound.
class MatchModel {
  final String matchId;
  final String userA;
  final String userB;
  final double compatibilityScore;
  final Timestamp matchedAt;

  MatchModel({
    required this.matchId,
    required this.userA,
    required this.userB,
    required this.compatibilityScore,
    required this.matchedAt,
  });

  /// Converts Firestore document to MatchModel
  factory MatchModel.fromJson(Map<String, dynamic> json) => MatchModel(
    matchId: json['matchId'] as String,
    userA: json['userA'] as String,
    userB: json['userB'] as String,
    compatibilityScore: (json['compatibilityScore'] as num).toDouble(),
    matchedAt: json['matchedAt'] as Timestamp,
  );

  /// Converts MatchModel to JSON for Firestore
  Map<String, dynamic> toJson() => {
    'matchId': matchId,
    'userA': userA,
    'userB': userB,
    'compatibilityScore': compatibilityScore,
    'matchedAt': matchedAt,
  };
}
