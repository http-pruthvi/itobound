import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

enum MessageType {
  text,
  image,
  video,
  audio,
  gif,
  sticker,
  location,
  contact,
}

@JsonSerializable()
class MessageModel {
  final String id;
  final String matchId;
  final String senderId;
  final String receiverId;
  final String content;
  final MessageType type;
  final DateTime sentAt;
  final DateTime? readAt;
  final bool isDelivered;
  final bool isRead;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final Map<String, dynamic>? metadata;

  const MessageModel({
    required this.id,
    required this.matchId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.type,
    required this.sentAt,
    this.readAt,
    required this.isDelivered,
    required this.isRead,
    this.mediaUrl,
    this.thumbnailUrl,
    this.metadata,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  MessageModel copyWith({
    String? id,
    String? matchId,
    String? senderId,
    String? receiverId,
    String? content,
    MessageType? type,
    DateTime? sentAt,
    DateTime? readAt,
    bool? isDelivered,
    bool? isRead,
    String? mediaUrl,
    String? thumbnailUrl,
    Map<String, dynamic>? metadata,
  }) {
    return MessageModel(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      type: type ?? this.type,
      sentAt: sentAt ?? this.sentAt,
      readAt: readAt ?? this.readAt,
      isDelivered: isDelivered ?? this.isDelivered,
      isRead: isRead ?? this.isRead,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}