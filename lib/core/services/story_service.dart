import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../models/story_model.dart';

class StoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _storiesCollection = 'stories';

  // Create a new story
  Future<StoryModel> createStory({
    required String userId,
    required String content,
    required StoryType type,
    File? mediaFile,
    String? backgroundColor,
    String? textColor,
    bool isHighlight = false,
    String? highlightTitle,
  }) async {
    final storyId = const Uuid().v4();
    String? mediaUrl;
    String? thumbnailUrl;

    // Upload media file if provided
    if (mediaFile != null) {
      final fileName = '$storyId.${mediaFile.path.split('.').last}';
      final ref = _storage.ref().child('stories/$userId/$fileName');
      
      await ref.putFile(mediaFile);
      mediaUrl = await ref.getDownloadURL();
      
      if (type == StoryType.video) {
        // Generate thumbnail for video
        thumbnailUrl = mediaUrl; // In a real app, you'd generate a proper thumbnail
      }
    }

    final story = StoryModel(
      id: storyId,
      userId: userId,
      content: content,
      type: type,
      mediaUrl: mediaUrl,
      thumbnailUrl: thumbnailUrl,
      createdAt: DateTime.now(),
      expiresAt: isHighlight 
          ? DateTime.now().add(const Duration(days: 365)) // Highlights don't expire
          : DateTime.now().add(const Duration(hours: 24)),
      viewedBy: [],
      backgroundColor: backgroundColor,
      textColor: textColor,
      isHighlight: isHighlight,
      highlightTitle: highlightTitle,
    );

    await _firestore.collection(_storiesCollection).doc(storyId).set(story.toJson());
    return story;
  }

  // Get active stories from followed users
  Stream<List<StoryModel>> getStoriesFeed(List<String> followedUserIds) {
    return _firestore
        .collection(_storiesCollection)
        .where('userId', whereIn: followedUserIds.isEmpty ? [''] : followedUserIds)
        .where('expiresAt', isGreaterThan: Timestamp.now())
        .orderBy('expiresAt')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => StoryModel.fromJson(doc.data())).toList());
  }

  // Get user's stories
  Stream<List<StoryModel>> getUserStories(String userId) {
    return _firestore
        .collection(_storiesCollection)
        .where('userId', isEqualTo: userId)
        .where('expiresAt', isGreaterThan: Timestamp.now())
        .orderBy('expiresAt')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => StoryModel.fromJson(doc.data())).toList());
  }

  // Get user's highlights
  Stream<List<StoryModel>> getUserHighlights(String userId) {
    return _firestore
        .collection(_storiesCollection)
        .where('userId', isEqualTo: userId)
        .where('isHighlight', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => StoryModel.fromJson(doc.data())).toList());
  }

  // Mark story as viewed
  Future<void> markStoryAsViewed(String storyId, String viewerId) async {
    await _firestore.collection(_storiesCollection).doc(storyId).update({
      'viewedBy': FieldValue.arrayUnion([viewerId]),
    });
  }

  // Delete story
  Future<void> deleteStory(String storyId, String userId) async {
    final storyDoc = await _firestore.collection(_storiesCollection).doc(storyId).get();
    if (!storyDoc.exists) return;

    final story = StoryModel.fromJson(storyDoc.data()!);
    if (story.userId != userId) throw Exception('Unauthorized');

    // Delete media file from storage
    if (story.mediaUrl != null) {
      try {
        await _storage.refFromURL(story.mediaUrl!).delete();
      } catch (e) {
        // Continue if file doesn't exist
      }
    }

    // Delete story document
    await _firestore.collection(_storiesCollection).doc(storyId).delete();
  }

  // Add story to highlights
  Future<void> addToHighlights(String storyId, String highlightTitle) async {
    await _firestore.collection(_storiesCollection).doc(storyId).update({
      'isHighlight': true,
      'highlightTitle': highlightTitle,
      'expiresAt': Timestamp.fromDate(DateTime.now().add(const Duration(days: 365))),
    });
  }

  // Remove story from highlights
  Future<void> removeFromHighlights(String storyId) async {
    await _firestore.collection(_storiesCollection).doc(storyId).update({
      'isHighlight': false,
      'highlightTitle': null,
      'expiresAt': Timestamp.fromDate(DateTime.now().add(const Duration(hours: 24))),
    });
  }

  // Get story viewers
  Future<List<String>> getStoryViewers(String storyId) async {
    final storyDoc = await _firestore.collection(_storiesCollection).doc(storyId).get();
    if (!storyDoc.exists) return [];

    final story = StoryModel.fromJson(storyDoc.data()!);
    return story.viewedBy;
  }

  // Clean up expired stories (should be called periodically)
  Future<void> cleanupExpiredStories() async {
    final expiredStories = await _firestore
        .collection(_storiesCollection)
        .where('expiresAt', isLessThan: Timestamp.now())
        .where('isHighlight', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in expiredStories.docs) {
      final story = StoryModel.fromJson(doc.data());
      
      // Delete media file
      if (story.mediaUrl != null) {
        try {
          await _storage.refFromURL(story.mediaUrl!).delete();
        } catch (e) {
          // Continue if file doesn't exist
        }
      }
      
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}