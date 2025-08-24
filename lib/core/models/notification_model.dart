import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

enum NotificationType {
  like,
  comment,
  follow,
  match,
  message,
  superLike,
  boost,
  storyView,
  mention,
  system,
}

@JsonSerializable()
class NotificationModel {
  final String id;
  final String userId; // Recipient
  final String? fromUserId; // Sender
  final NotificationType type;
  final String title;
  final String body;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data; // Additional data like postId, matchId, etc.

  const NotificationModel({
    required this.id,
    required this.userId,
    this.fromUserId,
    required this.type,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.createdAt,
    required this.isRead,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? fromUserId,
    NotificationType? type,
    String? title,
    String? body,
    String? imageUrl,
    DateTime? createdAt,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fromUserId: fromUserId ?? this.fromUserId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }
}