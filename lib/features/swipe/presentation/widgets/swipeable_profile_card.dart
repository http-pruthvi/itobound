import 'package:flutter/material.dart';

class SwipeableProfileCard extends StatefulWidget {
  final List<String> photoUrls;
  final String name;
  final int age;
  final String bio;
  final VoidCallback? onLike;
  final VoidCallback? onSuperLike;
  final VoidCallback? onDislike;

  const SwipeableProfileCard({
    super.key,
    required this.photoUrls,
    required this.name,
    required this.age,
    required this.bio,
    this.onLike,
    this.onSuperLike,
    this.onDislike,
  });

  @override
  State<SwipeableProfileCard> createState() => _SwipeableProfileCardState();
}

class _SwipeableProfileCardState extends State<SwipeableProfileCard>
    with SingleTickerProviderStateMixin {
  double _dragX = 0;
  double _dragY = 0;
  int _currentImage = 0;
  late AnimationController _iconAnimController;
  String? _action; // 'like', 'superlike', 'dislike'

  @override
  void initState() {
    super.initState();
    _iconAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _iconAnimController.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragX += details.delta.dx;
      _dragY += details.delta.dy;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_dragX > 120) {
      _triggerAction('like');
      widget.onLike?.call();
    } else if (_dragX < -120) {
      _triggerAction('dislike');
      widget.onDislike?.call();
    } else if (_dragY < -100) {
      _triggerAction('superlike');
      widget.onSuperLike?.call();
    }
    setState(() {
      _dragX = 0;
      _dragY = 0;
    });
  }

  void _triggerAction(String action) {
    setState(() {
      _action = action;
    });
    _iconAnimController.forward(from: 0).then((_) {
      setState(() {
        _action = null;
      });
    });
  }

  void _nextImage() {
    setState(() {
      _currentImage = (_currentImage + 1) % widget.photoUrls.length;
    });
  }

  void _prevImage() {
    setState(() {
      _currentImage = (_currentImage - 1 + widget.photoUrls.length) %
          widget.photoUrls.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double rotation = _dragX / 300;
    final double verticalRotation = _dragY / 600;
    final theme = Theme.of(context);
    return Center(
      child: GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        onTap: _nextImage,
        onDoubleTap: _prevImage,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateZ(rotation)
            ..rotateX(verticalRotation),
          child: Stack(
            children: [
              // Glassmorphism card
              Container(
                width: 340,
                height: 480,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withAlpha(64),
                      Colors.white.withAlpha(25),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    width: 3,
                    color: Colors.white.withAlpha(102),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 32,
                      offset: const Offset(0, 16),
                    ),
                  ],
                  // Glassmorphism effect
                  backgroundBlendMode: BlendMode.overlay,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Stack(
                    children: [
                      // Image carousel with fade
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Image.network(
                          widget.photoUrls[_currentImage],
                          key: ValueKey(_currentImage),
                          fit: BoxFit.cover,
                          width: 340,
                          height: 480,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                        (progress.expectedTotalBytes ?? 1)
                                    : null,
                                color: theme.colorScheme.primary,
                              ),
                            );
                          },
                        ),
                      ),
                      // Gradient overlay for text readability
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withAlpha(179),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      // Profile info
                      Positioned(
                        left: 24,
                        bottom: 32,
                        right: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.name,
                                  style:
                                      theme.textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withAlpha(77),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(46),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    '${widget.age}',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.bio,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withAlpha(230),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Image carousel indicator
                      Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(widget.photoUrls.length, (i) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: _currentImage == i ? 18 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentImage == i
                                    ? Colors.white
                                    : Colors.white.withAlpha(102),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Microinteraction animated icons
              if (_action != null)
                Center(
                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _iconAnimController,
                      curve: Curves.elasticOut,
                    ),
                    child: _action == 'like'
                        ? Icon(Icons.favorite,
                            color: Colors.pinkAccent, size: 96)
                        : _action == 'superlike'
                            ? Icon(Icons.star,
                                color: Colors.blueAccent, size: 96)
                            : Icon(Icons.close, color: Colors.white, size: 96),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example usage with placeholder data
class SwipeableProfileCardDemo extends StatelessWidget {
  const SwipeableProfileCardDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwipeableProfileCard(
      photoUrls: const [
        'https://images.unsplash.com/photo-1517841905240-472988babdf9',
        'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91',
        'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
      ],
      name: 'Alex',
      age: 26,
      bio: 'Designer. Dreamer. Coffee lover. Let’s vibe!',
      onLike: null,
      onSuperLike: null,
      onDislike: null,
    );
  }
}
