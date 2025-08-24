// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryModel _$StoryModelFromJson(Map<String, dynamic> json) => StoryModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      type: $enumDecode(_$StoryTypeEnumMap, json['type']),
      mediaUrl: json['mediaUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      viewedBy:
          (json['viewedBy'] as List<dynamic>).map((e) => e as String).toList(),
      backgroundColor: json['backgroundColor'] as String?,
      textColor: json['textColor'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isHighlight: json['isHighlight'] as bool,
      highlightTitle: json['highlightTitle'] as String?,
    );

Map<String, dynamic> _$StoryModelToJson(StoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'content': instance.content,
      'type': _$StoryTypeEnumMap[instance.type]!,
      'mediaUrl': instance.mediaUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'viewedBy': instance.viewedBy,
      'backgroundColor': instance.backgroundColor,
      'textColor': instance.textColor,
      'metadata': instance.metadata,
      'isHighlight': instance.isHighlight,
      'highlightTitle': instance.highlightTitle,
    };

const _$StoryTypeEnumMap = {
  StoryType.image: 'image',
  StoryType.video: 'video',
  StoryType.text: 'text',
};
