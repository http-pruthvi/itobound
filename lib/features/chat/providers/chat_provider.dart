import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/match_model.dart';
import '../../../core/models/message_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../services/chat_service.dart';

part 'chat_provider.g.dart';

@riverpod
ChatService chatService(ChatServiceRef ref) {
  return ChatService();
}

@riverpod
Future<List<MatchModel>> matches(MatchesRef ref) async {
  final currentUser = ref.watch(authNotifierProvider).value;
  if (currentUser == null) return [];

  final chatService = ref.read(chatServiceProvider);
  return await chatService.getUserMatches(currentUser.uid);
}

@riverpod
Future<List<MatchModel>> conversations(ConversationsRef ref) async {
  final currentUser = ref.watch(authNotifierProvider).value;
  if (currentUser == null) return [];

  final chatService = ref.read(chatServiceProvider);
  return await chatService.getUserConversations(currentUser.uid);
}

@riverpod
Stream<List<MessageModel>> messages(MessagesRef ref, String matchId) {
  final chatService = ref.read(chatServiceProvider);
  return chatService.getMessagesStream(matchId);
}

@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  FutureOr<void> build() {
    // Initialize chat state
  }

  Future<void> sendMessage({
    required String matchId,
    required String receiverId,
    required String content,
    MessageType type = MessageType.text,
    String? mediaUrl,
  }) async {
    final currentUser = ref.read(authNotifierProvider).value;
    if (currentUser == null) return;

    final chatService = ref.read(chatServiceProvider);
    await chatService.sendMessage(
      matchId: matchId,
      senderId: currentUser.uid,
      receiverId: receiverId,
      content: content,
      type: type,
      mediaUrl: mediaUrl,
    );
  }

  Future<void> markMessagesAsRead(String matchId) async {
    final currentUser = ref.read(authNotifierProvider).value;
    if (currentUser == null) return;

    final chatService = ref.read(chatServiceProvider);
    await chatService.markMessagesAsRead(matchId, currentUser.uid);
  }
}