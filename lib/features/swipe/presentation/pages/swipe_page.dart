import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});
  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  List<DocumentSnapshot> _users = [];
  int _currentIndex = 0;
  bool _showMatch = false;
  bool _loading = true;
  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _loading = true);
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      _users = snapshot.docs.where((doc) => doc['uid'] != uid).toList();
      _loading = false;
    });
  }

  Future<void> _swipe(String action) async {
    if (_currentIndex >= _users.length) return;
    final user = _users[_currentIndex];
    final targetUserId = user['uid'] as String;
    await FirebaseFirestore.instance.collection('swipes').add({
      'swiperId': uid,
      'targetId': targetUserId,
      'action': action,
      'createdAt': FieldValue.serverTimestamp(),
    });
    setState(() {
      if (_currentIndex < _users.length - 1) {
        _currentIndex++;
        _showMatch = action == 'like';
      } else {
        _showMatch = false;
      }
    });
    if (action == 'like') {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() => _showMatch = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_users.isEmpty) {
      return const Scaffold(body: Center(child: Text('No users to show.')));
    }
    final user = _users[_currentIndex].data() as Map<String, dynamic>;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F0),
      appBar: AppBar(
        title: const Text('Discover'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: const BorderSide(color: Color(0xFFB3001B), width: 2),
          ),
          elevation: 8,
          child: Container(
            width: 340,
            height: 480,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFC1CC), Color(0xFFFFF0F0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                if (user['photos'] != null && user['photos'].isNotEmpty)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.network(
                        user['photos'][0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(220),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${user['name']}, ${user['age']}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: const Color(0xFFB3001B),
                                fontFamily: 'PlayfairDisplay',
                              ),
                        ),
                        Text(
                          user['zodiacSign'] ?? '',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFFB3001B),
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user['bio'] ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_showMatch)
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(240),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFB3001B),
                          width: 3,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Color(0xFFB3001B),
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'It’s a Match!',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(color: const Color(0xFFB3001B)),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 48,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 48,
                        ),
                        onPressed: () => _swipe('dislike'),
                      ),
                      const SizedBox(width: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB3001B),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          elevation: 8,
                        ),
                        onPressed: () => _swipe('super_connect'),
                        child: const Icon(
                          Icons.flash_on,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 32),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.green,
                          size: 48,
                        ),
                        onPressed: () => _swipe('like'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
