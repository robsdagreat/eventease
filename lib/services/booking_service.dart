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

    // --- Overlap Check ---
    // Fetch bookings for the same venue that fall within the date range of the new booking
    // Firestore queries on Timestamp fields often work best with range comparisons.
    // However, checking for *overlap* of two ranges is complex in Firestore.
    // A common pattern is to fetch bookings for the same day/venue and check for overlap client-side.

    // Fetch all bookings for this venue on the SAME DAY as the new booking's start time.
    // This assumes bookings for a venue don't typically span multiple days.
    // If bookings can span days, a more complex query might be needed.
    final startOfDay = DateTime(
        booking.startTime.year, booking.startTime.month, booking.startTime.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final existingBookingsQuery = await _firestore
        .collection('bookings')
        .where('venueId', isEqualTo: booking.venueId)
        .where('startTime', isGreaterThanOrEqualTo: startOfDay)
        .where('startTime', isLessThan: endOfDay)
        .get();

    bool hasOverlap = existingBookingsQuery.docs.any((doc) {
      try {
        final existingBooking = Booking.fromDocument(doc);
        // Check for overlap: [start1, end1] overlaps with [start2, end2] if start1 < end2 && end1 > start2
        return booking.startTime.isBefore(existingBooking.endTime) &&
            booking.endTime.isAfter(existingBooking.startTime);
      } catch (e) {
        // Log error if a document fails to parse as Booking
        debugPrint('Error parsing existing booking document \\${doc.id}: \\$e');
        return false; // Treat as no overlap if document is invalid
      }
    });

    if (hasOverlap) {
      throw Exception(
          'Venue is already booked during the selected time range.');
    }
    // --- End Overlap Check ---

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
