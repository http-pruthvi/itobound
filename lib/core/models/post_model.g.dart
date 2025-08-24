// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      caption: json['caption'] as String,
      type: $enumDecode(_$PostTypeEnumMap, json['type']),
      mediaUrls:
          (json['mediaUrls'] as List<dynamic>).map((e) => e as String).toList(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      likedBy:
          (json['likedBy'] as List<dynamic>).map((e) => e as String).toList(),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      viewCount: (json['viewCount'] as num).toInt(),
      isPublic: json['isPublic'] as bool,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'caption': instance.caption,
      'type': _$PostTypeEnumMap[instance.type]!,
      'mediaUrls': instance.mediaUrls,
      'thumbnailUrl': instance.thumbnailUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'likedBy': instance.likedBy,
      'comments': instance.comments,
      'viewCount': instance.viewCount,
      'isPublic': instance.isPublic,
      'tags': instance.tags,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'metadata': instance.metadata,
    };

const _$PostTypeEnumMap = {
  PostType.image: 'image',
  PostType.video: 'video',
  PostType.carousel: 'carousel',
  PostType.text: 'text',
};

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      id: json['id'] as String,
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likedBy:
          (json['likedBy'] as List<dynamic>).map((e) => e as String).toList(),
      parentCommentId: json['parentCommentId'] as String?,
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'userId': instance.userId,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'likedBy': instance.likedBy,
      'parentCommentId': instance.parentCommentId,
    };
