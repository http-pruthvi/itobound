import 'package:cloud_firestore/cloud_firestore.dart';

/// MessageModel represents a chat message between users in ItoBound.
class MessageModel {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String? text;
  final String? imageUrl;
  final String? voiceUrl;
  final Timestamp sentAt;
  final bool isRead;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    this.text,
    this.imageUrl,
    this.voiceUrl,
    required this.sentAt,
    required this.isRead,
  });

  /// Converts Firestore document to MessageModel
  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    messageId: json['messageId'] as String,
    senderId: json['senderId'] as String,
    receiverId: json['receiverId'] as String,
    text: json['text'] as String?,
    imageUrl: json['imageUrl'] as String?,
    voiceUrl: json['voiceUrl'] as String?,
    sentAt: json['sentAt'] as Timestamp,
    isRead: json['isRead'] as bool,
  );

  /// Converts MessageModel to JSON for Firestore
  Map<String, dynamic> toJson() => {
    'messageId': messageId,
    'senderId': senderId,
    'receiverId': receiverId,
    'text': text,
    'imageUrl': imageUrl,
    'voiceUrl': voiceUrl,
    'sentAt': sentAt,
    'isRead': isRead,
  };
}
