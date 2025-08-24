import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/match_model.dart';
import '../../../core/models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _matchesCollection = 'matches';
  final String _messagesCollection = 'messages';

  Future<List<MatchModel>> getUserMatches(String userId) async {
    final snapshot = await _firestore
        .collection(_matchesCollection)
        .where('isActive', isEqualTo: true)
        .where('user1Unmatched', isEqualTo: false)
        .where('user2Unmatched', isEqualTo: false)
        .get();

    return snapshot.docs
        .map((doc) => MatchModel.fromJson(doc.data()))
        .where((match) => match.user1Id == userId || match.user2Id == userId)
        .toList();
  }

  Future<List<MatchModel>> getUserConversations(String userId) async {
    final matches = await getUserMatches(userId);
    
    // Filter matches that have messages
    final conversationsWithMessages = <MatchModel>[];
    for (final match in matches) {
      final hasMessages = await _hasMessages(match.id);
      if (hasMessages) {
        conversationsWithMessages.add(match);
      }
    }
    
    // Sort by last message time
    conversationsWithMessages.sort((a, b) {
      if (a.lastMessageAt == null && b.lastMessageAt == null) return 0;
      if (a.lastMessageAt == null) return 1;
      if (b.lastMessageAt == null) return -1;
      return b.lastMessageAt!.compareTo(a.lastMessageAt!);
    });
    
    return conversationsWithMessages;
  }

  Future<bool> _hasMessages(String matchId) async {
    final snapshot = await _firestore
        .collection(_messagesCollection)
        .where('matchId', isEqualTo: matchId)
        .limit(1)
        .get();
    
    return snapshot.docs.isNotEmpty;
  }

  Stream<List<MessageModel>> getMessagesStream(String matchId) {
    return _firestore
        .collection(_messagesCollection)
        .where('matchId', isEqualTo: matchId)
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList());
  }

  Future<void> sendMessage({
    required String matchId,
    required String senderId,
    required String receiverId,
    required String content,
    MessageType type = MessageType.text,
    String? mediaUrl,
  }) async {
    final messageId = const Uuid().v4();
    final now = DateTime.now();

    final message = MessageModel(
      id: messageId,
      matchId: matchId,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      type: type,
      sentAt: now,
      isDelivered: true,
      isRead: false,
      mediaUrl: mediaUrl,
    );

    final batch = _firestore.batch();

    // Add message
    batch.set(
      _firestore.collection(_messagesCollection).doc(messageId),
      message.toJson(),
    );

    // Update match with last message info
    batch.update(
      _firestore.collection(_matchesCollection).doc(matchId),
      {
        'lastMessageId': messageId,
        'lastMessageAt': FieldValue.serverTimestamp(),
      },
    );

    await batch.commit();
  }

  Future<void> markMessagesAsRead(String matchId, String userId) async {
    final snapshot = await _firestore
        .collection(_messagesCollection)
        .where('matchId', isEqualTo: matchId)
        .where('receiverId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  Future<void> deleteMessage(String messageId) async {
    await _firestore.collection(_messagesCollection).doc(messageId).delete();
  }

  Future<void> unmatch(String matchId, String userId) async {
    final match = await _firestore
        .collection(_matchesCollection)
        .doc(matchId)
        .get();

    if (!match.exists) return;

    final matchData = MatchModel.fromJson(match.data()!);
    
    final updateData = <String, dynamic>{};
    if (matchData.user1Id == userId) {
      updateData['user1Unmatched'] = true;
    } else {
      updateData['user2Unmatched'] = true;
    }

    // If both users unmatched, deactivate the match
    if ((matchData.user1Unmatched && matchData.user2Id == userId) ||
        (matchData.user2Unmatched && matchData.user1Id == userId)) {
      updateData['isActive'] = false;
    }

    await _firestore
        .collection(_matchesCollection)
        .doc(matchId)
        .update(updateData);
  }
}