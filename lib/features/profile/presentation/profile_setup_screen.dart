import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/ito_bound_theme.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalPages = 4;

  // Form controllers
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  int _selectedAge = 25;
  String _selectedGender = '';
  String _lookingFor = '';
  List<String> _selectedInterests = [];

  final List<String> _availableInterests = [
    'Travel', 'Photography', 'Music', 'Fitness', 'Cooking', 'Art',
    'Reading', 'Movies', 'Gaming', 'Dancing', 'Hiking', 'Yoga',
    'Coffee', 'Wine', 'Fashion', 'Technology', 'Sports', 'Pets'
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeSetup();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeSetup() {
    // Save profile data (in a real app, this would save to Firebase)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully! 🎉'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Navigate back to profile
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: _currentPage > 0 ? _previousPage : null,
                    ),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (_currentPage + 1) / _totalPages,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    Text(
                      '${_currentPage + 1}/$_totalPages',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    _buildNamePage(),
                    _buildBasicInfoPage(),
                    _buildInterestsPage(),
                    _buildBioPage(),
                  ],
                ),
              ),

              // Continue button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _canContinue() ? _nextPage : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      _currentPage == _totalPages - 1 ? 'Complete Setup' : 'Continue',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canContinue() {
    switch (_currentPage) {
      case 0:
        return _nameController.text.isNotEmpty;
      case 1:
        return _selectedGender.isNotEmpty && _lookingFor.isNotEmpty;
      case 2:
        return _selectedInterests.isNotEmpty;
      case 3:
        return _bioController.text.isNotEmpty;
      default:
        return false;
    }
  }

  Widget _buildNamePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'What\'s your name?',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
          
          const SizedBox(height: 40),
          
          TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white, fontSize: 24),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 24,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
            ),
            onChanged: (value) => setState(() {}),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  Widget _buildBasicInfoPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Tell us about yourself',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 40),
          
          // Age selector
          Text(
            'Age: $_selectedAge',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          Slider(
            value: _selectedAge.toDouble(),
            min: 18,
            max: 65,
            divisions: 47,
            activeColor: Colors.white,
            inactiveColor: Colors.white.withOpacity(0.3),
            onChanged: (value) {
              setState(() {
                _selectedAge = value.round();
              });
            },
          ),
          
          const SizedBox(height: 30),
          
          // Gender selection
          const Text(
            'I am:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildGenderButton('Male', _selectedGender == 'Male'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildGenderButton('Female', _selectedGender == 'Female'),
              ),
            ],
          ),
          
          const SizedBox(height: 30),
          
          // Looking for selection
          const Text(
            'Looking for:',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildGenderButton('Men', _lookingFor == 'Male'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildGenderButton('Women', _lookingFor == 'Female'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (label == 'Male' || label == 'Female') {
            _selectedGender = label;
          } else if (label == 'Men') {
            _lookingFor = 'Male';
          } else if (label == 'Women') {
            _lookingFor = 'Female';
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInterestsPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            'What are you interested in?',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 20),
          
          Text(
            'Select at least 3 interests',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          
          const SizedBox(height: 30),
          
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _availableInterests.length,
              itemBuilder: (context, index) {
                final interest = _availableInterests[index];
                final isSelected = _selectedInterests.contains(interest);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedInterests.remove(interest);
                      } else {
                        _selectedInterests.add(interest);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Center(
                      child: Text(
                        interest,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Write a bio',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 20),
          
          Text(
            'Tell people a bit about yourself',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 40),
          
          TextField(
            controller: _bioController,
            maxLines: 5,
            maxLength: 500,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Write something interesting about yourself...',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              counterStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            onChanged: (value) => setState(() {}),
          ),
        ],
      ),
    );
  }
}