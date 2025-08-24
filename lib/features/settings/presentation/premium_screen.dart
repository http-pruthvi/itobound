import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/ito_bound_theme.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6A1B9A),
            Color(0xFFAD1457),
            Color(0xFFD81B60),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Premium',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Premium logo/icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.diamond,
                          size: 60,
                          color: Colors.white,
                        ),
                      )
                          .animate()
                          .scale(duration: 800.ms, curve: Curves.elasticOut)
                          .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3)),

                      const SizedBox(height: 32),

                      Text(
                        'Upgrade to Premium',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 600.ms)
                          .slideY(begin: 0.3, end: 0),

                      const SizedBox(height: 16),

                      Text(
                        'Unlock exclusive features and find your perfect match faster',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(delay: 600.ms, duration: 600.ms),

                      const SizedBox(height: 40),

                      // Premium features
                      ..._buildPremiumFeatures()
                          .asMap()
                          .entries
                          .map((entry) => entry.value
                              .animate()
                              .fadeIn(delay: (900 + entry.key * 200).ms, duration: 600.ms)
                              .slideX(begin: 0.3, end: 0)),

                      const SizedBox(height: 40),

                      // Pricing cards
                      _buildPricingCard(
                        'Monthly',
                        '\$9.99',
                        'per month',
                        false,
                      )
                          .animate()
                          .fadeIn(delay: 1500.ms, duration: 600.ms)
                          .slideY(begin: 0.3, end: 0),

                      const SizedBox(height: 16),

                      _buildPricingCard(
                        'Annual',
                        '\$59.99',
                        'per year (Save 50%)',
                        true,
                      )
                          .animate()
                          .fadeIn(delay: 1700.ms, duration: 600.ms)
                          .slideY(begin: 0.3, end: 0),

                      const SizedBox(height: 32),

                      // Subscribe button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Premium subscription coming soon! 💎'),
                                backgroundColor: Colors.purple,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 8,
                          ),
                          child: const Text(
                            'Start Premium',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 1900.ms, duration: 600.ms)
                          .slideY(begin: 0.3, end: 0),

                      const SizedBox(height: 16),

                      Text(
                        'Cancel anytime. Terms and conditions apply.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
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

  List<Widget> _buildPremiumFeatures() {
    final features = [
      _PremiumFeature(
        icon: Icons.favorite,
        title: 'Unlimited Likes',
        description: 'Like as many profiles as you want',
      ),
      _PremiumFeature(
        icon: Icons.star,
        title: '5 Super Likes Daily',
        description: 'Stand out with super likes',
      ),
      _PremiumFeature(
        icon: Icons.rocket_launch,
        title: 'Monthly Boost',
        description: 'Be seen by more people',
      ),
      _PremiumFeature(
        icon: Icons.visibility,
        title: 'See Who Likes You',
        description: 'Know who\'s interested before you swipe',
      ),
      _PremiumFeature(
        icon: Icons.undo,
        title: 'Rewind',
        description: 'Undo your last swipe',
      ),
      _PremiumFeature(
        icon: Icons.location_on,
        title: 'Passport',
        description: 'Swipe around the world',
      ),
    ];

    return features.map((feature) => _buildFeatureItem(feature)).toList();
  }

  Widget _buildFeatureItem(_PremiumFeature feature) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              feature.icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(String title, String price, String subtitle, bool isPopular) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPopular ? Colors.white : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? Colors.transparent : Colors.white.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: isPopular
            ? [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.pink],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'MOST POPULAR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (isPopular) const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: isPopular ? Colors.black : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: TextStyle(
              color: isPopular ? Colors.black : Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: isPopular ? Colors.black54 : Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumFeature {
  final IconData icon;
  final String title;
  final String description;

  const _PremiumFeature({
    required this.icon,
    required this.title,
    required this.description,
  });
}