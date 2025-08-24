import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/services/demo_data_service.dart';
import '../../../../core/models/user_model.dart';

class StoriesBar extends StatelessWidget {
  const StoriesBar({super.key});

  @override
  Widget build(BuildContext context) {
    final users = DemoDataService.getDemoUsers();
    
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: users.length + 1, // +1 for "Add Story" item
        itemBuilder: (context, index) {
          if (index == 0) {
            return _AddStoryItem();
          }
          final user = users[index - 1];
          return _StoryItem(
            user: user,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user.name}\'s story - Coming soon! 📸'),
                  backgroundColor: Colors.purple,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AddStoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Story creation coming soon! 📸✨'),
            backgroundColor: Colors.purple,
          ),
        );
      },
      child: Container(
        width: 68,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your Story',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const _StoryItem({
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 68,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: user.hasStory
                    ? const LinearGradient(
                        colors: [Colors.pink, Colors.purple],
                      )
                    : null,
                border: !user.hasStory
                    ? Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      )
                    : null,
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                radius: 28,
                backgroundImage: CachedNetworkImageProvider(
                  user.profilePictureUrl ?? 'https://via.placeholder.com/150',
                ),
                backgroundColor: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.name.split(' ').first, // Show first name only
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}