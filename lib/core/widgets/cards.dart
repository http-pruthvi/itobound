import 'package:flutter/material.dart';
import '../../theme/ito_bound_theme.dart';

/// Base card component with consistent styling
class ItoBoundCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;

  const ItoBoundCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Card(
        color: backgroundColor,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(ItoBoundRadius.lg),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(ItoBoundRadius.lg),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(ItoBoundSpacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Glass morphism card effect
class ItoBoundGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double blur;
  final double opacity;

  const ItoBoundGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.blur = 10.0,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ItoBoundRadius.lg),
        color: Theme.of(context).colorScheme.surface.withOpacity(opacity),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ItoBoundRadius.lg),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(ItoBoundSpacing.md),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Profile card component
class ItoBoundProfileCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int age;
  final String? bio;
  final List<String>? tags;
  final VoidCallback? onTap;
  final Widget? overlay;

  const ItoBoundProfileCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.age,
    this.bio,
    this.tags,
    this.onTap,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return ItoBoundCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(ItoBoundRadius.lg),
                  topRight: Radius.circular(ItoBoundRadius.lg),
                ),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: const Icon(
                          Icons.person,
                          size: 64,
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (overlay != null) overlay!,
            ],
          ),
          // Content section
          Padding(
            padding: const EdgeInsets.all(ItoBoundSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name, $age',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (bio != null) ...[
                  const SizedBox(height: ItoBoundSpacing.xs),
                  Text(
                    bio!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (tags != null && tags!.isNotEmpty) ...[
                  const SizedBox(height: ItoBoundSpacing.sm),
                  Wrap(
                    spacing: ItoBoundSpacing.xs,
                    runSpacing: ItoBoundSpacing.xs,
                    children: tags!.take(3).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ItoBoundSpacing.sm,
                          vertical: ItoBoundSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(ItoBoundRadius.full),
                        ),
                        child: Text(
                          tag,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Info card for displaying key-value pairs
class ItoBoundInfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ItoBoundInfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ItoBoundCard(
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(ItoBoundSpacing.sm),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ItoBoundRadius.sm),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: ItoBoundSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: ItoBoundSpacing.xs),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Stat card for displaying metrics
class ItoBoundStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? color;

  const ItoBoundStatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Theme.of(context).colorScheme.primary;

    return ItoBoundCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: cardColor,
              size: 32,
            ),
            const SizedBox(height: ItoBoundSpacing.sm),
          ],
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: cardColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: ItoBoundSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}