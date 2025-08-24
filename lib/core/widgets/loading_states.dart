import 'package:flutter/material.dart';
import '../../theme/ito_bound_theme.dart';

/// Loading indicator with consistent styling
class ItoBoundLoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  final String? message;

  const ItoBoundLoadingIndicator({
    super.key,
    this.size,
    this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size ?? 24,
          height: size ?? 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: ItoBoundSpacing.md),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Full screen loading overlay
class ItoBoundLoadingOverlay extends StatelessWidget {
  final String? message;
  final bool isVisible;

  const ItoBoundLoadingOverlay({
    super.key,
    this.message,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      color: ItoBoundColors.overlay,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(ItoBoundSpacing.lg),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(ItoBoundRadius.lg),
          ),
          child: ItoBoundLoadingIndicator(
            size: 32,
            message: message ?? 'Loading...',
          ),
        ),
      ),
    );
  }
}

/// Skeleton loading for cards and lists
class ItoBoundSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ItoBoundSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<ItoBoundSkeleton> createState() => _ItoBoundSkeletonState();
}

class _ItoBoundSkeletonState extends State<ItoBoundSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline.withOpacity(_animation.value * 0.3),
            borderRadius: widget.borderRadius ?? BorderRadius.circular(ItoBoundRadius.sm),
          ),
        );
      },
    );
  }
}

/// Skeleton for profile cards
class ProfileCardSkeleton extends StatelessWidget {
  const ProfileCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(ItoBoundSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(ItoBoundRadius.lg),
      ),
      child: Column(
        children: [
          const ItoBoundSkeleton(
            width: double.infinity,
            height: 400,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ItoBoundRadius.lg),
              topRight: Radius.circular(ItoBoundRadius.lg),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(ItoBoundSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ItoBoundSkeleton(width: 150, height: 20),
                const SizedBox(height: ItoBoundSpacing.sm),
                const ItoBoundSkeleton(width: 100, height: 16),
                const SizedBox(height: ItoBoundSpacing.sm),
                ItoBoundSkeleton(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for chat list items
class ChatListSkeleton extends StatelessWidget {
  const ChatListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ItoBoundSpacing.md,
        vertical: ItoBoundSpacing.sm,
      ),
      child: Row(
        children: [
          const ItoBoundSkeleton(
            width: 48,
            height: 48,
            borderRadius: BorderRadius.all(Radius.circular(ItoBoundRadius.full)),
          ),
          const SizedBox(width: ItoBoundSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ItoBoundSkeleton(width: 120, height: 16),
                const SizedBox(height: ItoBoundSpacing.xs),
                ItoBoundSkeleton(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 14,
                ),
              ],
            ),
          ),
          const ItoBoundSkeleton(width: 40, height: 12),
        ],
      ),
    );
  }
}