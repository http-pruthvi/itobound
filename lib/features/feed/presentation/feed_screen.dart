import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/models/post_model.dart';
import '../../../core/services/user_service.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../theme/ito_bound_theme.dart';
import '../providers/feed_provider.dart';
import 'widgets/post_card.dart';
import 'create_menu_screen.dart';
import 'comments_screen.dart';
import '../../chat/presentation/chat_screen.dart';
import '../../notifications/presentation/notifications_screen.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(feedPostsProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Dating-focused header
              _buildDatingFeedHeader(),

              // Stories section
              const _StoriesSection(),

              // Posts feed
              Expanded(
                child: postsAsync.when(
                  data: (posts) {
                    if (posts.isEmpty) {
                      return const _EmptyFeedState();
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.refresh(feedPostsProvider);
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return PostCard(
                            post: post,
                            onLike: () => _handleLike(post.id),
                            onComment: () => _handleComment(post),
                            onShare: () => _handleShare(post),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.white54,
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
                          'Pull to refresh',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateMenuScreen(),
            ),
          );
        },
        backgroundColor: Colors.pink,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      )
          .animate()
          .scale(duration: 600.ms, curve: Curves.elasticOut)
          .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3)),
    );
  }

  void _handleLike(String postId) {
    // TODO: Implement like functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('❤️ Liked!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _handleComment(PostModel post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentsScreen(post: post),
      ),
    );
  }

  void _handleShare(PostModel post) {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📤 Share feature coming soon!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildDatingFeedHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pink.withOpacity(0.1),
            Colors.purple.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Romantic logo with heart
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: kPrimaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ItoBound',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Find Your Connection',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              
              // Action buttons with dating context
              Row(
                children: [
                  _buildHeaderButton(
                    icon: Icons.add_circle_outline,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateMenuScreen(),
                        ),
                      );
                    },
                    tooltip: 'Share Moment',
                  ),
                  _buildHeaderButton(
                    icon: Icons.notifications_none,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                    tooltip: 'Activity',
                  ),
                  _buildHeaderButton(
                    icon: Icons.chat_bubble_outline,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatScreen(),
                        ),
                      );
                    },
                    tooltip: 'Messages',
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Connection status or daily inspiration
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Colors.amber,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Share your story, find your match ✨',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _StoriesSection extends ConsumerWidget {
  const _StoriesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_stories,
                color: Colors.pink,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Daily Moments',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateMenuScreen(),
                    ),
                  );
                },
                child: Text(
                  'Share Yours',
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          SizedBox(
            height: 90,
            child: FutureBuilder(
              future: _getStoriesUsers(ref),
              builder: (context, snapshot) {
                final users = (snapshot.data as List<dynamic>?) ?? [];
                
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: users.length + 1, // +1 for "Your Story"
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _YourMomentCard();
                    }
                    
                    final user = users[index - 1];
                    return _MomentCard(user: user);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> _getStoriesUsers(WidgetRef ref) async {
    try {
      final currentUser = ref.read(authNotifierProvider).value;
      if (currentUser == null) return [];

      final userService = UserService();
      // Get users with stories (simplified - in production you'd have a proper stories service)
      final users = await userService.getDiscoveryUsers(
        currentUser.uid,
        limit: 10,
      );
      
      return users.where((user) => user.hasStory).toList();
    } catch (e) {
      return [];
    }
  }
}

class _YourMomentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateMenuScreen(),
          ),
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink.withOpacity(0.3),
              Colors.purple.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Share',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              'Moment',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MomentCard extends StatelessWidget {
  final dynamic user;

  const _MomentCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${user.name}\'s moment - Coming soon! 💕'),
            backgroundColor: Colors.pink,
          ),
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: user.hasStory 
                ? Colors.pink.withOpacity(0.8)
                : Colors.white.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                child: user.profilePictureUrl != null
                    ? CachedNetworkImage(
                        imageUrl: user.profilePictureUrl!,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
              ),
              
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              
              // Name at bottom
              Positioned(
                bottom: 6,
                left: 6,
                right: 6,
                child: Text(
                  user.name.split(' ').first,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyFeedState extends StatelessWidget {
  const _EmptyFeedState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                ],
              ),
            ),
            child: const Icon(
              Icons.photo_camera_outlined,
              size: 60,
              color: Colors.white54,
            ),
          )
              .animate()
              .scale(duration: 800.ms, curve: Curves.elasticOut)
              .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3)),
          
          const SizedBox(height: 32),
          
          Text(
            'Welcome to ItoBound!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Share your first post to get started\nand connect with amazing people!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateMenuScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Create Your First Post'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}