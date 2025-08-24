import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../theme/ito_bound_theme.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  bool _isPremium = false;
  String _selectedPlan = 'monthly';
  
  @override
  void initState() {
    super.initState();
    _checkPremiumStatus();
  }

  Future<void> _checkPremiumStatus() async {
    setState(() => _isLoading = true);
    
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data();
      
      if (userData != null) {
        setState(() {
          _isPremium = userData['isPremium'] ?? false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking premium status: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _subscribeToPremium() async {
    setState(() => _isLoading = true);
    
    try {
      // In a real app, this would integrate with a payment processor
      // For this demo, we'll just update the user's premium status in Firestore
      
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('users').doc(user.uid).update({
        'isPremium': true,
        'premiumPlan': _selectedPlan,
        'premiumStartDate': FieldValue.serverTimestamp(),
        'premiumEndDate': DateTime.now().add(
          _selectedPlan == 'monthly' ? const Duration(days: 30) : const Duration(days: 365),
        ),
      });

      setState(() => _isPremium = true);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully subscribed to ItoBound Premium!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error subscribing to premium: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _cancelPremium() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Premium'),
        content: const Text(
          'Are you sure you want to cancel your premium subscription? You will lose access to premium features at the end of your billing period.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No, Keep Premium'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    ) ?? false;

    if (!confirmed) return;

    setState(() => _isLoading = true);
    
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('users').doc(user.uid).update({
        'isPremium': false,
        'premiumCancelDate': FieldValue.serverTimestamp(),
      });

      setState(() => _isPremium = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Premium subscription canceled')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error canceling premium: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ItoBound Premium'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Premium logo and title
                  const Icon(
                    Icons.diamond,
                    size: 80,
                    color: ItoBoundColors.primaryPink,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isPremium ? 'You are a Premium Member!' : 'Upgrade to Premium',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isPremium
                        ? 'Enjoy all the exclusive benefits'
                        : 'Unlock the full potential of ItoBound',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  
                  // Premium features
                  const Text(
                    'Premium Features',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    icon: Icons.favorite,
                    title: 'Unlimited Likes',
                    description: 'Like as many profiles as you want',
                  ),
                  _buildFeatureItem(
                    icon: Icons.visibility,
                    title: 'See Who Likes You',
                    description: 'View all users who have liked your profile',
                  ),
                  _buildFeatureItem(
                    icon: Icons.bolt,
                    title: '5 Super Likes Daily',
                    description: 'Stand out with Super Likes',
                  ),
                  _buildFeatureItem(
                    icon: Icons.rocket_launch,
                    title: 'Profile Boosts',
                    description: 'Get more visibility with monthly boosts',
                  ),
                  _buildFeatureItem(
                    icon: Icons.location_on,
                    title: 'Global Mode',
                    description: 'Match with people anywhere in the world',
                  ),
                  _buildFeatureItem(
                    icon: Icons.undo,
                    title: 'Unlimited Rewinds',
                    description: 'Change your mind? Undo your last swipe',
                  ),
                  const SizedBox(height: 32),
                  
                  // Subscription plans
                  if (!_isPremium) ...[  
                    const Text(
                      'Choose Your Plan',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildPlanCard(
                            title: 'Monthly',
                            price: '\$9.99',
                            description: 'Billed monthly',
                            isSelected: _selectedPlan == 'monthly',
                            onTap: () => setState(() => _selectedPlan = 'monthly'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildPlanCard(
                            title: 'Yearly',
                            price: '\$59.99',
                            description: 'Save 50%, billed annually',
                            isSelected: _selectedPlan == 'yearly',
                            onTap: () => setState(() => _selectedPlan = 'yearly'),
                            isBestValue: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _subscribeToPremium,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ItoBoundColors.primaryPink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Subscribe Now'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Subscription will automatically renew. Cancel anytime.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ] else ...[  
                    // Premium management
                    const Text(
                      'Manage Your Subscription',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              'Active Subscription',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedPlan == 'monthly' ? 'Monthly Plan' : 'Yearly Plan',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Next billing date: June 15, 2023',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: _cancelPremium,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                              ),
                              child: const Text('Cancel Subscription'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ItoBoundColors.primaryPink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: ItoBoundColors.primaryPink),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
    bool isBestValue = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 8 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: isSelected
                    ? Border.all(color: ItoBoundColors.primaryPink, width: 2)
                    : null,
              ),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: ItoBoundColors.primaryPink,
                    ),
                ],
              ),
            ),
            if (isBestValue)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: const BoxDecoration(
                    color: ItoBoundColors.primaryPink,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'BEST VALUE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}