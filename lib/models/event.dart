import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String venueId;
  final DateTime date;
  final int capacity;
  final String userId;
  final String eventType;
  final bool isApproved;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.venueId,
    required this.date,
    required this.capacity,
    required this.userId,
    required this.eventType,
    this.isApproved = false,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      venueId: data['venueId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      capacity: data['capacity'] ?? 0,
      userId: data['userId'] ?? '',
      eventType: data['eventType'] ?? '',
      isApproved: data['isApproved'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'venueId': venueId,
      'date': Timestamp.fromDate(date),
      'capacity': capacity,
      'userId': userId,
      'eventType': eventType,
      'isApproved': isApproved,
    };
  }

  Event copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? venueId,
    DateTime? date,
    int? capacity,
    String? userId,
    String? eventType,
    bool? isApproved,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      venueId: venueId ?? this.venueId,
      date: date ?? this.date,
      capacity: capacity ?? this.capacity,
      userId: userId ?? this.userId,
      eventType: eventType ?? this.eventType,
      isApproved: isApproved ?? this.isApproved,
    );
  }
}
