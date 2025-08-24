import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/models/user_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../providers/swipe_provider.dart';
import 'widgets/modern_swipe_card.dart';
import 'widgets/swipe_actions.dart';
import 'widgets/boost_button.dart';
import '../../chat/presentation/chat_screen.dart';

class SwipeScreen extends ConsumerStatefulWidget {
  const SwipeScreen({super.key});

  @override
  ConsumerState<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends ConsumerState<SwipeScreen>
    with TickerProviderStateMixin {
  late AnimationController _matchAnimationController;
  late AnimationController _boostAnimationController;
  bool _showMatchAnimation = false;
  UserModel? _matchedUser;

  @override
  void initState() {
    super.initState();
    _matchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _boostAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _matchAnimationController.dispose();
    _boostAnimationController.dispose();
    super.dispose();
  }

  void _onSwipeAction(String action, UserModel user) async {
    final currentUser = ref.read(authNotifierProvider).value;
    if (currentUser == null) return;

    try {
      switch (action) {
        case 'like':
          final isMatch = await ref
              .read(swipeNotifierProvider.notifier)
              .likeUser(currentUser.uid, user.id);
          if (isMatch) {
            _showMatch(user);
          } else {
            // Show like feedback
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You liked ${user.name}! 💖'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 1),
              ),
            );
          }
          break;
        case 'superlike':
          final isMatch = await ref
              .read(swipeNotifierProvider.notifier)
              .superLikeUser(currentUser.uid, user.id);
          if (isMatch) {
            _showMatch(user);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You super liked ${user.name}! ⭐'),
                backgroundColor: Colors.blue,
                duration: const Duration(seconds: 1),
              ),
            );
          }
          break;
        case 'dislike':
          await ref
              .read(swipeNotifierProvider.notifier)
              .dislikeUser(currentUser.uid, user.id);
          break;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showMatch(UserModel user) {
    setState(() {
      _matchedUser = user;
      _showMatchAnimation = true;
    });
    _matchAnimationController.forward();
  }

  void _closeMatchAnimation() {
    setState(() {
      _showMatchAnimation = false;
      _matchedUser = null;
    });
    _matchAnimationController.reset();
  }

  void _sendMessage(UserModel user) {
    _closeMatchAnimation();
    // Navigate to chat with the matched user
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatScreen(),
      ),
    );
  }

  void _onBoost() async {
    final currentUser = ref.read(authNotifierProvider).value;
    if (currentUser == null) return;

    try {
      await ref.read(swipeNotifierProvider.notifier).useBoost(currentUser.uid);
      _boostAnimationController.forward().then((_) {
        _boostAnimationController.reset();
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🚀 Boost activated! You\'ll be shown to more people'),
            backgroundColor: Colors.purple,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final swipeState = ref.watch(swipeNotifierProvider);
    final currentUser = ref.watch(authNotifierProvider).value;

    if (currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a1a),
              Color(0xFF2d2d2d),
              Color(0xFF1a1a1a),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Header with boost button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discover',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.settings,
                                color: Colors.white70,
                                size: 28,
                              ),
                              onPressed: () {
                                // TODO: Navigate to settings
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('⚙️ Settings coming soon!'),
                                    backgroundColor: Colors.grey,
                                  ),
                                );
                              },
                            ),
                            BoostButton(
                              onPressed: _onBoost,
                              animationController: _boostAnimationController,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Cards stack
              Expanded(
                child: swipeState.when(
                  data: (users) {
                    if (users.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_outline,
                              size: 80,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No more people nearby',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try expanding your search criteria',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background cards (for depth effect)
                        for (int i = users.length - 1; i >= 0; i--)
                          Positioned(
                            top: i * 4.0,
                            child: Transform.scale(
                              scale: 1 - (i * 0.02),
                              child: ModernSwipeCard(
                                user: users[i],
                                isTopCard: i == 0,
                                onSwipeAction: (action) => _onSwipeAction(action, users[i]),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Something went wrong',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Action buttons
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SwipeActions(
                    onDislike: () {
                      final users = swipeState.value;
                      if (users != null && users.isNotEmpty) {
                        _onSwipeAction('dislike', users.first);
                      }
                    },
                    onSuperLike: () {
                      final users = swipeState.value;
                      if (users != null && users.isNotEmpty) {
                        _onSwipeAction('superlike', users.first);
                      }
                    },
                    onLike: () {
                      final users = swipeState.value;
                      if (users != null && users.isNotEmpty) {
                        _onSwipeAction('like', users.first);
                      }
                    },
                  ),
                ),
              ),
              ],
            ),
            
            // Match animation overlay
            if (_showMatchAnimation && _matchedUser != null)
              _MatchAnimationOverlay(
                user: _matchedUser!,
                animationController: _matchAnimationController,
                onSendMessage: () => _sendMessage(_matchedUser!),
                onKeepSwiping: _closeMatchAnimation,
              ),
          ],
        ),
      ),
    );
  }
}

class _MatchAnimationOverlay extends StatelessWidget {
  final UserModel user;
  final AnimationController animationController;
  final VoidCallback onSendMessage;
  final VoidCallback onKeepSwiping;

  const _MatchAnimationOverlay({
    required this.user,
    required this.animationController,
    required this.onSendMessage,
    required this.onKeepSwiping,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.9),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "IT'S A MATCH!",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 48,
              ),
            )
                .animate(controller: animationController)
                .scale(duration: 600.ms, curve: Curves.elasticOut)
                .shimmer(duration: 1000.ms, color: Colors.pink),
            
            const SizedBox(height: 40),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: user.profilePictureUrl != null
                      ? NetworkImage(user.profilePictureUrl!)
                      : null,
                  backgroundColor: Colors.grey[800],
                  child: user.profilePictureUrl == null
                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                )
                    .animate(controller: animationController)
                    .slideX(begin: -1, duration: 800.ms, curve: Curves.easeOut),
                
                const SizedBox(width: 40),
                
                Icon(
                  Icons.favorite,
                  size: 80,
                  color: Colors.pink,
                )
                    .animate(controller: animationController)
                    .scale(
                      begin: const Offset(0, 0),
                      duration: 400.ms,
                      delay: 200.ms,
                      curve: Curves.elasticOut,
                    ),
                
                const SizedBox(width: 40),
                
                // Current user avatar (placeholder)
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[800],
                  child: const Icon(Icons.person, size: 60, color: Colors.white),
                )
                    .animate(controller: animationController)
                    .slideX(begin: 1, duration: 800.ms, curve: Curves.easeOut),
              ],
            ),
            
            const SizedBox(height: 40),
            
            Text(
              'You and ${user.name} liked each other!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            )
                .animate(controller: animationController)
                .fadeIn(delay: 600.ms, duration: 400.ms),
            
            const SizedBox(height: 60),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Keep Swiping button
                OutlinedButton(
                  onPressed: onKeepSwiping,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Keep Swiping',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                // Send Message button
                ElevatedButton(
                  onPressed: onSendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Send Message',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
                .animate(controller: animationController)
                .fadeIn(delay: 800.ms, duration: 400.ms)
                .slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }
}