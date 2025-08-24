import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/ito_bound_theme.dart';
import '../../../core/providers/auth_provider.dart';
import '../../profile/presentation/profile_setup_screen.dart';
import '../../feed/presentation/create_menu_screen.dart';
import 'preferences_screen.dart';
import 'premium_screen.dart';
import 'privacy_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Settings',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Settings sections
                _SettingsSection(
                  title: 'Account',
                  items: [
                    _SettingsItem(
                      icon: Icons.person,
                      title: 'Edit Profile',
                      subtitle: 'Update your profile information',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileSetupScreen(),
                          ),
                        );
                      },
                    ),
                    _SettingsItem(
                      icon: Icons.photo_library,
                      title: 'Manage Photos',
                      subtitle: 'Add or remove your photos',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateMenuScreen(),
                          ),
                        );
                      },
                    ),
                    _SettingsItem(
                      icon: Icons.verified_user,
                      title: 'Verification',
                      subtitle: 'Verify your profile',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile verification coming soon! ✅'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                _SettingsSection(
                  title: 'Preferences',
                  items: [
                    _SettingsItem(
                      icon: Icons.tune,
                      title: 'Discovery Settings',
                      subtitle: 'Age range, distance, and more',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PreferencesScreen(),
                          ),
                        );
                      },
                    ),
                    _SettingsItem(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      subtitle: 'Manage your notification preferences',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Notification settings coming soon! 🔔'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                _SettingsSection(
                  title: 'Premium',
                  items: [
                    _SettingsItem(
                      icon: Icons.star,
                      title: 'Upgrade to Premium',
                      subtitle: 'Unlock exclusive features',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PremiumScreen(),
                          ),
                        );
                      },
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.purple, Colors.pink],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Premium',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                _SettingsSection(
                  title: 'Privacy & Safety',
                  items: [
                    _SettingsItem(
                      icon: Icons.security,
                      title: 'Privacy Settings',
                      subtitle: 'Control who can see your profile',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyScreen(),
                          ),
                        );
                      },
                    ),
                    _SettingsItem(
                      icon: Icons.block,
                      title: 'Blocked Users',
                      subtitle: 'Manage blocked users',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Blocked users management coming soon! 🚫'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                _SettingsSection(
                  title: 'Content',
                  items: [
                    _SettingsItem(
                      icon: Icons.bookmark,
                      title: 'Saved Posts',
                      subtitle: 'View your saved posts',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Saved posts coming soon! 🔖'),
                            backgroundColor: Colors.amber,
                          ),
                        );
                      },
                    ),
                    _SettingsItem(
                      icon: Icons.history,
                      title: 'Activity',
                      subtitle: 'Your likes, comments, and shares',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Activity history coming soon! 📊'),
                            backgroundColor: Colors.indigo,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                _SettingsSection(
                  title: 'Support',
                  items: [
                    _SettingsItem(
                      icon: Icons.help,
                      title: 'Help & Support',
                      subtitle: 'Get help with the app',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Help center coming soon! 💬'),
                            backgroundColor: Colors.teal,
                          ),
                        );
                      },
                    ),
                    _SettingsItem(
                      icon: Icons.feedback,
                      title: 'Send Feedback',
                      subtitle: 'Help us improve the app',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Feedback form coming soon! 📝'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                    ),
                    _SettingsItem(
                      icon: Icons.info,
                      title: 'About',
                      subtitle: 'App version and information',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.grey[900],
                            title: const Text(
                              'About ItoBound',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: const Text(
                              'ItoBound v1.0.0\n\nA modern dating app built with Flutter.\n\nFind your perfect match with our advanced matching algorithm and beautiful interface.\n\n© 2024 ItoBound',
                              style: TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Sign out button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        final shouldSignOut = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Sign Out'),
                            content: const Text('Are you sure you want to sign out?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Sign Out'),
                              ),
                            ],
                          ),
                        );

                        if (shouldSignOut == true) {
                          await ref.read(authNotifierProvider.notifier).signOut();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...items.map((item) => _buildSettingsItem(context, item)),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildSettingsItem(BuildContext context, _SettingsItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (item.trailing != null) ...[
                const SizedBox(width: 8),
                item.trailing!,
              ],
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailing,
  });
}