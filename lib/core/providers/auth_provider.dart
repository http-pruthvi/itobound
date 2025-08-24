import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Stream<User?> build() {
    return FirebaseAuth.instance.authStateChanges();
  }

  // Google Sign In (disabled for demo)
  Future<UserCredential?> signInWithGoogle() async {
    throw Exception('Google sign in not available in demo mode');
  }

  // Phone Authentication
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      throw Exception('Phone verification failed: $e');
    }
  }

  Future<UserCredential> signInWithPhoneCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      
      // Create user profile if new user
      if (userCredential.user != null) {
        final existingUser = await ref.read(userServiceProvider).getUser(userCredential.user!.uid);
        if (existingUser == null) {
          await _createUserProfile(userCredential.user!, customName: 'Phone User');
        }
      }
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-verification-code':
          throw Exception('Invalid verification code. Please try again.');
        case 'invalid-verification-id':
          throw Exception('Invalid verification ID. Please request a new code.');
        case 'session-expired':
          throw Exception('Verification session expired. Please request a new code.');
        default:
          throw Exception('Phone sign in failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Phone sign in failed: $e');
    }
  }

  // Apple Sign In
  Future<UserCredential?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      
      // Create user profile if new user
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        await _createUserProfile(userCredential.user!);
      }
      
      return userCredential;
    } catch (e) {
      throw Exception('Apple sign in failed: $e');
    }
  }

  Future<UserCredential> signInAnonymously() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      
      // Create user profile if new user
      if (userCredential.user != null) {
        await _createUserProfile(userCredential.user!, customName: 'Guest User');
      }
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'operation-not-allowed':
          throw Exception('Anonymous sign-in is not enabled.');
        default:
          throw Exception('Guest sign in failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Guest sign in failed: $e');
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Check if user profile exists, create if not
      if (userCredential.user != null) {
        final userService = ref.read(userServiceProvider);
        final existingUser = await userService.getUser(userCredential.user!.uid);
        if (existingUser == null) {
          await _createUserProfile(userCredential.user!);
        }
      }
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found with this email address.');
        case 'wrong-password':
          throw Exception('Incorrect password.');
        case 'invalid-email':
          throw Exception('Invalid email address.');
        case 'user-disabled':
          throw Exception('This account has been disabled.');
        case 'too-many-requests':
          throw Exception('Too many failed attempts. Please try again later.');
        default:
          throw Exception('Sign in failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password, String name) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await userCredential.user?.updateDisplayName(name);
      
      // Create user profile
      if (userCredential.user != null) {
        await _createUserProfile(userCredential.user!, customName: name);
      }
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw Exception('Password is too weak. Please use at least 6 characters.');
        case 'email-already-in-use':
          throw Exception('An account already exists with this email address.');
        case 'invalid-email':
          throw Exception('Invalid email address.');
        case 'operation-not-allowed':
          throw Exception('Email/password accounts are not enabled.');
        default:
          throw Exception('Account creation failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Account creation failed: $e');
    }
  }



  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found with this email address.');
        case 'invalid-email':
          throw Exception('Invalid email address.');
        default:
          throw Exception('Password reset failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // Delete Account
  Future<void> deleteAccount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Delete user data from Firestore (commented out for demo)
        // await ref.read(userServiceProvider).deleteUser(user.uid);
        // Delete Firebase Auth account
        await user.delete();
      }
    } catch (e) {
      throw Exception('Account deletion failed: $e');
    }
  }

  Future<void> _createUserProfile(User user, {String? customName}) async {
    try {
      final userService = ref.read(userServiceProvider);
      
      // Check if user already exists
      final existingUser = await userService.getUser(user.uid);
      if (existingUser != null) {
        return; // User already exists, don't create duplicate
      }
      
      final newUser = UserModel(
        id: user.uid,
        name: customName ?? user.displayName ?? 'New User',
        email: user.email ?? 'user@itobound.com',
        age: 25,
        bio: 'Welcome to ItoBound! Edit your profile to get started.',
        photoUrls: user.photoURL != null ? [user.photoURL!] : [],
        profilePictureUrl: user.photoURL,
        interests: ['Music', 'Travel', 'Food'],
        location: 'Your City',
        latitude: 37.7749,
        longitude: -122.4194,
        gender: 'Other',
        lookingFor: 'Everyone',
        isOnline: true,
        lastSeen: DateTime.now(),
        isPremium: false,
        maxDistance: 50,
        minAge: 18,
        maxAge: 35,
        showMe: true,
        blockedUsers: [],
        likedUsers: [],
        dislikedUsers: [],
        superLikedUsers: [],
        matchedUsers: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        occupation: 'Professional',
        education: 'University',
        height: 170,
        relationshipType: 'Serious',
        languages: ['English'],
        hasStory: false,
        boostCount: 3,
        superLikeCount: 5,
      );
      
      await userService.createUser(newUser);
    } catch (e) {
      print('Error creating user profile: $e');
      // Don't throw error to prevent blocking authentication
    }
  }
}

@riverpod
UserService userService(UserServiceRef ref) {
  return UserService();
}