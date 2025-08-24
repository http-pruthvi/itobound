import 'package:json_annotation/json_annotation.dart';

part 'match_model.g.dart';

@JsonSerializable()
class MatchModel {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime matchedAt;
  final String? lastMessageId;
  final DateTime? lastMessageAt;
  final bool isActive;
  final String? user1LastRead;
  final String? user2LastRead;
  final bool user1Unmatched;
  final bool user2Unmatched;

  const MatchModel({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.matchedAt,
    this.lastMessageId,
    this.lastMessageAt,
    required this.isActive,
    this.user1LastRead,
    this.user2LastRead,
    required this.user1Unmatched,
    required this.user2Unmatched,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) => _$MatchModelFromJson(json);
  Map<String, dynamic> toJson() => _$MatchModelToJson(this);

  MatchModel copyWith({
    String? id,
    String? user1Id,
    String? user2Id,
    DateTime? matchedAt,
    String? lastMessageId,
    DateTime? lastMessageAt,
    bool? isActive,
    String? user1LastRead,
    String? user2LastRead,
    bool? user1Unmatched,
    bool? user2Unmatched,
  }) {
    return MatchModel(
      id: id ?? this.id,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      matchedAt: matchedAt ?? this.matchedAt,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      isActive: isActive ?? this.isActive,
      user1LastRead: user1LastRead ?? this.user1LastRead,
      user2LastRead: user2LastRead ?? this.user2LastRead,
      user1Unmatched: user1Unmatched ?? this.user1Unmatched,
      user2Unmatched: user2Unmatched ?? this.user2Unmatched,
    );
  }
}