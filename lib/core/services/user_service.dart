import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  Future<void> createUser(UserModel user) async {
    await _firestore.collection(_collection).doc(user.id).set(user.toJson());
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection(_collection).doc(user.id).update(user.toJson());
  }

  Future<void> updateUserLocation(String userId, double latitude, double longitude) async {
    await _firestore.collection(_collection).doc(userId).update({
      'latitude': latitude,
      'longitude': longitude,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateOnlineStatus(String userId, bool isOnline) async {
    await _firestore.collection(_collection).doc(userId).update({
      'isOnline': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  Stream<UserModel?> getUserStream(String userId) {
    return _firestore
        .collection(_collection)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromJson(doc.data()!) : null);
  }

  Future<List<UserModel>> getDiscoveryUsers(String currentUserId, {
    int limit = 10,
    double? latitude,
    double? longitude,
    int maxDistance = 50,
    int minAge = 18,
    int maxAge = 35,
    String? gender,
  }) async {
    Query query = _firestore.collection(_collection);
    
    // Filter out current user, blocked users, and already swiped users
    final currentUser = await getUser(currentUserId);
    if (currentUser == null) return [];

    final excludedIds = [
      currentUserId,
      ...currentUser.blockedUsers,
      ...currentUser.likedUsers,
      ...currentUser.dislikedUsers,
      ...currentUser.superLikedUsers,
    ];

    query = query.where(FieldPath.documentId, whereNotIn: excludedIds.take(10).toList());
    
    // Age filter
    query = query.where('age', isGreaterThanOrEqualTo: minAge);
    query = query.where('age', isLessThanOrEqualTo: maxAge);
    
    // Gender filter
    if (gender != null && gender.isNotEmpty) {
      query = query.where('gender', isEqualTo: gender);
    }
    
    // Show me filter
    query = query.where('showMe', isEqualTo: true);
    
    query = query.limit(limit);

    final snapshot = await query.get();
    final users = snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    // Filter by distance if location is provided (simplified for demo)
    if (latitude != null && longitude != null) {
      users.removeWhere((user) {
        if (user.latitude == null || user.longitude == null) return true;
        // Simple distance calculation for demo purposes
        final latDiff = (latitude - user.latitude!).abs();
        final lonDiff = (longitude - user.longitude!).abs();
        final distance = (latDiff + lonDiff) * 111; // Rough km conversion
        return distance > maxDistance;
      });
    }

    return users;
  }

  Future<void> likeUser(String currentUserId, String targetUserId) async {
    final batch = _firestore.batch();
    
    // Add to current user's liked list
    batch.update(_firestore.collection(_collection).doc(currentUserId), {
      'likedUsers': FieldValue.arrayUnion([targetUserId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Check if target user already liked current user (match)
    final targetUser = await getUser(targetUserId);
    if (targetUser != null && targetUser.likedUsers.contains(currentUserId)) {
      // Create match
      final matchId = '${currentUserId}_$targetUserId';
      batch.set(_firestore.collection('matches').doc(matchId), {
        'id': matchId,
        'user1Id': currentUserId,
        'user2Id': targetUserId,
        'matchedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'user1Unmatched': false,
        'user2Unmatched': false,
      });

      // Add to both users' matched lists
      batch.update(_firestore.collection(_collection).doc(currentUserId), {
        'matchedUsers': FieldValue.arrayUnion([targetUserId]),
      });
      batch.update(_firestore.collection(_collection).doc(targetUserId), {
        'matchedUsers': FieldValue.arrayUnion([currentUserId]),
      });
    }

    await batch.commit();
  }

  Future<void> superLikeUser(String currentUserId, String targetUserId) async {
    final currentUser = await getUser(currentUserId);
    if (currentUser == null || currentUser.superLikeCount <= 0) {
      throw Exception('No super likes remaining');
    }

    final batch = _firestore.batch();
    
    // Add to current user's super liked list and decrease count
    batch.update(_firestore.collection(_collection).doc(currentUserId), {
      'superLikedUsers': FieldValue.arrayUnion([targetUserId]),
      'superLikeCount': FieldValue.increment(-1),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Check for match (super like always creates a match if target user liked back)
    final targetUser = await getUser(targetUserId);
    if (targetUser != null && 
        (targetUser.likedUsers.contains(currentUserId) || 
         targetUser.superLikedUsers.contains(currentUserId))) {
      // Create match
      final matchId = '${currentUserId}_$targetUserId';
      batch.set(_firestore.collection('matches').doc(matchId), {
        'id': matchId,
        'user1Id': currentUserId,
        'user2Id': targetUserId,
        'matchedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'user1Unmatched': false,
        'user2Unmatched': false,
      });

      // Add to both users' matched lists
      batch.update(_firestore.collection(_collection).doc(currentUserId), {
        'matchedUsers': FieldValue.arrayUnion([targetUserId]),
      });
      batch.update(_firestore.collection(_collection).doc(targetUserId), {
        'matchedUsers': FieldValue.arrayUnion([currentUserId]),
      });
    }

    await batch.commit();
  }

  Future<void> dislikeUser(String currentUserId, String targetUserId) async {
    await _firestore.collection(_collection).doc(currentUserId).update({
      'dislikedUsers': FieldValue.arrayUnion([targetUserId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> blockUser(String currentUserId, String targetUserId) async {
    await _firestore.collection(_collection).doc(currentUserId).update({
      'blockedUsers': FieldValue.arrayUnion([targetUserId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}