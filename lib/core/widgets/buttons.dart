import 'package:flutter/material.dart';
import '../../theme/ito_bound_theme.dart';

/// Primary gradient button
class ItoBoundGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const ItoBoundGradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.gradient,
    this.isLoading = false,
    this.icon,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        gradient: gradient ?? kPrimaryGradient,
        borderRadius: BorderRadius.circular(ItoBoundRadius.md),
        boxShadow: [
          BoxShadow(
            color: (gradient?.colors.first ?? ItoBoundColors.primary).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(ItoBoundRadius.md),
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(
              horizontal: ItoBoundSpacing.lg,
              vertical: ItoBoundSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading) ...[
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ] else ...[
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: ItoBoundSpacing.sm),
                  ],
                  Text(
                    text,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Action button for swipe actions
class ItoBoundActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final String? tooltip;

  const ItoBoundActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    required this.backgroundColor,
    this.iconColor = Colors.white,
    this.size = 56,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(size / 2),
            child: Icon(
              icon,
              color: iconColor,
              size: size * 0.4,
            ),
          ),
        ),
      ),
    );
  }
}

/// Floating action button with gradient
class ItoBoundFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final String? tooltip;

  const ItoBoundFloatingActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.gradient,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? kPrimaryGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        tooltip: tooltip,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Icon button with background
class ItoBoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final String? tooltip;

  const ItoBoundIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 40,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    final iColor = iconColor ?? Theme.of(context).colorScheme.onSurface;

    return Tooltip(
      message: tooltip ?? '',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(ItoBoundRadius.sm),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(ItoBoundRadius.sm),
            child: Icon(
              icon,
              color: iColor,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}