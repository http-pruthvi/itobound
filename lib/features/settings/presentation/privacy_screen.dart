import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/ito_bound_theme.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _showAge = true;
  bool _showDistance = true;
  bool _showOnlineStatus = true;
  bool _allowMessageRequests = true;
  bool _showReadReceipts = true;
  bool _incognitoMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
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
                      'Privacy & Safety',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildPrivacySection(
                        'Profile Visibility',
                        [
                          _PrivacySetting(
                            title: 'Show Age',
                            subtitle: 'Display your age on your profile',
                            value: _showAge,
                            onChanged: (value) => setState(() => _showAge = value),
                          ),
                          _PrivacySetting(
                            title: 'Show Distance',
                            subtitle: 'Display distance from other users',
                            value: _showDistance,
                            onChanged: (value) => setState(() => _showDistance = value),
                          ),
                          _PrivacySetting(
                            title: 'Show Online Status',
                            subtitle: 'Let others see when you\'re online',
                            value: _showOnlineStatus,
                            onChanged: (value) => setState(() => _showOnlineStatus = value),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      _buildPrivacySection(
                        'Messaging',
                        [
                          _PrivacySetting(
                            title: 'Allow Message Requests',
                            subtitle: 'Receive messages from people you haven\'t matched with',
                            value: _allowMessageRequests,
                            onChanged: (value) => setState(() => _allowMessageRequests = value),
                          ),
                          _PrivacySetting(
                            title: 'Read Receipts',
                            subtitle: 'Let others know when you\'ve read their messages',
                            value: _showReadReceipts,
                            onChanged: (value) => setState(() => _showReadReceipts = value),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      _buildPrivacySection(
                        'Discovery',
                        [
                          _PrivacySetting(
                            title: 'Incognito Mode',
                            subtitle: 'Only people you like can see your profile',
                            value: _incognitoMode,
                            onChanged: (value) => setState(() => _incognitoMode = value),
                            isPremium: true,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      _buildActionSection(),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacySection(String title, List<_PrivacySetting> settings) {
    return Container(
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
          ...settings.map((setting) => _buildPrivacySettingItem(setting)),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildPrivacySettingItem(_PrivacySetting setting) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      setting.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (setting.isPremium) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.purple, Colors.pink],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Premium',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  setting.subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: setting.value,
            onChanged: setting.isPremium
                ? (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('This feature requires Premium! 💎'),
                        backgroundColor: Colors.purple,
                      ),
                    );
                  }
                : setting.onChanged,
            activeColor: Colors.white,
            activeTrackColor: Colors.white.withOpacity(0.3),
            inactiveThumbColor: Colors.white.withOpacity(0.5),
            inactiveTrackColor: Colors.white.withOpacity(0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection() {
    return Container(
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
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Safety Actions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildActionItem(
            icon: Icons.report,
            title: 'Report a Problem',
            subtitle: 'Report inappropriate behavior or content',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report feature coming soon! 🚨'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
          _buildActionItem(
            icon: Icons.help,
            title: 'Safety Tips',
            subtitle: 'Learn how to stay safe while dating',
            onTap: () {
              _showSafetyTips();
            },
          ),
          _buildActionItem(
            icon: Icons.block,
            title: 'Blocked Users',
            subtitle: 'Manage your blocked users list',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Blocked users management coming soon! 🚫'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
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
                  icon,
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
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
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

  void _showSafetyTips() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Safety Tips'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('• Meet in public places for first dates'),
              SizedBox(height: 8),
              Text('• Tell a friend about your plans'),
              SizedBox(height: 8),
              Text('• Trust your instincts'),
              SizedBox(height: 8),
              Text('• Don\'t share personal information too quickly'),
              SizedBox(height: 8),
              Text('• Report suspicious behavior'),
              SizedBox(height: 8),
              Text('• Use the app\'s messaging system initially'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _PrivacySetting {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isPremium;

  const _PrivacySetting({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isPremium = false,
  });
}