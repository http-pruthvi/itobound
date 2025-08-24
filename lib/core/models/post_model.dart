import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

enum PostType {
  image,
  video,
  carousel,
  text,
}

@JsonSerializable()
class PostModel {
  final String id;
  final String userId;
  final String caption;
  final PostType type;
  final List<String> mediaUrls;
  final String? thumbnailUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> likedBy;
  final List<CommentModel> comments;
  final int viewCount;
  final bool isPublic;
  final List<String> tags;
  final String? location;
  final double? latitude;
  final double? longitude;
  final Map<String, dynamic>? metadata;

  const PostModel({
    required this.id,
    required this.userId,
    required this.caption,
    required this.type,
    required this.mediaUrls,
    this.thumbnailUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.likedBy,
    required this.comments,
    required this.viewCount,
    required this.isPublic,
    required this.tags,
    this.location,
    this.latitude,
    this.longitude,
    this.metadata,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  int get likesCount => likedBy.length;
  int get commentsCount => comments.length;
  bool isLikedBy(String userId) => likedBy.contains(userId);

  PostModel copyWith({
    String? id,
    String? userId,
    String? caption,
    PostType? type,
    List<String>? mediaUrls,
    String? thumbnailUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? likedBy,
    List<CommentModel>? comments,
    int? viewCount,
    bool? isPublic,
    List<String>? tags,
    String? location,
    double? latitude,
    double? longitude,
    Map<String, dynamic>? metadata,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      caption: caption ?? this.caption,
      type: type ?? this.type,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likedBy: likedBy ?? this.likedBy,
      comments: comments ?? this.comments,
      viewCount: viewCount ?? this.viewCount,
      isPublic: isPublic ?? this.isPublic,
      tags: tags ?? this.tags,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      metadata: metadata ?? this.metadata,
    );
  }
}

@JsonSerializable()
class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String content;
  final DateTime createdAt;
  final List<String> likedBy;
  final String? parentCommentId; // For replies

  const CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.likedBy,
    this.parentCommentId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  int get likesCount => likedBy.length;
  bool isLikedBy(String userId) => likedBy.contains(userId);
  bool get isReply => parentCommentId != null;

  CommentModel copyWith({
    String? id,
    String? postId,
    String? userId,
    String? content,
    DateTime? createdAt,
    List<String>? likedBy,
    String? parentCommentId,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likedBy: likedBy ?? this.likedBy,
      parentCommentId: parentCommentId ?? this.parentCommentId,
    );
  }
}