import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/booking.dart'; // Assuming a Booking model exists or will be created
import 'package:flutter/material.dart'; // Import material for ChangeNotifier
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_db_service.dart'; // import your SQLite service

class BookingService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> createBooking(Booking booking) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final bookingData = booking.toJson();
    bookingData['userId'] = user.uid;

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

    print('Booking data to Firestore: $bookingData');
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

    print('Booking data to Firestore: $bookingData');
    await _firestore.collection('bookings').add(bookingData);

    // Prepare notification details
    String title = 'Booking Confirmed!';
    String body =
        'Your booking for venue ${booking.venueId} at ${booking.time} is confirmed.';

    // Show local notification
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'booking_channel',
          'Booking Notifications',
          channelDescription: 'Notifications for venue bookings',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'ic_stat_notify',
        ),
      ),
    );

    // Save notification to SQLite
    await NotificationDBService().insertNotification(title, body);
  }

  // Method to fetch all bookings for the currently logged-in user
  Stream<List<Booking>> getUserBookings() {
    if (_auth.currentUser == null) {
      debugPrint('getUserBookings: User not logged in');
      return Stream.value([]);
    }

    debugPrint(
        'getUserBookings: Fetching bookings for user ${_auth.currentUser!.uid}');

    try {
      return _firestore
          .collection('bookings')
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        debugPrint('getUserBookings: Got ${snapshot.docs.length} bookings');
        return snapshot.docs.map((doc) {
          try {
            return Booking.fromDocument(doc);
          } catch (e) {
            debugPrint('Error parsing booking document ${doc.id}: $e');
            rethrow;
          }
        }).toList();
      }).handleError((error) {
        debugPrint('Error in getUserBookings stream: $error');
        throw error;
      });
    } catch (e) {
      debugPrint('Error setting up getUserBookings stream: $e');
      rethrow;
    }
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
