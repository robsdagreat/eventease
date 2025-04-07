import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String location;
  final DateTime date;
  final int capacity;
  final String eventTypeId;
  final String venueId;
  final String userId;
  final bool isActive;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.date,
    required this.capacity,
    required this.eventTypeId,
    required this.venueId,
    required this.userId,
    this.isActive = true,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      location: map['location'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      capacity: map['capacity'] ?? 0,
      eventTypeId: map['eventTypeId'] ?? '',
      venueId: map['venueId'] ?? '',
      userId: map['userId'] ?? '',
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'location': location,
      'date': Timestamp.fromDate(date),
      'capacity': capacity,
      'eventTypeId': eventTypeId,
      'venueId': venueId,
      'userId': userId,
      'isActive': isActive,
    };
  }
}
