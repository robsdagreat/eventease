import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/booking.dart'; // Assuming a Booking model exists or will be created
import 'package:flutter/material.dart'; // Import material for ChangeNotifier

class BookingService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createBooking(Booking booking) async {
    if (_auth.currentUser == null) {
      throw Exception('User not logged in');
    }
    // Assign the current user's ID to the booking
    final bookingData = booking.toJson();
    bookingData['userId'] = _auth.currentUser!.uid;

    await _firestore.collection('bookings').add(bookingData);
  }

  // Method to fetch all bookings for the currently logged-in user
  Stream<List<Booking>> getUserBookings() {
    if (_auth.currentUser == null) {
      // Return an empty stream if user is not logged in
      return Stream.value([]);
    }
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Booking.fromDocument(doc)).toList());
  }

  // Method to update an existing booking
  Future<void> updateBooking(Booking booking) async {
    if (_auth.currentUser == null) {
      throw Exception('User not logged in');
    }
    if (booking.userId != _auth.currentUser!.uid) {
      throw Exception('Unauthorized: Cannot update bookings of other users.');
    }
    await _firestore
        .collection('bookings')
        .doc(booking.id)
        .update(booking.toJson());
  }

  // Method to delete a booking
  Future<void> deleteBooking(String bookingId) async {
    if (_auth.currentUser == null) {
      throw Exception('User not logged in');
    }
    // Optional: Verify if the booking belongs to the current user before deleting
    final bookingDoc =
        await _firestore.collection('bookings').doc(bookingId).get();

    if (!bookingDoc.exists) {
      throw Exception('Booking not found.');
    }

    if (bookingDoc.data()?['userId'] != _auth.currentUser!.uid) {
      throw Exception('Unauthorized: Cannot delete bookings of other users.');
    }

    await _firestore.collection('bookings').doc(bookingId).delete();
  }
}
