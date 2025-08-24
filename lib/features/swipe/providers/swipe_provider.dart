import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/user_service.dart';
import '../../../core/services/demo_data_service.dart';
import '../../../core/providers/auth_provider.dart';

part 'swipe_provider.g.dart';

@riverpod
class SwipeNotifier extends _$SwipeNotifier {
  @override
  Future<List<UserModel>> build() async {
    final currentUser = ref.watch(authNotifierProvider).value;
    if (currentUser == null) return [];

    final userService = ref.read(userServiceProvider);
    
    // Get current user data for preferences
    final userData = await userService.getUser(currentUser.uid);
    
    // If user data doesn't exist or is incomplete, return demo data
    if (userData == null || userData.name.isEmpty) {
      return DemoDataService.getDemoUsers();
    }

    try {
      return await userService.getDiscoveryUsers(
        currentUser.uid,
        latitude: userData.latitude,
        longitude: userData.longitude,
        maxDistance: userData.maxDistance,
        minAge: userData.minAge,
        maxAge: userData.maxAge,
        gender: userData.lookingFor,
      );
    } catch (e) {
      // If there's an error fetching from Firestore, return demo data
      return DemoDataService.getDemoUsers();
    }
  }

  Future<bool> likeUser(String currentUserId, String targetUserId) async {
    final userService = ref.read(userServiceProvider);
    
    // Check if it's a match
    final targetUser = await userService.getUser(targetUserId);
    final isMatch = targetUser?.likedUsers.contains(currentUserId) ?? false;
    
    await userService.likeUser(currentUserId, targetUserId);
    
    // Remove user from current list
    state = state.whenData((users) => 
        users.where((user) => user.id != targetUserId).toList());
    
    return isMatch;
  }

  Future<bool> superLikeUser(String currentUserId, String targetUserId) async {
    final userService = ref.read(userServiceProvider);
    
    // Check if it's a match
    final targetUser = await userService.getUser(targetUserId);
    final isMatch = targetUser?.likedUsers.contains(currentUserId) ?? false;
    
    await userService.superLikeUser(currentUserId, targetUserId);
    
    // Remove user from current list
    state = state.whenData((users) => 
        users.where((user) => user.id != targetUserId).toList());
    
    return isMatch;
  }

  Future<void> dislikeUser(String currentUserId, String targetUserId) async {
    final userService = ref.read(userServiceProvider);
    await userService.dislikeUser(currentUserId, targetUserId);
    
    // Remove user from current list
    state = state.whenData((users) => 
        users.where((user) => user.id != targetUserId).toList());
  }

  Future<void> useBoost(String currentUserId) async {
    final userService = ref.read(userServiceProvider);
    final currentUser = await userService.getUser(currentUserId);
    
    if (currentUser == null || currentUser.boostCount <= 0) {
      throw Exception('No boosts remaining');
    }

    // Decrease boost count
    await userService.updateUser(currentUser.copyWith(
      boostCount: currentUser.boostCount - 1,
      updatedAt: DateTime.now(),
    ));
    
    // TODO: Implement boost logic (show user to more people)
  }

  Future<void> refreshUsers() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}