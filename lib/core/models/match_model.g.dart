// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchModel _$MatchModelFromJson(Map<String, dynamic> json) => MatchModel(
      id: json['id'] as String,
      user1Id: json['user1Id'] as String,
      user2Id: json['user2Id'] as String,
      matchedAt: DateTime.parse(json['matchedAt'] as String),
      lastMessageId: json['lastMessageId'] as String?,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      isActive: json['isActive'] as bool,
      user1LastRead: json['user1LastRead'] as String?,
      user2LastRead: json['user2LastRead'] as String?,
      user1Unmatched: json['user1Unmatched'] as bool,
      user2Unmatched: json['user2Unmatched'] as bool,
    );

Map<String, dynamic> _$MatchModelToJson(MatchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user1Id': instance.user1Id,
      'user2Id': instance.user2Id,
      'matchedAt': instance.matchedAt.toIso8601String(),
      'lastMessageId': instance.lastMessageId,
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
      'isActive': instance.isActive,
      'user1LastRead': instance.user1LastRead,
      'user2LastRead': instance.user2LastRead,
      'user1Unmatched': instance.user1Unmatched,
      'user2Unmatched': instance.user2Unmatched,
    };
