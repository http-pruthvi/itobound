import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/models/user_model.dart';

class ModernSwipeCard extends StatefulWidget {
  final UserModel user;
  final bool isTopCard;
  final Function(String) onSwipeAction;

  const ModernSwipeCard({
    super.key,
    required this.user,
    required this.isTopCard,
    required this.onSwipeAction,
  });

  @override
  State<ModernSwipeCard> createState() => _ModernSwipeCardState();
}

class _ModernSwipeCardState extends State<ModernSwipeCard>
    with SingleTickerProviderStateMixin {
  double _dragX = 0;
  double _dragY = 0;
  int _currentImageIndex = 0;
  late AnimationController _actionIconController;
  String? _currentAction;

  @override
  void initState() {
    super.initState();
    _actionIconController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _actionIconController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!widget.isTopCard) return;
    
    setState(() {
      _dragX += details.delta.dx;
      _dragY += details.delta.dy;
    });

    // Show action indicators
    if (_dragX > 50) {
      _showActionIcon('like');
    } else if (_dragX < -50) {
      _showActionIcon('dislike');
    } else if (_dragY < -50) {
      _showActionIcon('superlike');
    } else {
      _hideActionIcon();
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (!widget.isTopCard) return;

    const threshold = 100.0;
    
    if (_dragX > threshold) {
      widget.onSwipeAction('like');
    } else if (_dragX < -threshold) {
      widget.onSwipeAction('dislike');
    } else if (_dragY < -threshold) {
      widget.onSwipeAction('superlike');
    } else {
      // Snap back
      setState(() {
        _dragX = 0;
        _dragY = 0;
      });
      _hideActionIcon();
    }
  }

  void _showActionIcon(String action) {
    if (_currentAction != action) {
      setState(() {
        _currentAction = action;
      });
      _actionIconController.forward();
    }
  }

  void _hideActionIcon() {
    if (_currentAction != null) {
      setState(() {
        _currentAction = null;
      });
      _actionIconController.reverse();
    }
  }

  void _nextImage() {
    if (widget.user.photoUrls.length > 1) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % widget.user.photoUrls.length;
      });
    }
  }

  void _previousImage() {
    if (widget.user.photoUrls.length > 1) {
      setState(() {
        _currentImageIndex = (_currentImageIndex - 1 + widget.user.photoUrls.length) % widget.user.photoUrls.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final rotation = _dragX / 300;
    final opacity = widget.isTopCard ? 1.0 : 0.8;
    
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..translate(_dragX, _dragY)
        ..rotateZ(rotation),
      child: Opacity(
        opacity: opacity,
        child: GestureDetector(
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Container(
            width: 340,
            height: 600,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Main image
                  Positioned.fill(
                    child: GestureDetector(
                      onTapUp: (details) {
                        final screenWidth = MediaQuery.of(context).size.width;
                        if (details.globalPosition.dx > screenWidth / 2) {
                          _nextImage();
                        } else {
                          _previousImage();
                        }
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: CachedNetworkImage(
                          key: ValueKey(_currentImageIndex),
                          imageUrl: widget.user.photoUrls.isNotEmpty 
                              ? widget.user.photoUrls[_currentImageIndex]
                              : '',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, size: 100),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Image indicators
                  if (widget.user.photoUrls.length > 1)
                    Positioned(
                      top: 20,
                      left: 20,
                      right: 20,
                      child: Row(
                        children: List.generate(
                          widget.user.photoUrls.length,
                          (index) => Expanded(
                            child: Container(
                              height: 4,
                              margin: EdgeInsets.only(
                                right: index < widget.user.photoUrls.length - 1 ? 4 : 0,
                              ),
                              decoration: BoxDecoration(
                                color: index == _currentImageIndex
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // User info
                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${widget.user.name}, ${widget.user.age}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (widget.user.isPremium)
                              Container(
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
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Premium',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        
                        if (widget.user.location != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white70,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.user.location!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                        
                        if (widget.user.bio.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            widget.user.bio,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        
                        if (widget.user.interests.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: widget.user.interests.take(3).map((interest) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  interest,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Action indicator overlay
                  if (_currentAction != null)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getActionColor(_currentAction!).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: ScaleTransition(
                            scale: _actionIconController,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: _getActionColor(_currentAction!),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getActionIcon(_currentAction!),
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Online indicator
                  if (widget.user.isOnline)
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      )
                          .animate(onPlay: (controller) => controller.repeat())
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.2, 1.2),
                            duration: 1000.ms,
                          )
                          .then()
                          .scale(
                            begin: const Offset(1.2, 1.2),
                            end: const Offset(1, 1),
                            duration: 1000.ms,
                          ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'like':
        return Colors.green;
      case 'dislike':
        return Colors.red;
      case 'superlike':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getActionIcon(String action) {
    switch (action) {
      case 'like':
        return Icons.favorite;
      case 'dislike':
        return Icons.close;
      case 'superlike':
        return Icons.star;
      default:
        return Icons.help;
    }
  }
}