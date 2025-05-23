import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String venueId;
  final String userId;
  final DateTime date;
  final String time;
  final int numberOfGuests;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.venueId,
    required this.userId,
    required this.date,
    required this.time,
    required this.numberOfGuests,
    required this.createdAt,
  });

  // Method to convert a Booking object to a JSON map for Firebase
  Map<String, dynamic> toJson() {
    return {
      'venueId': venueId,
      'userId': userId,
      'date': Timestamp.fromDate(date), // Store DateTime as Firebase Timestamp
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
      date: (data['date'] as Timestamp).toDate(),
      time: data['time'] ?? '',
      numberOfGuests: data['numberOfGuests'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
