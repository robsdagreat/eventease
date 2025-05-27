import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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

    try {
      return Booking(
        id: doc.id,
        venueId: data['venueId'] as String? ?? '',
        userId: data['userId'] as String? ?? '',
        startTime:
            (data['startTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
        endTime: (data['endTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
        time: data['time'] as String? ?? '',
        numberOfGuests: data['numberOfGuests'] as int? ?? 0,
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error parsing booking document ${doc.id}: $e');
      throw Exception('Error parsing booking document ${doc.id}: $e');
    }
  }
}
