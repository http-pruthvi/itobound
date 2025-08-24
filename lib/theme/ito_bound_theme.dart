import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Spacing system - consistent spacing throughout the app
class ItoBoundSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

// Border radius system
class ItoBoundRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double full = 999.0;
}

// Elevation system
class ItoBoundElevation {
  static const double none = 0.0;
  static const double sm = 2.0;
  static const double md = 4.0;
  static const double lg = 8.0;
  static const double xl = 16.0;
}

// Gradient color definitions
const Gradient kPrimaryGradient = LinearGradient(
  colors: [Color(0xFFFF6F61), Color(0xFFDE1D6F)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
const Gradient kSecondaryGradient = LinearGradient(
  colors: [Color(0xFF3A86FF), Color(0xFFDE1D6F)],
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
);
const Gradient kAccentGradient = LinearGradient(
  colors: [Color(0xFFFFBE0B), Color(0xFFFF6F61)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

// Modern Color palette
class ItoBoundColors {
  // Primary colors - Indigo for discovery/swipe
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  
  // Secondary colors - Pink for social/chat
  static const Color secondary = Color(0xFFEC4899);
  static const Color secondaryLight = Color(0xFFF472B6);
  static const Color secondaryDark = Color(0xFFDB2777);
  
  // Accent colors - Emerald for profile/success
  static const Color accent = Color(0xFF10B981);
  static const Color accentLight = Color(0xFF34D399);
  static const Color accentDark = Color(0xFF059669);
  
  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Background colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF0F0F0F);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  static const Color surfaceElevatedLight = Color(0xFFFFFFFF);
  static const Color surfaceElevatedDark = Color(0xFF262626);
  
  // Text colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textLightSecondary = Color(0xFFD1D5DB);
  static const Color textLightTertiary = Color(0xFF9CA3AF);
  
  // Border and divider colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);
  static const Color divider = Color(0xFFF3F4F6);
  static const Color dividerDark = Color(0xFF1F2937);
  
  // Action colors for swipe functionality
  static const Color like = Color(0xFF10B981); // Green
  static const Color pass = Color(0xFF6B7280); // Gray
  static const Color superLike = Color(0xFF3B82F6); // Blue
  static const Color boost = Color(0xFFF59E0B); // Amber
  
  // Overlay colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  
  // Legacy colors for compatibility
  static const Color primaryCoral = primary;
  static const Color primaryPink = secondary;
  static const Color vividBlue = info;
  static const Color vibrantYellow = warning;
  static const Color accentMatch = accent;
  static const Color accentLike = like;
  static const Color accentSuperLike = superLike;
}

// Text styles with improved hierarchy and consistency
TextTheme itoBoundTextTheme(Brightness brightness) {
  final Color primaryTextColor = brightness == Brightness.dark
      ? ItoBoundColors.textLight
      : ItoBoundColors.textPrimary;
  final Color secondaryTextColor = brightness == Brightness.dark
      ? ItoBoundColors.textLightSecondary
      : ItoBoundColors.textSecondary;
  final Color tertiaryTextColor = brightness == Brightness.dark
      ? ItoBoundColors.textLightTertiary
      : ItoBoundColors.textTertiary;

  return TextTheme(
    // Display styles for hero text
    displayLarge: GoogleFonts.poppins(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: primaryTextColor,
      height: 1.2,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: primaryTextColor,
      height: 1.2,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: primaryTextColor,
      height: 1.3,
    ),
    
    // Headline styles for section headers
    headlineLarge: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: primaryTextColor,
      height: 1.3,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: primaryTextColor,
      height: 1.4,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: primaryTextColor,
      height: 1.4,
    ),
    
    // Title styles for cards and components
    titleLarge: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: primaryTextColor,
      height: 1.4,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: primaryTextColor,
      height: 1.4,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: primaryTextColor,
      height: 1.4,
    ),
    
    // Body text styles
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: primaryTextColor,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: secondaryTextColor,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: tertiaryTextColor,
      height: 1.4,
    ),
    
    // Label styles for buttons and UI elements
    labelLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: primaryTextColor,
      height: 1.2,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: primaryTextColor,
      height: 1.2,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: secondaryTextColor,
      height: 1.2,
    ),
  );
}

ThemeData itoBoundLightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: ItoBoundColors.backgroundLight,
  primaryColor: ItoBoundColors.primary,
  colorScheme: ColorScheme.light(
    primary: ItoBoundColors.primary,
    onPrimary: Colors.white,
    secondary: ItoBoundColors.secondary,
    onSecondary: Colors.white,
    tertiary: ItoBoundColors.accent,
    onTertiary: Colors.white,
    surface: ItoBoundColors.surfaceLight,
    onSurface: ItoBoundColors.textPrimary,
    surfaceContainerHighest: ItoBoundColors.surfaceElevatedLight,
    error: ItoBoundColors.error,
    onError: Colors.white,
    outline: ItoBoundColors.border,
    outlineVariant: ItoBoundColors.divider,
  ),
  textTheme: itoBoundTextTheme(Brightness.light),
  fontFamily: GoogleFonts.inter().fontFamily,
  
  // AppBar theme
  appBarTheme: AppBarTheme(
    backgroundColor: ItoBoundColors.surfaceLight,
    foregroundColor: ItoBoundColors.textPrimary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: ItoBoundColors.textPrimary,
    ),
    iconTheme: const IconThemeData(
      color: ItoBoundColors.textPrimary,
      size: 24,
    ),
  ),
  
  // Card theme
  cardTheme: CardThemeData(
    color: ItoBoundColors.surfaceLight,
    elevation: ItoBoundElevation.sm,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(ItoBoundRadius.lg),
    ),
    shadowColor: Colors.black.withOpacity(0.08),
    margin: const EdgeInsets.all(ItoBoundSpacing.sm),
  ),
  
  // Button themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ItoBoundColors.primary,
      foregroundColor: Colors.white,
      elevation: ItoBoundElevation.sm,
      padding: const EdgeInsets.symmetric(
        horizontal: ItoBoundSpacing.lg,
        vertical: ItoBoundSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ItoBoundRadius.md),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ItoBoundColors.primary,
      side: const BorderSide(color: ItoBoundColors.border),
      padding: const EdgeInsets.symmetric(
        horizontal: ItoBoundSpacing.lg,
        vertical: ItoBoundSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ItoBoundRadius.md),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: ItoBoundColors.primary,
      padding: const EdgeInsets.symmetric(
        horizontal: ItoBoundSpacing.md,
        vertical: ItoBoundSpacing.sm,
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  
  // Input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: ItoBoundColors.surfaceLight,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ItoBoundRadius.md),
      borderSide: const BorderSide(color: ItoBoundColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ItoBoundRadius.md),
      borderSide: const BorderSide(color: ItoBoundColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ItoBoundRadius.md),
      borderSide: const BorderSide(color: ItoBoundColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ItoBoundRadius.md),
      borderSide: const BorderSide(color: ItoBoundColors.error),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: ItoBoundSpacing.md,
      vertical: ItoBoundSpacing.md,
    ),
    hintStyle: GoogleFonts.inter(
      color: ItoBoundColors.textTertiary,
      fontSize: 16,
    ),
  ),
  
  // Divider theme
  dividerTheme: const DividerThemeData(
    color: ItoBoundColors.divider,
    thickness: 1,
    space: 1,
  ),
);

ThemeData itoBoundDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: ItoBoundColors.backgroundDark,
  primaryColor: ItoBoundColors.primary,
  colorScheme: ColorScheme.dark(
    primary: ItoBoundColors.primary,
    onPrimary: Colors.white,
    secondary: ItoBoundColors.secondary,
    onSecondary: Colors.white,
    tertiary: ItoBoundColors.accent,
    onTertiary: Colors.white,
    surface: ItoBoundColors.surfaceDark,
    onSurface: ItoBoundColors.textLight,
    surfaceContainerHighest: ItoBoundColors.surfaceElevatedDark,
    error: ItoBoundColors.error,
    onError: Colors.white,
    outline: ItoBoundColors.borderDark,
    outlineVariant: ItoBoundColors.dividerDark,
  ),
  textTheme: itoBoundTextTheme(Brightness.dark),
  fontFamily: GoogleFonts.inter().fontFamily,
  
  // AppBar theme
  appBarTheme: AppBarTheme(
    backgroundColor: ItoBoundColors.surfaceDark,
    foregroundColor: ItoBoundColors.textLight,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: ItoBoundColors.textLight,
    ),
    iconTheme: const IconThemeData(
      color: ItoBoundColors.textLight,
      size: 24,
    ),
  ),
  
  // Card theme
  cardTheme: CardThemeData(
    color: ItoBoundColors.surfaceDark,
    elevation: ItoBoundElevation.sm,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(ItoBoundRadius.lg),
    ),
    shadowColor: Colors.black.withOpacity(0.3),
    margin: const EdgeInsets.all(ItoBoundSpacing.sm),
  ),
  
  // Button themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ItoBoundColors.primary,
      foregroundColor: Colors.white,
      elevation: ItoBoundElevation.sm,
      padding: const EdgeInsets.symmetric(
        horizontal: ItoBoundSpacing.lg,
        vertical: ItoBoundSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ItoBoundRadius.md),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ItoBoundColors.primary,
      side: const BorderSide(color: ItoBoundColors.borderDark),
      padding: const EdgeInsets.symmetric(
        horizontal: ItoBoundSpacing.lg,
        vertical: ItoBoundSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ItoBoundRadius.md),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: ItoBoundColors.primary,
      padding: const EdgeInsets.symmetric(
        horizontal: ItoBoundSpacing.md,
        vertical: ItoBoundSpacing.sm,
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  
  // Input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: ItoBoundColors.surfaceElevatedDark,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ItoBoundRadius.md),
      borderSide: const BorderSide(color: ItoBoundColors.borderDark),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ItoBoundRadius.md),
      borderSide: const BorderSide(color: ItoBoundColors.borderDark),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ItoBoundRadius.md),
      borderSide: const BorderSide(color: ItoBoundColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(ItoBoundRadius.md),
      borderSide: const BorderSide(color: ItoBoundColors.error),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: ItoBoundSpacing.md,
      vertical: ItoBoundSpacing.md,
    ),
    hintStyle: GoogleFonts.inter(
      color: ItoBoundColors.textLightTertiary,
      fontSize: 16,
    ),
  ),
  
  // Divider theme
  dividerTheme: const DividerThemeData(
    color: ItoBoundColors.dividerDark,
    thickness: 1,
    space: 1,
  ),
);

/// Background widget with optional gradient support
class GradientBackground extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final Color? color;
  
  const GradientBackground({
    super.key,
    required this.child,
    this.gradient,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        color: color ?? (gradient == null ? Theme.of(context).scaffoldBackgroundColor : null),
      ),
      child: child,
    );
  }
}

/// Animated gradient background
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Gradient> gradients;
  final Duration duration;
  
  const AnimatedGradientBackground({
    super.key,
    required this.child,
    required this.gradients,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.gradients.length;
        });
        _controller.reset();
        _controller.forward();
      }
    });
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentGradient = widget.gradients[_currentIndex];
        final nextGradient = widget.gradients[(_currentIndex + 1) % widget.gradients.length];
        
        return Container(
          decoration: BoxDecoration(
            gradient: Gradient.lerp(currentGradient, nextGradient, _animation.value),
          ),
          child: widget.child,
        );
      },
    );
  }
}
