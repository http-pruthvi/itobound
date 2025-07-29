import 'package:flutter/material.dart';
import '../../auth/presentation/pages/splash_page.dart';
import '../../auth/presentation/pages/login_page.dart';
import '../../auth/presentation/pages/register_page.dart';
import '../../profile/presentation/pages/profile_onboarding_page.dart';
import '../../profile/presentation/pages/profile_page.dart';
import '../../settings/presentation/pages/settings_page.dart';
import '../../chat/presentation/pages/chat_list_page.dart';
import '../../chat/presentation/pages/chat_page.dart';
import '../../swipe/presentation/pages/swipe_page.dart';
import '../../feed/presentation/pages/feed_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const ProfileOnboardingPage());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case '/swipe':
        return MaterialPageRoute(builder: (_) => const SwipePage());
      case '/chatList':
        return MaterialPageRoute(builder: (_) => const ChatListPage());
      case '/chat':
        final matchId = settings.arguments as String?;
        if (matchId == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('No matchId provided for ChatPage')),
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => ChatPage(matchId: matchId));
      case '/feed':
        return MaterialPageRoute(builder: (_) => const FeedPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for \'${settings.name}\''),
            ),
          ),
        );
    }
  }
}
