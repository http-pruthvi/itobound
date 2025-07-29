# ItoBound

A modern dating and social discovery app built with Flutter and Firebase.

## Features
- User authentication (email, Google, phone)
- Onboarding and profile setup (name, age, gender, bio, interests, photo)
- Swipeable discovery (Tinder-style cards)
- Matching and real-time chat
- Social feed (posts, likes, comments)
- Settings (theme switch, account)
- Clean, modern UI

## Getting Started

1. **Clone the repository**
2. **Install dependencies**
   ```
   flutter pub get
   ```
3. **Add your Firebase configuration**
   - Place your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the appropriate directories.
4. **Run the app**
   ```
   flutter run
   ```

## Folder Structure
- `lib/main.dart` - App entry point
- `lib/features/auth/` - Authentication flows
- `lib/features/profile/` - Profile and onboarding
- `lib/features/swipe/` - Swipe/discovery
- `lib/features/chat/` - Chat and messaging
- `lib/features/feed/` - Social feed
- `lib/features/settings/` - Settings page
- `lib/theme/` - App theme

## Requirements
- Flutter 3.x
- Firebase project (Firestore, Auth, Messaging, Analytics)

## License
MIT
