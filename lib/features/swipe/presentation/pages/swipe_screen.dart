import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../theme/ito_bound_theme.dart';
import '../widgets/swipeable_profile_card.dart';
import '../../../chat/presentation/pages/chat_page.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  List<Map<String, dynamic>> _potentialMatches = [];
  bool _isLoading = true;
  bool _showMatchAnimation = false;
  Map<String, dynamic>? _currentMatch;
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _loadPotentialMatches();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadPotentialMatches() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;
      
      // Get current user's data to check preferences
      final currentUserDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      final currentUserData = currentUserDoc.data();
      
      if (currentUserData == null) return;
      
      // Get users who match preferences (simplified for demo)
      final usersSnapshot = await _firestore.collection('users').get();
      
      final potentialMatches = usersSnapshot.docs
          .where((doc) => doc.id != currentUser.uid) // Exclude current user
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
      
      // Filter based on preferences (simplified)
      // In a real app, you would implement more sophisticated filtering
      
      setState(() {
        _potentialMatches = potentialMatches;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading matches: ${e.toString()}')),
      );
    }
  }

  Future<void> _handleSwipe(String userId, String action) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;
      
      // Record the swipe action
      await _firestore.collection('swipes').add({
        'swiperId': currentUser.uid,
        'swipedId': userId,
        'action': action,
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      // If action is 'like' or 'super_like', check if there's a match
      if (action == 'like' || action == 'super_like') {
        // Check if the other user has already liked the current user
        final otherUserSwipes = await _firestore
            .collection('swipes')
            .where('swiperId', isEqualTo: userId)
            .where('swipedId', isEqualTo: currentUser.uid)
            .where('action', whereIn: ['like', 'super_like'])
            .get();
        
        if (otherUserSwipes.docs.isNotEmpty) {
          // It's a match!
          final matchId = '${currentUser.uid}_$userId';
          
          // Get the other user's data for the match animation
          final otherUserDoc = await _firestore.collection('users').doc(userId).get();
          final otherUserData = otherUserDoc.data();
          
          if (otherUserData != null) {
            // Create a match document
            await _firestore.collection('matches').doc(matchId).set({
              'users': [currentUser.uid, userId],
              'timestamp': FieldValue.serverTimestamp(),
              'lastMessage': null,
              'lastMessageTimestamp': null,
            });
            
            // Create a chat document (optional)
            await _firestore.collection('chats').doc(matchId).set({
              'participants': [currentUser.uid, userId],
              'createdAt': FieldValue.serverTimestamp(),
            });
            
            // Show match animation
            setState(() {
              _currentMatch = otherUserData;
              _showMatchAnimation = true;
            });
            
            _animationController.forward();
          }
        }
      }
      
      // Remove the swiped user from the list
      setState(() {
        _potentialMatches.removeWhere((user) => user['id'] == userId);
      });
      
      // If no more potential matches, reload
      if (_potentialMatches.isEmpty) {
        _loadPotentialMatches();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _dismissMatchAnimation() {
    setState(() {
      _showMatchAnimation = false;
    });
    _animationController.reset();
  }

  void _goToChat() {
    if (_currentMatch != null) {
      final matchId = '${_auth.currentUser!.uid}_${_currentMatch!['id']}';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            matchId: matchId,
            matchName: _currentMatch!['name'],
            matchPhotoUrl: _currentMatch!['photoUrls']?[0] ?? '',
          ),
        ),
      );
      _dismissMatchAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                _potentialMatches.isEmpty
                    ? _buildNoMoreProfiles()
                    : _buildSwipeableCards(),
                if (_showMatchAnimation) _buildMatchAnimation(),
              ],
            ),
    );
  }

  Widget _buildSwipeableCards() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: _potentialMatches.asMap().entries.map((entry) {
              final index = entry.key;
              final user = entry.value;
              
              // Only show the top 3 cards for performance
              if (index > 2) return const SizedBox.shrink();
              
              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Apply a slight offset to cards behind the top card
                    final topPadding = index * 8.0;
                    
                    return Padding(
                      padding: EdgeInsets.only(top: topPadding),
                      child: SwipeableProfileCard(
                        userId: user['id'],
                        name: user['name'] ?? 'Unknown',
                        age: user['age'] ?? 0,
                        bio: user['bio'] ?? '',
                        imageUrls: List<String>.from(user['photoUrls'] ?? []),
                        onLike: () => _handleSwipe(user['id'], 'like'),
                        onDislike: () => _handleSwipe(user['id'], 'dislike'),
                        onSuperLike: () => _handleSwipe(user['id'], 'super_like'),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNoMoreProfiles() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No more profiles to show',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Try again later or adjust your preferences',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadPotentialMatches,
            style: ElevatedButton.styleFrom(
              backgroundColor: ItoBoundColors.primaryPink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchAnimation() {
    return GestureDetector(
      onTap: _dismissMatchAnimation,
      child: Container(
        color: Colors.black87,
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: kPrimaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'It\'s a Match!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Current user avatar
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _auth.currentUser?.photoURL != null
                            ? NetworkImage(_auth.currentUser!.photoURL!)
                            : null,
                        child: _auth.currentUser?.photoURL == null
                            ? const Icon(Icons.person, size: 60)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      // Match user avatar
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _currentMatch?['photoUrls'] != null &&
                                (_currentMatch?['photoUrls'] as List).isNotEmpty
                            ? NetworkImage(_currentMatch!['photoUrls'][0])
                            : null,
                        child: (_currentMatch?['photoUrls'] == null ||
                                (_currentMatch?['photoUrls'] as List).isEmpty)
                            ? const Icon(Icons.person, size: 60)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'You and ${_currentMatch?['name'] ?? 'someone'} liked each other',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: _dismissMatchAnimation,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Keep Swiping'),
                      ),
                      ElevatedButton(
                        onPressed: _goToChat,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: ItoBoundColors.primaryPink,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Send Message'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}