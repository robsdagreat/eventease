import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/venue.dart';

class VenueService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Venue?> getVenueById(String venueId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('venues').doc(venueId).get();
      if (doc.exists) {
        return Venue.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching venue: $e');
      return null;
    }
  }

  Future<List<Venue>> getAllVenues() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('venues').get();
      return snapshot.docs
          .map((doc) => Venue.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching venues: $e');
      return [];
    }
  }
}
