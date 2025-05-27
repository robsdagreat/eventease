import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String venueId;
  final String userId;
  final DateTime startTime;
  final DateTime endTime;
  final String time;
  final int numberOfGuests;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.venueId,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.time,
    required this.numberOfGuests,
    required this.createdAt,
  });

  // Method to convert a Booking object to a JSON map for Firebase
  Map<String, dynamic> toJson() {
    return {
      'venueId': venueId,
      'userId': userId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'time': time,
      'numberOfGuests': numberOfGuests,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Optional: Factory method to create a Booking object from a Firebase document
  factory Booking.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Booking(
      id: doc.id,
      venueId: data['venueId'] ?? '',
      userId: data['userId'] ?? '',
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      time: data['time'] ?? '',
      numberOfGuests: data['numberOfGuests'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
