// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      age: (json['age'] as num).toInt(),
      bio: json['bio'] as String,
      photoUrls:
          (json['photoUrls'] as List<dynamic>).map((e) => e as String).toList(),
      profilePictureUrl: json['profilePictureUrl'] as String?,
      interests:
          (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      gender: json['gender'] as String,
      lookingFor: json['lookingFor'] as String,
      isOnline: json['isOnline'] as bool,
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      isPremium: json['isPremium'] as bool,
      maxDistance: (json['maxDistance'] as num).toInt(),
      minAge: (json['minAge'] as num).toInt(),
      maxAge: (json['maxAge'] as num).toInt(),
      showMe: json['showMe'] as bool,
      blockedUsers: (json['blockedUsers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      likedUsers: (json['likedUsers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      dislikedUsers: (json['dislikedUsers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      superLikedUsers: (json['superLikedUsers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      matchedUsers: (json['matchedUsers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      occupation: json['occupation'] as String?,
      education: json['education'] as String?,
      height: (json['height'] as num?)?.toInt(),
      relationshipType: json['relationshipType'] as String?,
      languages:
          (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
      hasStory: json['hasStory'] as bool,
      boostCount: (json['boostCount'] as num).toInt(),
      superLikeCount: (json['superLikeCount'] as num).toInt(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'age': instance.age,
      'bio': instance.bio,
      'photoUrls': instance.photoUrls,
      'profilePictureUrl': instance.profilePictureUrl,
      'interests': instance.interests,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'gender': instance.gender,
      'lookingFor': instance.lookingFor,
      'isOnline': instance.isOnline,
      'lastSeen': instance.lastSeen.toIso8601String(),
      'isPremium': instance.isPremium,
      'maxDistance': instance.maxDistance,
      'minAge': instance.minAge,
      'maxAge': instance.maxAge,
      'showMe': instance.showMe,
      'blockedUsers': instance.blockedUsers,
      'likedUsers': instance.likedUsers,
      'dislikedUsers': instance.dislikedUsers,
      'superLikedUsers': instance.superLikedUsers,
      'matchedUsers': instance.matchedUsers,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'occupation': instance.occupation,
      'education': instance.education,
      'height': instance.height,
      'relationshipType': instance.relationshipType,
      'languages': instance.languages,
      'hasStory': instance.hasStory,
      'boostCount': instance.boostCount,
      'superLikeCount': instance.superLikeCount,
    };
