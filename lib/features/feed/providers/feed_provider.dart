import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:io';
import '../../../core/models/post_model.dart';
import '../../../core/services/post_service.dart';
import '../../../core/providers/auth_provider.dart';

part 'feed_provider.g.dart';

@riverpod
PostService postService(PostServiceRef ref) {
  return PostService();
}

@riverpod
Stream<List<PostModel>> feedPosts(FeedPostsRef ref) {
  final postService = ref.watch(postServiceProvider);
  return postService.getPostsFeed(limit: 20);
}

@riverpod
Stream<List<PostModel>> userPosts(UserPostsRef ref, String userId) {
  final postService = ref.watch(postServiceProvider);
  return postService.getUserPosts(userId);
}

@riverpod
class FeedNotifier extends _$FeedNotifier {
  @override
  FutureOr<void> build() {
    // Initialize feed state
  }

  Future<void> likePost(String postId) async {
    final currentUser = ref.read(authNotifierProvider).value;
    if (currentUser == null) return;

    try {
      await ref.read(postServiceProvider).toggleLike(postId, currentUser.uid);
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }

  Future<String> createPost({
    required String caption,
    required PostType type,
    required List<File> mediaFiles,
    List<String> tags = const [],
    String? location,
    double? latitude,
    double? longitude,
  }) async {
    final currentUser = ref.read(authNotifierProvider).value;
    if (currentUser == null) throw Exception('User not authenticated');

    try {
      final post = await ref.read(postServiceProvider).createPost(
        userId: currentUser.uid,
        caption: caption,
        type: type,
        mediaFiles: mediaFiles,
        tags: tags,
        location: location,
        latitude: latitude,
        longitude: longitude,
      );
      
      return post.id;
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  Future<String> addComment({
    required String postId,
    required String content,
    String? parentCommentId,
  }) async {
    final currentUser = ref.read(authNotifierProvider).value;
    if (currentUser == null) throw Exception('User not authenticated');

    try {
      final comment = await ref.read(postServiceProvider).addComment(
        postId: postId,
        userId: currentUser.uid,
        content: content,
        parentCommentId: parentCommentId,
      );
      
      return comment.id;
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<void> deletePost(String postId) async {
    final currentUser = ref.read(authNotifierProvider).value;
    if (currentUser == null) return;

    try {
      await ref.read(postServiceProvider).deletePost(postId, currentUser.uid);
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  Future<List<PostModel>> searchPosts(String query) async {
    try {
      return await ref.read(postServiceProvider).searchPosts(query);
    } catch (e) {
      throw Exception('Failed to search posts: $e');
    }
  }

  Future<void> incrementViewCount(String postId) async {
    try {
      await ref.read(postServiceProvider).incrementViewCount(postId);
    } catch (e) {
      // Silently fail for view count increment
      print('Failed to increment view count: $e');
    }
  }
}

