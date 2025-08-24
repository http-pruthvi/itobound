import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;
  final int age;
  final String bio;
  final List<String> photoUrls;
  final String? profilePictureUrl;
  final List<String> interests;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String gender;
  final String lookingFor;
  final bool isOnline;
  final DateTime lastSeen;
  final bool isPremium;
  final int maxDistance;
  final int minAge;
  final int maxAge;
  final bool showMe;
  final List<String> blockedUsers;
  final List<String> likedUsers;
  final List<String> dislikedUsers;
  final List<String> superLikedUsers;
  final List<String> matchedUsers;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? occupation;
  final String? education;
  final int? height;
  final String? relationshipType;
  final List<String> languages;
  final bool hasStory;
  final int boostCount;
  final int superLikeCount;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.bio,
    required this.photoUrls,
    this.profilePictureUrl,
    required this.interests,
    this.location,
    this.latitude,
    this.longitude,
    required this.gender,
    required this.lookingFor,
    required this.isOnline,
    required this.lastSeen,
    required this.isPremium,
    required this.maxDistance,
    required this.minAge,
    required this.maxAge,
    required this.showMe,
    required this.blockedUsers,
    required this.likedUsers,
    required this.dislikedUsers,
    required this.superLikedUsers,
    required this.matchedUsers,
    required this.createdAt,
    required this.updatedAt,
    this.occupation,
    this.education,
    this.height,
    this.relationshipType,
    required this.languages,
    required this.hasStory,
    required this.boostCount,
    required this.superLikeCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    String? bio,
    List<String>? photoUrls,
    String? profilePictureUrl,
    List<String>? interests,
    String? location,
    double? latitude,
    double? longitude,
    String? gender,
    String? lookingFor,
    bool? isOnline,
    DateTime? lastSeen,
    bool? isPremium,
    int? maxDistance,
    int? minAge,
    int? maxAge,
    bool? showMe,
    List<String>? blockedUsers,
    List<String>? likedUsers,
    List<String>? dislikedUsers,
    List<String>? superLikedUsers,
    List<String>? matchedUsers,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? occupation,
    String? education,
    int? height,
    String? relationshipType,
    List<String>? languages,
    bool? hasStory,
    int? boostCount,
    int? superLikeCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      photoUrls: photoUrls ?? this.photoUrls,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      interests: interests ?? this.interests,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      gender: gender ?? this.gender,
      lookingFor: lookingFor ?? this.lookingFor,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      isPremium: isPremium ?? this.isPremium,
      maxDistance: maxDistance ?? this.maxDistance,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      showMe: showMe ?? this.showMe,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      likedUsers: likedUsers ?? this.likedUsers,
      dislikedUsers: dislikedUsers ?? this.dislikedUsers,
      superLikedUsers: superLikedUsers ?? this.superLikedUsers,
      matchedUsers: matchedUsers ?? this.matchedUsers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      height: height ?? this.height,
      relationshipType: relationshipType ?? this.relationshipType,
      languages: languages ?? this.languages,
      hasStory: hasStory ?? this.hasStory,
      boostCount: boostCount ?? this.boostCount,
      superLikeCount: superLikeCount ?? this.superLikeCount,
    );
  }
}