import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/models/post_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/demo_data_service.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final PostModel post;

  const CommentsScreen({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Comment> _comments = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadComments() {
    // Generate demo comments
    final users = DemoDataService.getDemoUsers();
    final demoComments = [
      Comment(
        id: '1',
        userId: users[0].id,
        content: 'Amazing shot! 📸✨',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likesCount: 12,
      ),
      Comment(
        id: '2',
        userId: users[1].id,
        content: 'Love this! Where was this taken? 🌟',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        likesCount: 8,
      ),
      Comment(
        id: '3',
        userId: users[2].id,
        content: 'Incredible! You have such a great eye for photography 👏',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        likesCount: 15,
      ),
    ];

    setState(() {
      _comments.addAll(demoComments);
    });
  }

  @override
  Widget build(BuildContext context) {
    final postUser = DemoDataService.getUsersMap()[widget.post.userId];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Comments',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Post preview
          _buildPostPreview(postUser),
          
          const Divider(color: Colors.white24, height: 1),
          
          // Comments list
          Expanded(
            child: _comments.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return _buildCommentItem(comment, index);
                    },
                  ),
          ),
          
          // Comment input
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildPostPreview(UserModel? postUser) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: postUser?.profilePictureUrl != null
                ? CachedNetworkImageProvider(postUser!.profilePictureUrl!)
                : null,
            backgroundColor: Colors.grey[800],
            child: postUser?.profilePictureUrl == null
                ? const Icon(Icons.person, color: Colors.white, size: 24)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      postUser?.name ?? 'Unknown User',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (postUser?.isPremium == true) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 16,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                if (widget.post.caption.isNotEmpty)
                  Text(
                    widget.post.caption,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 4),
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

  Widget _buildCommentItem(Comment comment, int index) {
    final user = DemoDataService.getUsersMap()[comment.userId];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: user?.profilePictureUrl != null
                ? CachedNetworkImageProvider(user!.profilePictureUrl!)
                : null,
            backgroundColor: Colors.grey[800],
            child: user?.profilePictureUrl == null
                ? const Icon(Icons.person, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${user?.name ?? 'Unknown'} ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: comment.content,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _getTimeAgo(comment.createdAt),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (comment.likesCount > 0) ...[
                      Text(
                        '${comment.likesCount} likes',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    GestureDetector(
                      onTap: () {
                        // TODO: Implement reply functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reply feature coming soon!')),
                        );
                      },
                      child: const Text(
                        'Reply',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _likeComment(comment.id),
            child: const Icon(
              Icons.favorite_border,
              color: Colors.white54,
              size: 16,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              color: Colors.white54,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No comments yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Be the first to comment!',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _commentController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _isLoading ? null : _postComment,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      )
                    : Icon(
                        Icons.send,
                        color: _commentController.text.trim().isNotEmpty
                            ? Colors.blue
                            : Colors.white54,
                        size: 24,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _likeComment(String commentId) {
    // TODO: Implement comment like functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('❤️ Comment liked!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _postComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate posting comment
      await Future.delayed(const Duration(seconds: 1));

      final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user', // Replace with actual current user ID
        content: content,
        createdAt: DateTime.now(),
        likesCount: 0,
      );

      setState(() {
        _comments.add(newComment);
        _commentController.clear();
      });

      // Scroll to bottom to show new comment
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('💬 Comment posted!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error posting comment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${difference.inDays ~/ 7}w';
    }
  }
}

class Comment {
  final String id;
  final String userId;
  final String content;
  final DateTime createdAt;
  final int likesCount;

  Comment({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.likesCount,
  });
}