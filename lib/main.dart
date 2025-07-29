import 'package:flutter/material.dart';
import 'theme/ito_bound_theme.dart';
import 'features/swipe/presentation/widgets/swipeable_profile_card.dart';
import 'dart:math';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDfOJ5k-gm27wRlzPfNVAxKBDeWQBGrPRw",
      authDomain: "dating-app-ab2d9.firebaseapp.com",
      projectId: "dating-app-ab2d9",
      storageBucket: "dating-app-ab2d9.firebasestorage.app",
      messagingSenderId: "42049923887",
      appId: "1:42049923887:web:3b52aa0357bf13b6f5cfda",
      measurementId: "G-M11HP82VYF",
    ),
  );
  runApp(const ItoBoundApp());
}

class ItoBoundApp extends StatefulWidget {
  const ItoBoundApp({Key? key}) : super(key: key);

  @override
  State<ItoBoundApp> createState() => _ItoBoundAppState();
}

class _ItoBoundAppState extends State<ItoBoundApp> {
  bool _isDarkMode = false;
  int _selectedIndex = 0;
  bool _showOnboarding = true;
  bool _showMatchAnimation = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _completeOnboarding() {
    setState(() {
      _showOnboarding = false;
    });
  }

  void _triggerMatchAnimation() async {
    setState(() {
      _showMatchAnimation = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _showMatchAnimation = false;
      });
    }
  }

  Widget _buildBody() {
    if (_showOnboarding) {
      return _OnboardingWalkthrough(onFinish: _completeOnboarding);
    }
    Widget mainContent;
    switch (_selectedIndex) {
      case 0:
        mainContent = SwipeScreen(
            currentUserId: FirebaseAuth.instance.currentUser?.uid ?? '');
        break;
      case 1:
        mainContent = ChatTab(
            currentUserId: FirebaseAuth.instance.currentUser?.uid ?? '');
        break;
      case 2:
        mainContent = _ProfileScreenPlaceholder(
            onToggleTheme: _toggleTheme, isDarkMode: _isDarkMode);
        break;
      default:
        mainContent = SwipeScreen(
            currentUserId: FirebaseAuth.instance.currentUser?.uid ?? '');
    }
    return Stack(
      children: [
        mainContent,
        _buildMatchOverlay(_showMatchAnimation),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Itobound Dating App',
      debugShowCheckedModeBanner: false,
      theme: itoBoundLightTheme,
      darkTheme: itoBoundDarkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: FirebaseAuthGate(
        child: Scaffold(
          extendBody: true,
          body: GradientBackground(
            child: SafeArea(
              child: _buildBody(),
            ),
          ),
          bottomNavigationBar: _CustomGlowingNavBar(
            selectedIndex: _selectedIndex,
            onTap: _onNavTap,
          ),
        ),
      ),
    );
  }
}

// Custom Glowing Bottom Navigation Bar
class _CustomGlowingNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _CustomGlowingNavBar(
      {Key? key, required this.selectedIndex, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavBarItemData(
          icon: Icons.local_fire_department,
          label: 'Swipe',
          gradient:
              LinearGradient(colors: [Color(0xFFFF6F61), Color(0xFFDE1D6F)])),
      _NavBarItemData(
          icon: Icons.chat_bubble_rounded,
          label: 'Chat',
          gradient:
              LinearGradient(colors: [Color(0xFF3A86FF), Color(0xFFDE1D6F)])),
      _NavBarItemData(
          icon: Icons.person,
          label: 'Profile',
          gradient:
              LinearGradient(colors: [Color(0xFFFFBE0B), Color(0xFFFF6F61)])),
    ];
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.white.withAlpha(29), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isSelected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 18 : 8, vertical: 8),
              decoration: isSelected
                  ? BoxDecoration(
                      gradient: item.gradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: item.gradient.colors.first.withAlpha(128),
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ],
                    )
                  : null,
              child: Row(
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return item.gradient.createShader(bounds);
                    },
                    child: Icon(
                      item.icon,
                      size: 28,
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withAlpha(179),
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      item.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavBarItemData {
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  const _NavBarItemData(
      {required this.icon, required this.label, required this.gradient});
}

// Chat Bubble Widget
class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String? time;
  const _ChatBubble(
      {Key? key, required this.text, required this.isMe, this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradient = isMe
        ? LinearGradient(colors: [Color(0xFFFF6F61), Color(0xFFDE1D6F)])
        : LinearGradient(colors: [Color(0xFF3A86FF), Color(0xFFDE1D6F)]);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 10,
          bottom: 4,
          left: isMe ? 40 : 12,
          right: isMe ? 12 : 40,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMe ? 20 : 6),
            topRight: Radius.circular(isMe ? 6 : 20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: isMe
                  ? Color(0xFFFF6F61).withAlpha(29)
                  : Color(0xFF3A86FF).withAlpha(29),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            if (time != null) ...[
              const SizedBox(height: 4),
              Text(
                time!,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white.withAlpha(179),
                      fontSize: 12,
                    ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// Pulse animation for chat send button
class _PulseIconButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  const _PulseIconButton(
      {Key? key, required this.onPressed, required this.icon})
      : super(key: key);

  @override
  State<_PulseIconButton> createState() => _PulseIconButtonState();
}

class _PulseIconButtonState extends State<_PulseIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.15)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: IconButton(
        icon: widget.icon,
        onPressed: widget.onPressed,
      ),
    );
  }
}

// Animated Profile Progress Ring
class _ProfileProgressRing extends StatefulWidget {
  final double percent; // 0.0 to 1.0
  const _ProfileProgressRing({Key? key, required this.percent})
      : super(key: key);

  @override
  State<_ProfileProgressRing> createState() => _ProfileProgressRingState();
}

class _ProfileProgressRingState extends State<_ProfileProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(begin: 0, end: widget.percent).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _ProfileProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percent != widget.percent) {
      _animation = Tween<double>(begin: _animation.value, end: widget.percent)
          .animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 130,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _RingPainter(percent: _animation.value),
            child: Center(child: child),
          );
        },
        child: Center(
          child: Text(
            '${(widget.percent * 100).round()}%',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double percent;
  _RingPainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = SweepGradient(
      startAngle: -pi / 2,
      endAngle: 3 * pi / 2,
      colors: [
        Color(0xFFFF6F61),
        Color(0xFFDE1D6F),
        Color(0xFF3A86FF),
        Color(0xFFFFBE0B),
        Color(0xFFFF6F61),
      ],
      stops: [0.0, 0.3, 0.6, 0.85, 1.0],
      transform: GradientRotation(-pi / 2),
    );
    final backgroundPaint = Paint()
      ..color = Colors.white.withAlpha(13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    final progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;
    // Draw background ring
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      0,
      2 * pi,
      false,
      backgroundPaint,
    );
    // Draw progress arc
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -pi / 2,
      2 * pi * percent,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.percent != percent;
}

// Tinder-style Profile Page
class _ProfileScreenPlaceholder extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  const _ProfileScreenPlaceholder(
      {Key? key, required this.onToggleTheme, required this.isDarkMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = _TinderProfileData(
      name: 'Alex Johnson',
      age: 26,
      location: 'San Francisco, CA',
      bio: 'Designer. Dreamer. Coffee lover. Let’s vibe! 🌈✨',
      interests: ['Art', 'Travel', 'Coffee', 'Music', 'Hiking', 'Yoga'],
      photos: [
        'https://images.unsplash.com/photo-1517841905240-472988babdf9',
        'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91',
        'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
      ],
      avatar: 'https://randomuser.me/api/portraits/men/32.jpg',
      isPremium: true,
    );
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E1E1E), Color(0xFFDE1D6F), Color(0xFFFF6F61)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top photo with overlay
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 380,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                      child: Image.network(
                        user.photos[0],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 380,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(
                              child: const CircularProgressIndicator(
                                  color: Colors.white));
                        },
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(36),
                          bottomRight: Radius.circular(36),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withAlpha(143),
                            Colors.transparent,
                            Colors.black.withAlpha(167),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Name, age, location
                  Positioned(
                    left: 24,
                    bottom: 32,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          user.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(29),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${user.age}',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.location_on,
                            color: Colors.white.withAlpha(204), size: 22),
                        Text(
                          user.location,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withAlpha(230),
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  // Edit/profile actions
                  Positioned(
                    right: 24,
                    top: 32,
                    child: Row(
                      children: [
                        if (user.isPremium)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(colors: [
                                Color(0xFFFFBE0B),
                                Color(0xFFDE1D6F)
                              ]),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFFFBE0B).withAlpha(29),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star, color: Colors.white, size: 18),
                                const SizedBox(width: 6),
                                Text('Premium',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(29),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Bio
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                child: Text(
                  user.bio,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withAlpha(237),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.left,
                ),
              ),
              // Interests
              if (user.interests.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: user.interests
                        .map((interest) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF3A86FF),
                                  Color(0xFFDE1D6F)
                                ]),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF3A86FF).withAlpha(18),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                interest,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              const SizedBox(height: 24),
              // Photos carousel
              if (user.photos.length > 1)
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: user.photos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, i) => ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        user.photos[i],
                        width: 100,
                        height: 120,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                              width: 100,
                              height: 120,
                              color: Colors.white.withAlpha(30),
                              child: const Center(
                                  child: const CircularProgressIndicator(
                                      color: Colors.white)));
                        },
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              // Theme toggle button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ElevatedButton(
                  onPressed: onToggleTheme,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 6,
                    shadowColor: Colors.black.withAlpha(29),
                  ),
                  child: Text(
                    isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _TinderProfileData {
  final String name;
  final int age;
  final String location;
  final String bio;
  final List<String> interests;
  final List<String> photos;
  final String avatar;
  final bool isPremium;
  _TinderProfileData({
    required this.name,
    required this.age,
    required this.location,
    required this.bio,
    required this.interests,
    required this.photos,
    required this.avatar,
    required this.isPremium,
  });
}

// Onboarding Walkthrough with fade/scale transition
class _OnboardingWalkthrough extends StatefulWidget {
  final VoidCallback onFinish;
  const _OnboardingWalkthrough({Key? key, required this.onFinish})
      : super(key: key);

  @override
  State<_OnboardingWalkthrough> createState() => _OnboardingWalkthroughState();
}

class _OnboardingWalkthroughState extends State<_OnboardingWalkthrough> {
  int _page = 0;
  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      title: 'Swipe with Style',
      desc:
          'Discover amazing people nearby. Swipe right to like, left to pass.',
      lottieUrl: 'https://assets2.lottiefiles.com/packages/lf20_1pxqjqps.json',
    ),
    _OnboardingPageData(
      title: 'It’s a Match!',
      desc:
          'When you both like each other, it’s a match! Celebrate with a fun animation.',
      lottieUrl: 'https://assets2.lottiefiles.com/packages/lf20_0yfsb3a1.json',
    ),
    _OnboardingPageData(
      title: 'Chat & Connect',
      desc: 'Start a conversation and make real connections.',
      lottieUrl: 'https://assets2.lottiefiles.com/packages/lf20_2ks3pjua.json',
    ),
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      setState(() {
        _page++;
      });
    } else {
      widget.onFinish();
    }
  }

  void _skip() {
    widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_page];
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: SafeArea(
        key: ValueKey(_page),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _LottieWithFallback(url: page.lottieUrl),
              ),
              const SizedBox(height: 16),
              Text(
                page.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                page.desc,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withAlpha(230),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _page == i ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _page == i
                          ? Colors.white
                          : Colors.white.withAlpha(77),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _skip,
                    child: const Text('Skip',
                        style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      elevation: 6,
                      shadowColor: Colors.black.withAlpha(29),
                    ),
                    child: Text(
                      _page == _pages.length - 1 ? 'Get Started' : 'Next',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final String title;
  final String desc;
  final String lottieUrl;
  const _OnboardingPageData(
      {required this.title, required this.desc, required this.lottieUrl});
}

class _LottieWithFallback extends StatelessWidget {
  final String url;
  const _LottieWithFallback({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: precacheImage(NetworkImage(url), context, onError: (_, __) {}),
      builder: (context, snapshot) {
        return Lottie.network(
          url,
          repeat: true,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stack) => Center(
              child: Text('Animation failed to load',
                  style: TextStyle(color: Colors.white70))),
        );
      },
    );
  }
}

// Example usage with placeholder data
class SwipeableProfileCardDemo extends StatelessWidget {
  final VoidCallback? onLike;
  const SwipeableProfileCardDemo({Key? key, this.onLike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwipeableProfileCard(
      imageUrls: [
        'https://images.unsplash.com/photo-1517841905240-472988babdf9',
        'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91',
        'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
      ],
      name: 'Alex',
      age: 26,
      bio: 'Designer. Dreamer. Coffee lover. Let’s vibe!',
      onLike: onLike,
      onSuperLike: null,
      onDislike: null,
    );
  }
}

// Update FirebaseAuthGate to check for profile completion
class FirebaseAuthGate extends StatelessWidget {
  final Widget child;
  const FirebaseAuthGate({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const LoginPage();
        }
        final user = snapshot.data!;
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, profileSnap) {
            if (profileSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!profileSnap.hasData || !profileSnap.data!.exists) {
              return ProfileOnboardingPage(user: user);
            }
            return child;
          },
        );
      },
    );
  }
}

// Profile Onboarding Page
class ProfileOnboardingPage extends StatefulWidget {
  final User user;
  const ProfileOnboardingPage({Key? key, required this.user}) : super(key: key);
  @override
  State<ProfileOnboardingPage> createState() => _ProfileOnboardingPageState();
}

class _ProfileOnboardingPageState extends State<ProfileOnboardingPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();
  final List<String> _interests = [];
  bool _loading = false;
  String? _error;

  final List<String> _allInterests = [
    'Art',
    'Travel',
    'Coffee',
    'Music',
    'Hiking',
    'Yoga',
    'Movies',
    'Tech',
    'Food',
    'Fitness',
    'Books',
    'Pets',
    'Gaming',
    'Outdoors',
    'Dancing',
    'Sports',
    'Photography',
    'Fashion',
    'Writing',
    'Volunteering'
  ];

  void _toggleInterest(String interest) {
    setState(() {
      if (_interests.contains(interest)) {
        _interests.remove(interest);
      } else {
        _interests.add(interest);
      }
    });
  }

  void _saveProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim());
    final bio = _bioController.text.trim();
    if (name.isEmpty ||
        age == null ||
        age < 18 ||
        bio.isEmpty ||
        _interests.isEmpty) {
      setState(() {
        _error = 'Please fill all fields, age >= 18, and select interests.';
        _loading = false;
      });
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .set({
        'name': name,
        'age': age,
        'bio': bio,
        'interests': _interests,
        'email': widget.user.email,
        'createdAt': FieldValue.serverTimestamp(),
        // 'photoUrl': '', // Add photo upload later
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to save profile.';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Set up your profile',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Colors.white)),
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    filled: true,
                    fillColor: Colors.white.withAlpha(18),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.person, color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    hintText: 'Age (18+)',
                    filled: true,
                    fillColor: Colors.white.withAlpha(18),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.cake, color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _bioController,
                  decoration: InputDecoration(
                    hintText: 'Bio',
                    filled: true,
                    fillColor: Colors.white.withAlpha(18),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon:
                        const Icon(Icons.info_outline, color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
                Text('Select your interests',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: _allInterests
                      .map((interest) => GestureDetector(
                            onTap: () => _toggleInterest(interest),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: _interests.contains(interest)
                                    ? LinearGradient(colors: [
                                        Color(0xFF3A86FF),
                                        Color(0xFFDE1D6F)
                                      ])
                                    : LinearGradient(colors: [
                                        Colors.white.withAlpha(30),
                                        Colors.white.withAlpha(16)
                                      ]),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  if (_interests.contains(interest))
                                    BoxShadow(
                                      color: Color(0xFF3A86FF).withAlpha(18),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                ],
                              ),
                              child: Text(
                                interest,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!,
                      style: const TextStyle(color: Colors.redAccent)),
                ],
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('Continue',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Login Page
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  void _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome to Itobound',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Colors.white)),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white.withAlpha(18),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.email, color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white.withAlpha(18),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!,
                      style: const TextStyle(color: Colors.redAccent)),
                ],
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 18),
                TextButton(
                  onPressed: _goToRegister,
                  child: const Text('Don’t have an account? Register',
                      style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Register Page
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  void _register() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Create Account',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: Colors.white)),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white.withAlpha(18),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.email, color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white.withAlpha(18),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!,
                      style: const TextStyle(color: Colors.redAccent)),
                ],
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('Register',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Lottie match animation overlay: add fade/scale transition
Widget _buildMatchOverlay(bool show) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 500),
    transitionBuilder: (child, animation) => ScaleTransition(
      scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
      child: FadeTransition(opacity: animation, child: child),
    ),
    child: show
        ? Container(
            key: const ValueKey('match'),
            color: Colors.black.withAlpha(179),
            child: Center(
              child: _LottieWithFallback(
                url:
                    'https://assets2.lottiefiles.com/packages/lf20_0yfsb3a1.json',
              ),
            ),
          )
        : const SizedBox.shrink(),
  );
}

// Firestore user model
class AppUser {
  final String id;
  final String name;
  final int age;
  final String bio;
  final List<String> interests;
  final String? photoUrl;
  AppUser({
    required this.id,
    required this.name,
    required this.age,
    required this.bio,
    required this.interests,
    this.photoUrl,
  });
  factory AppUser.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      name: data['name'] ?? '',
      age: data['age'] ?? 18,
      bio: data['bio'] ?? '',
      interests: List<String>.from(data['interests'] ?? []),
      photoUrl: data['photoUrl'] as String?,
    );
  }
}

// Swipe screen with real user data
class SwipeScreen extends StatefulWidget {
  final String currentUserId;
  const SwipeScreen({Key? key, required this.currentUserId}) : super(key: key);
  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  List<AppUser> _users = [];
  int _currentIndex = 0;
  bool _loading = true;
  Set<String> _swipedUserIds = {};

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _loading = true);
    // Get swiped user IDs
    final swipesSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUserId)
        .collection('swipes')
        .get();
    _swipedUserIds = swipesSnap.docs.map((doc) => doc.id).toSet();
    // Get all users except current and already swiped
    final query = await FirebaseFirestore.instance.collection('users').get();
    final users = query.docs
        .where((doc) =>
            doc.id != widget.currentUserId && !_swipedUserIds.contains(doc.id))
        .map((doc) => AppUser.fromDoc(doc))
        .toList();
    setState(() {
      _users = users;
      _currentIndex = 0;
      _loading = false;
    });
  }

  Future<void> _handleSwipe(String action) async {
    if (_currentIndex >= _users.length) return;
    final swipedUser = _users[_currentIndex];
    // Store swipe in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUserId)
        .collection('swipes')
        .doc(swipedUser.id)
        .set({'action': action, 'timestamp': FieldValue.serverTimestamp()});
    // If like, check for match
    if (action == 'like') {
      final theirSwipe = await FirebaseFirestore.instance
          .collection('users')
          .doc(swipedUser.id)
          .collection('swipes')
          .doc(widget.currentUserId)
          .get();
      if (theirSwipe.exists && theirSwipe.data()?['action'] == 'like') {
        // It's a match! Store in matches collection for both users
        final matchId = [widget.currentUserId, swipedUser.id]..sort();
        final matchDocId = matchId.join('_');
        await FirebaseFirestore.instance
            .collection('matches')
            .doc(matchDocId)
            .set({
          'users': [widget.currentUserId, swipedUser.id],
          'createdAt': FieldValue.serverTimestamp(),
        });
        // Optionally, create a chat document
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(matchDocId)
            .set({
          'users': [widget.currentUserId, swipedUser.id],
          'createdAt': FieldValue.serverTimestamp(),
        });
        // Show match animation (call parent if needed)
        if (mounted) {
          final parent = context.findAncestorStateOfType<_ItoBoundAppState>();
          parent?._triggerMatchAnimation();
        }
      }
    }
    // Haptic feedback for swipe
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
    setState(() {
      _currentIndex++;
      _swipedUserIds.add(swipedUser.id);
    });
  }

  void _onLike() => _handleSwipe('like');
  void _onDislike() => _handleSwipe('dislike');

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_dissatisfied, color: Colors.white70, size: 64),
            const SizedBox(height: 16),
            Text('No users to swipe on right now!',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white70)),
          ],
        ),
      );
    }
    if (_currentIndex >= _users.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white70, size: 64),
            const SizedBox(height: 16),
            Text('You have swiped on everyone!',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white70)),
          ],
        ),
      );
    }
    final user = _users[_currentIndex];
    return SwipeableProfileCard(
      imageUrls: user.photoUrl != null
          ? [user.photoUrl!]
          : [
              'https://images.unsplash.com/photo-1517841905240-472988babdf9',
            ],
      name: user.name,
      age: user.age,
      bio: user.bio,
      onLike: _onLike,
      onDislike: _onDislike,
      onSuperLike: () => _handleSwipe('superlike'),
    );
  }
}

// Profile page with real user data
class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _editing = false;
  bool _saving = false;
  String? _error;
  String? _photoUrl;
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();
  final List<String> _interests = [];
  final List<String> _allInterests = [
    'Art',
    'Travel',
    'Coffee',
    'Music',
    'Hiking',
    'Yoga',
    'Movies',
    'Tech',
    'Food',
    'Fitness',
    'Books',
    'Pets',
    'Gaming',
    'Outdoors',
    'Dancing',
    'Sports',
    'Photography',
    'Fashion',
    'Writing',
    'Volunteering'
  ];

  void _startEdit(AppUser user) {
    setState(() {
      _editing = true;
      _error = null;
      _photoUrl = user.photoUrl;
      _nameController.text = user.name;
      _ageController.text = user.age.toString();
      _bioController.text = user.bio;
      _interests.clear();
      _interests.addAll(user.interests);
    });
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _saving = true);
      final ref = FirebaseStorage.instance.ref().child(
          'profile_photos/${widget.userId}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putData(await picked.readAsBytes());
      final url = await ref.getDownloadURL();
      setState(() {
        _photoUrl = url;
        _saving = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim());
    final bio = _bioController.text.trim();
    if (name.isEmpty ||
        age == null ||
        age < 18 ||
        bio.isEmpty ||
        _interests.isEmpty) {
      setState(() {
        _error = 'Please fill all fields, age >= 18, and select interests.';
        _saving = false;
      });
      return;
    }
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'name': name,
        'age': age,
        'bio': bio,
        'interests': _interests,
        if (_photoUrl != null) 'photoUrl': _photoUrl,
      });
      setState(() {
        _editing = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to save profile.';
      });
    } finally {
      setState(() {
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(
              child: Text('Profile not found',
                  style: TextStyle(color: Colors.white70)));
        }
        final user = AppUser.fromDoc(snapshot.data!);
        if (_editing) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1E1E1E),
                    Color(0xFFDE1D6F),
                    Color(0xFFFF6F61)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: _photoUrl != null
                                  ? NetworkImage(_photoUrl!)
                                  : null,
                              child: _photoUrl == null
                                  ? const Icon(Icons.person, size: 60)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _saving ? null : _pickPhoto,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.camera_alt,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _ageController,
                        decoration:
                            const InputDecoration(labelText: 'Age (18+)'),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _bioController,
                        decoration: const InputDecoration(labelText: 'Bio'),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      Text('Interests',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: _allInterests
                            .map((interest) => GestureDetector(
                                  onTap: _saving
                                      ? null
                                      : () {
                                          setState(() {
                                            if (_interests.contains(interest)) {
                                              _interests.remove(interest);
                                            } else {
                                              _interests.add(interest);
                                            }
                                          });
                                        },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      gradient: _interests.contains(interest)
                                          ? LinearGradient(colors: [
                                              Color(0xFF3A86FF),
                                              Color(0xFFDE1D6F)
                                            ])
                                          : LinearGradient(colors: [
                                              Colors.white.withAlpha(30),
                                              Colors.white.withAlpha(16)
                                            ]),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        if (_interests.contains(interest))
                                          BoxShadow(
                                            color:
                                                Color(0xFF3A86FF).withAlpha(18),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                      ],
                                    ),
                                    child: Text(
                                      interest,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(_error!,
                            style: const TextStyle(color: Colors.redAccent)),
                      ],
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saving ? null : _saveProfile,
                              child: _saving
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2))
                                  : const Text('Save'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _saving
                                  ? null
                                  : () => setState(() => _editing = false),
                              child: const Text('Cancel'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E1E1E), Color(0xFFDE1D6F), Color(0xFFFF6F61)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 380,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(36),
                            bottomRight: Radius.circular(36),
                          ),
                          child: Image.network(
                            user.photoUrl ??
                                'https://randomuser.me/api/portraits/men/32.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 380,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(
                                  child: const CircularProgressIndicator(
                                      color: Colors.white));
                            },
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(36),
                              bottomRight: Radius.circular(36),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withAlpha(143),
                                Colors.transparent,
                                Colors.black.withAlpha(167),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 24,
                        top: 32,
                        child: Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _startEdit(user),
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text('Edit Profile',
                                  semanticsLabel: 'Edit your profile'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withAlpha(29),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 24,
                        bottom: 32,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              user.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                  ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(29),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '${user.age}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 18),
                    child: Text(
                      user.bio,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withAlpha(237),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  if (user.interests.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: user.interests
                            .map((interest) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color(0xFF3A86FF),
                                      Color(0xFFDE1D6F)
                                    ]),
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF3A86FF).withAlpha(18),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    interest,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Chat tab: Matches list and chat screen
class ChatTab extends StatefulWidget {
  final String currentUserId;
  const ChatTab({Key? key, required this.currentUserId}) : super(key: key);
  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  String? _selectedChatId;
  String? _selectedMatchName;
  String? _selectedMatchPhoto;

  void _handleBack() {
    setState(() {
      _selectedChatId = null;
      _selectedMatchName = null;
      _selectedMatchPhoto = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedChatId != null) {
      return ChatScreen(
        chatId: _selectedChatId!,
        currentUserId: widget.currentUserId,
        matchName: _selectedMatchName ?? '',
        matchPhoto: _selectedMatchPhoto,
        onBack: _handleBack,
      );
    }
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('matches')
          .where('users', arrayContains: widget.currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final matches = snapshot.data?.docs ?? [];
        if (matches.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, color: Colors.white70, size: 64),
                const SizedBox(height: 16),
                Text('No matches yet!',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white70)),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          itemCount: matches.length,
          separatorBuilder: (_, __) => const Divider(color: Colors.white24),
          itemBuilder: (context, i) {
            final match = matches[i];
            final users = List<String>.from(match['users']);
            final otherUserId =
                users.firstWhere((id) => id != widget.currentUserId);
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(otherUserId)
                  .get(),
              builder: (context, userSnap) {
                if (!userSnap.hasData || !userSnap.data!.exists) {
                  return const SizedBox.shrink();
                }
                final user = AppUser.fromDoc(userSnap.data!);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child:
                        user.photoUrl == null ? const Icon(Icons.person) : null,
                  ),
                  title: Text(user.name,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(user.bio,
                      style: const TextStyle(color: Colors.white70)),
                  onTap: () => setState(() {
                    final matchId = [widget.currentUserId, otherUserId]..sort();
                    _selectedChatId = matchId.join('_');
                    _selectedMatchName = user.name;
                    _selectedMatchPhoto = user.photoUrl;
                  }),
                  tileColor: Colors.white.withAlpha((4 * 255).round()),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                );
              },
            );
          },
        );
      },
    );
  }
}

// Real-time chat screen
class ChatScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String matchName;
  final String? matchPhoto;
  final VoidCallback onBack;
  const ChatScreen(
      {Key? key,
      required this.chatId,
      required this.currentUserId,
      required this.matchName,
      this.matchPhoto,
      required this.onBack})
      : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  bool _sending = false;

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
      'sender': widget.currentUserId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((_) {
      _controller.clear();
      setState(() => _sending = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onBack,
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.matchPhoto != null
                  ? NetworkImage(widget.matchPhoto!)
                  : null,
              child:
                  widget.matchPhoto == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 12),
            Text(widget.matchName, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data?.docs ?? [];
                if (messages.isEmpty) {
                  return Center(
                    child: Text('Say hi!',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white70)),
                  );
                }
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final msg = messages[i];
                    final isMe = msg['sender'] == widget.currentUserId;
                    return _ChatBubble(
                      text: msg['text'],
                      isMe: isMe,
                      time: '',
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(8),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(8),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: [Color(0xFFFF6F61), Color(0xFFDE1D6F)]),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFF6F61).withAlpha(64),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _PulseIconButton(
                    icon: _sending
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.send, color: Colors.white),
                    onPressed: _sending ? null : () => _sendMessage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
