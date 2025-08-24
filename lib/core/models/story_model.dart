import 'package:json_annotation/json_annotation.dart';

part 'story_model.g.dart';

enum StoryType {
  image,
  video,
  text,
}

@JsonSerializable()
class StoryModel {
  final String id;
  final String userId;
  final String content;
  final StoryType type;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final DateTime createdAt;
  final DateTime expiresAt;
  final List<String> viewedBy;
  final String? backgroundColor;
  final String? textColor;
  final Map<String, dynamic>? metadata;
  final bool isHighlight;
  final String? highlightTitle;

  const StoryModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.type,
    this.mediaUrl,
    this.thumbnailUrl,
    required this.createdAt,
    required this.expiresAt,
    required this.viewedBy,
    this.backgroundColor,
    this.textColor,
    this.metadata,
    required this.isHighlight,
    this.highlightTitle,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoryModelToJson(this);

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool hasViewedBy(String userId) => viewedBy.contains(userId);
  int get viewsCount => viewedBy.length;

  StoryModel copyWith({
    String? id,
    String? userId,
    String? content,
    StoryType? type,
    String? mediaUrl,
    String? thumbnailUrl,
    DateTime? createdAt,
    DateTime? expiresAt,
    List<String>? viewedBy,
    String? backgroundColor,
    String? textColor,
    Map<String, dynamic>? metadata,
    bool? isHighlight,
    String? highlightTitle,
  }) {
    return StoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      type: type ?? this.type,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      viewedBy: viewedBy ?? this.viewedBy,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      metadata: metadata ?? this.metadata,
      isHighlight: isHighlight ?? this.isHighlight,
      highlightTitle: highlightTitle ?? this.highlightTitle,
    );
  }
}