import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../models/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _postsCollection = 'posts';
  final String _commentsCollection = 'comments';

  // Create a new post
  Future<PostModel> createPost({
    required String userId,
    required String caption,
    required PostType type,
    required List<File> mediaFiles,
    List<String> tags = const [],
    String? location,
    double? latitude,
    double? longitude,
  }) async {
    final postId = const Uuid().v4();
    final mediaUrls = <String>[];
    String? thumbnailUrl;

    // Upload media files
    for (int i = 0; i < mediaFiles.length; i++) {
      final file = mediaFiles[i];
      final fileName = '${postId}_$i.${file.path.split('.').last}';
      final ref = _storage.ref().child('posts/$userId/$fileName');
      
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      mediaUrls.add(url);
      
      // Set first image as thumbnail
      if (i == 0) thumbnailUrl = url;
    }

    final post = PostModel(
      id: postId,
      userId: userId,
      caption: caption,
      type: type,
      mediaUrls: mediaUrls,
      thumbnailUrl: thumbnailUrl,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      likedBy: [],
      comments: [],
      viewCount: 0,
      isPublic: true,
      tags: tags,
      location: location,
      latitude: latitude,
      longitude: longitude,
    );

    await _firestore.collection(_postsCollection).doc(postId).set(post.toJson());
    return post;
  }

  // Get posts feed
  Stream<List<PostModel>> getPostsFeed({
    String? userId,
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) {
    Query query = _firestore
        .collection(_postsCollection)
        .where('isPublic', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.snapshots().map((snapshot) => 
        snapshot.docs.map((doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>)).toList());
  }

  // Get user posts
  Stream<List<PostModel>> getUserPosts(String userId) {
    return _firestore
        .collection(_postsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>)).toList());
  }

  // Like/Unlike post
  Future<void> toggleLike(String postId, String userId) async {
    final postRef = _firestore.collection(_postsCollection).doc(postId);
    
    await _firestore.runTransaction((transaction) async {
      final postDoc = await transaction.get(postRef);
      if (!postDoc.exists) return;

      final post = PostModel.fromJson(postDoc.data()!);
      final likedBy = List<String>.from(post.likedBy);

      if (likedBy.contains(userId)) {
        likedBy.remove(userId);
      } else {
        likedBy.add(userId);
      }

      transaction.update(postRef, {
        'likedBy': likedBy,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // Add comment
  Future<CommentModel> addComment({
    required String postId,
    required String userId,
    required String content,
    String? parentCommentId,
  }) async {
    final commentId = const Uuid().v4();
    final comment = CommentModel(
      id: commentId,
      postId: postId,
      userId: userId,
      content: content,
      createdAt: DateTime.now(),
      likedBy: [],
      parentCommentId: parentCommentId,
    );

    await _firestore.collection(_commentsCollection).doc(commentId).set(comment.toJson());

    // Update post comments count
    await _firestore.collection(_postsCollection).doc(postId).update({
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return comment;
  }

  // Get comments for a post
  Stream<List<CommentModel>> getPostComments(String postId) {
    return _firestore
        .collection(_commentsCollection)
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => CommentModel.fromJson(doc.data())).toList());
  }

  // Like/Unlike comment
  Future<void> toggleCommentLike(String commentId, String userId) async {
    final commentRef = _firestore.collection(_commentsCollection).doc(commentId);
    
    await _firestore.runTransaction((transaction) async {
      final commentDoc = await transaction.get(commentRef);
      if (!commentDoc.exists) return;

      final comment = CommentModel.fromJson(commentDoc.data()!);
      final likedBy = List<String>.from(comment.likedBy);

      if (likedBy.contains(userId)) {
        likedBy.remove(userId);
      } else {
        likedBy.add(userId);
      }

      transaction.update(commentRef, {'likedBy': likedBy});
    });
  }

  // Delete post
  Future<void> deletePost(String postId, String userId) async {
    final postDoc = await _firestore.collection(_postsCollection).doc(postId).get();
    if (!postDoc.exists) return;

    final post = PostModel.fromJson(postDoc.data()!);
    if (post.userId != userId) throw Exception('Unauthorized');

    // Delete media files from storage
    for (final mediaUrl in post.mediaUrls) {
      try {
        await _storage.refFromURL(mediaUrl).delete();
      } catch (e) {
        // Continue if file doesn't exist
      }
    }

    // Delete comments
    final comments = await _firestore
        .collection(_commentsCollection)
        .where('postId', isEqualTo: postId)
        .get();
    
    final batch = _firestore.batch();
    for (final comment in comments.docs) {
      batch.delete(comment.reference);
    }

    // Delete post
    batch.delete(_firestore.collection(_postsCollection).doc(postId));
    await batch.commit();
  }

  // Update post view count
  Future<void> incrementViewCount(String postId) async {
    await _firestore.collection(_postsCollection).doc(postId).update({
      'viewCount': FieldValue.increment(1),
    });
  }

  // Search posts by tags or caption
  Future<List<PostModel>> searchPosts(String query) async {
    final snapshot = await _firestore
        .collection(_postsCollection)
        .where('isPublic', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => PostModel.fromJson(doc.data()))
        .where((post) => 
            post.caption.toLowerCase().contains(query.toLowerCase()) ||
            post.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }
}