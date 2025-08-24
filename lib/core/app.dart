import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/ito_bound_theme.dart';
import '../features/auth/presentation/auth_gate.dart';
import '../features/home/presentation/home_screen.dart';
import 'providers/auth_provider.dart';
import 'widgets/index.dart';

class ItoBoundApp extends ConsumerWidget {
  const ItoBoundApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'ItoBound - Modern Dating',
      debugShowCheckedModeBanner: false,
      theme: itoBoundLightTheme,
      darkTheme: itoBoundDarkTheme,
      themeMode: ThemeMode.dark, // Default to dark theme for modern look
      home: Consumer(
        builder: (context, ref, child) {
          final authState = ref.watch(authNotifierProvider);
          
          return authState.when(
            data: (user) {
              if (user != null) {
                return const HomeScreen();
              } else {
                return const AuthGate();
              }
            },
            loading: () => const Scaffold(
              body: Center(
                child: ItoBoundLoadingIndicator(
                  size: 32,
                  message: 'Loading...',
                ),
              ),
            ),
            error: (error, stack) => Scaffold(
              body: ItoBoundErrorState(
                title: 'Something went wrong',
                message: error.toString(),
                onAction: () {
                  // Retry authentication
                  ref.invalidate(authNotifierProvider);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}