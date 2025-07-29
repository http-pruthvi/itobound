import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
const Gradient kYellowGradient = LinearGradient(
  colors: [Color(0xFFFFBE0B), Color(0xFFFF6F61)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

// Color palette
class ItoBoundColors {
  static const Color primaryCoral = Color(0xFFFF6F61);
  static const Color primaryPink = Color(0xFFDE1D6F);
  static const Color vividBlue = Color(0xFF3A86FF);
  static const Color vibrantYellow = Color(0xFFFFBE0B);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF1E1E1E);
  static const Color accentMatch = Color(0xFF00FFB4);
  static const Color accentLike = Color(0xFFFF2E63);
  static const Color accentSuperLike = Color(0xFF3A86FF);
}

// Text styles
TextTheme itoBoundTextTheme(Brightness brightness) => TextTheme(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: brightness == Brightness.dark
            ? ItoBoundColors.backgroundLight
            : ItoBoundColors.primaryPink,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: brightness == Brightness.dark
            ? ItoBoundColors.backgroundLight
            : ItoBoundColors.primaryPink,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: brightness == Brightness.dark
            ? ItoBoundColors.backgroundLight
            : ItoBoundColors.primaryPink,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: brightness == Brightness.dark
            ? ItoBoundColors.backgroundLight
            : ItoBoundColors.primaryCoral,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: brightness == Brightness.dark
            ? ItoBoundColors.backgroundLight
            : ItoBoundColors.primaryCoral,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: brightness == Brightness.dark
            ? ItoBoundColors.backgroundLight
            : ItoBoundColors.primaryPink,
      ),
    );

ThemeData itoBoundLightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: ItoBoundColors.backgroundLight,
  primaryColor: ItoBoundColors.primaryCoral,
  colorScheme: ColorScheme.light(
    primary: ItoBoundColors.primaryCoral,
    secondary: ItoBoundColors.vividBlue,
    surface: ItoBoundColors.backgroundLight,
    onSurface: Colors.black,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
  ),
  textTheme: itoBoundTextTheme(Brightness.light),
  fontFamily: GoogleFonts.poppins().fontFamily,
);

ThemeData itoBoundDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: ItoBoundColors.backgroundDark,
  primaryColor: ItoBoundColors.primaryPink,
  colorScheme: ColorScheme.dark(
    primary: ItoBoundColors.primaryCoral,
    secondary: ItoBoundColors.vividBlue,
    surface: ItoBoundColors.backgroundDark,
    onSurface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
  ),
  textTheme: itoBoundTextTheme(Brightness.dark),
  fontFamily: GoogleFonts.poppins().fontFamily,
);

// Gradient background widget
class GradientBackground extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  const GradientBackground({
    super.key,
    required this.child,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? kPrimaryGradient,
      ),
      child: child,
    );
  }
}
