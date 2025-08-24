import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/services/demo_data_service.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  bool _isLiked = false;
  bool _isBookmarked = false;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _isLiked = widget.post.isLikedBy('current_user');
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = DemoDataService.getUsersMap()[widget.post.userId];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with user info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(
                    user?.profilePictureUrl ?? 'https://via.placeholder.com/150',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            user?.name ?? 'Unknown User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (user?.isPremium == true) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                      if (widget.post.location != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              widget.post.location!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white70),
                  onPressed: () {
                    _showPostOptions(context);
                  },
                ),
              ],
            ),
          ),

          // Post media
          if (widget.post.mediaUrls.isNotEmpty)
            GestureDetector(
              onDoubleTap: _handleDoubleTap,
              child: Stack(
                children: [
                  SizedBox(
                    height: 300,
                    child: widget.post.mediaUrls.length == 1
                        ? CachedNetworkImage(
                            imageUrl: widget.post.mediaUrls.first,
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 300,
                              color: Colors.white.withOpacity(0.1),
                              child: const Center(
                                child: CircularProgressIndicator(color: Colors.white),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 300,
                              color: Colors.white.withOpacity(0.1),
                              child: const Center(
                                child: Icon(Icons.error, color: Colors.white54),
                              ),
                            ),
                          )
                        : PageView.builder(
                            itemCount: widget.post.mediaUrls.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return CachedNetworkImage(
                                imageUrl: widget.post.mediaUrls[index],
                                width: double.infinity,
                                height: 300,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  height: 300,
                                  color: Colors.white.withOpacity(0.1),
                                  child: const Center(
                                    child: CircularProgressIndicator(color: Colors.white),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 300,
                                  color: Colors.white.withOpacity(0.1),
                                  child: const Center(
                                    child: Icon(Icons.error, color: Colors.white54),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  
                  // Multiple images indicator
                  if (widget.post.mediaUrls.length > 1)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_currentImageIndex + 1}/${widget.post.mediaUrls.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  
                  // Page indicators for multiple images
                  if (widget.post.mediaUrls.length > 1)
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.post.mediaUrls.length,
                          (index) => Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == _currentImageIndex
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                  // Double tap heart animation
                  if (_likeAnimationController.isAnimating)
                    Positioned.fill(
                      child: Center(
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.5, end: 1.5).animate(
                            CurvedAnimation(
                              parent: _likeAnimationController,
                              curve: Curves.elasticOut,
                            ),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: _handleLike,
                      child: AnimatedScale(
                        scale: _isLiked ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? Colors.red : Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: widget.onComment,
                      child: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: widget.onShare,
                      child: const Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _handleBookmark,
                      child: AnimatedScale(
                        scale: _isBookmarked ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: _isBookmarked ? Colors.amber : Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Likes count
                if (widget.post.likesCount > 0)
                  Text(
                    '${_formatCount(widget.post.likesCount)} likes',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                
                const SizedBox(height: 8),
                
                // Caption
                if (widget.post.caption.isNotEmpty)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${user?.name ?? 'Unknown'} ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: widget.post.caption,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Comments count
                if (widget.post.commentsCount > 0) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: widget.onComment,
                    child: Text(
                      'View all ${_formatCount(widget.post.commentsCount)} comments',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
                
                const SizedBox(height: 8),
                
                // Time ago
                Text(
                  _getTimeAgo(widget.post.createdAt),
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
    widget.onLike();
  }

  void _handleDoubleTap() {
    if (!_isLiked) {
      setState(() {
        _isLiked = true;
      });
      _likeAnimationController.forward().then((_) {
        _likeAnimationController.reset();
      });
      widget.onLike();
    }
  }

  void _handleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked ? 'Post saved' : 'Post removed from saved'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showPostOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.link, color: Colors.white),
              title: const Text('Copy Link', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link copied!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.white),
              title: const Text('Share to...', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                widget.onShare();
              },
            ),
            ListTile(
              leading: Icon(
                _isBookmarked ? Icons.bookmark_remove : Icons.bookmark_add,
                color: Colors.white,
              ),
              title: Text(
                _isBookmarked ? 'Remove from saved' : 'Save post',
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _handleBookmark();
              },
            ),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.visibility_off, color: Colors.orange),
              title: const Text('Hide post', style: TextStyle(color: Colors.orange)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post hidden')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.report, color: Colors.red),
              title: const Text('Report', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post reported')),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${difference.inDays ~/ 7}w ago';
    }
  }

  String _formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }
}