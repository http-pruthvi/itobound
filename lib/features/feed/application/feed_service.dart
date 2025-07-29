import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class FeedService {
  final _postsRef = FirebaseFirestore.instance.collection('posts');

  Future<List<PostModel>> fetchPosts() async {
    final snapshot =
        await _postsRef.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return PostModel(
        id: doc.id,
        userId: data['userId'] ?? '',
        content: data['content'] ?? '',
        imageUrl: data['imageUrl'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        likes: List<String>.from(data['likes'] ?? []),
        comments: [],
      );
    }).toList();
  }

  Future<void> likePost(String postId, String userId) async {
    final postRef = _postsRef.doc(postId);
    await postRef.update({
      'likes': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> commentOnPost(
      String postId, Map<String, dynamic> comment) async {
    final postRef = _postsRef.doc(postId);
    await postRef.update({
      'comments': FieldValue.arrayUnion([comment]),
    });
  }
}
