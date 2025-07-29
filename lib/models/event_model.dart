import 'package:cloud_firestore/cloud_firestore.dart';

/// EventModel represents a virtual or local event in ItoBound.
class EventModel {
  final String eventId;
  final String title;
  final String description;
  final String location;
  final Timestamp eventTime;
  final List<String> participants;
  final String? imageUrl;

  EventModel({
    required this.eventId,
    required this.title,
    required this.description,
    required this.location,
    required this.eventTime,
    required this.participants,
    this.imageUrl,
  });

  /// Converts Firestore document to EventModel
  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    eventId: json['eventId'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    location: json['location'] as String,
    eventTime: json['eventTime'] as Timestamp,
    participants: List<String>.from(json['participants'] ?? []),
    imageUrl: json['imageUrl'] as String?,
  );

  /// Converts EventModel to JSON for Firestore
  Map<String, dynamic> toJson() => {
    'eventId': eventId,
    'title': title,
    'description': description,
    'location': location,
    'eventTime': eventTime,
    'participants': participants,
    'imageUrl': imageUrl,
  };
}
