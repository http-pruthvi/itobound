import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/ito_bound_theme.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  double _minAge = 18;
  double _maxAge = 35;
  double _maxDistance = 50;
  String _lookingFor = 'Everyone';
  bool _showMeOnItoBound = true;
  bool _globalMode = false;

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
                      'Discovery Preferences',
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
                      // Age Range
                      _buildPreferenceSection(
                        'Age Range',
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_minAge.round()}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${_maxAge.round()}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            RangeSlider(
                              values: RangeValues(_minAge, _maxAge),
                              min: 18,
                              max: 65,
                              divisions: 47,
                              activeColor: Colors.white,
                              inactiveColor: Colors.white.withOpacity(0.3),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _minAge = values.start;
                                  _maxAge = values.end;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Maximum Distance
                      _buildPreferenceSection(
                        'Maximum Distance',
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Distance',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${_maxDistance.round()} km',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Slider(
                              value: _maxDistance,
                              min: 1,
                              max: 100,
                              divisions: 99,
                              activeColor: Colors.white,
                              inactiveColor: Colors.white.withOpacity(0.3),
                              onChanged: (double value) {
                                setState(() {
                                  _maxDistance = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Looking For
                      _buildPreferenceSection(
                        'Show Me',
                        Column(
                          children: [
                            _buildLookingForOption('Everyone', _lookingFor == 'Everyone'),
                            const SizedBox(height: 12),
                            _buildLookingForOption('Men', _lookingFor == 'Men'),
                            const SizedBox(height: 12),
                            _buildLookingForOption('Women', _lookingFor == 'Women'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Discovery Settings
                      _buildPreferenceSection(
                        'Discovery Settings',
                        Column(
                          children: [
                            _buildSwitchOption(
                              'Show me on ItoBound',
                              'Control whether your profile is shown to others',
                              _showMeOnItoBound,
                              (value) => setState(() => _showMeOnItoBound = value),
                            ),
                            const SizedBox(height: 16),
                            _buildSwitchOption(
                              'Global Mode',
                              'See people from around the world',
                              _globalMode,
                              (value) => setState(() => _globalMode = value),
                              isPremium: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Save button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Preferences saved successfully! ✅'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Text(
                            'Save Preferences',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 800.ms, duration: 600.ms)
                          .slideY(begin: 0.3, end: 0),

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

  Widget _buildPreferenceSection(String title, Widget content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildLookingForOption(String option, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _lookingFor = option;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          option,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSwitchOption(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged, {
    bool isPremium = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isPremium) ...[
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
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: isPremium
              ? (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This feature requires Premium! 💎'),
                      backgroundColor: Colors.purple,
                    ),
                  );
                }
              : onChanged,
          activeColor: Colors.white,
          activeTrackColor: Colors.white.withOpacity(0.3),
          inactiveThumbColor: Colors.white.withOpacity(0.5),
          inactiveTrackColor: Colors.white.withOpacity(0.1),
        ),
      ],
    );
  }
}