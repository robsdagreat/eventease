import '../models/venue.dart';
import '../services/api_service.dart';
import 'package:flutter/foundation.dart';

class VenueService {
  final ApiService _apiService;
  VenueService(this._apiService);

  Future<Venue?> getVenueById(String venueId) async {
    try {
      return await _apiService.getVenue(venueId);
    } catch (e) {
      debugPrint('Error fetching venue: $e');
      return null;
    }
  }

  Future<List<Venue>> getAllVenues() async {
    try {
      return await _apiService.getVenues();
    } catch (e) {
      debugPrint('Error fetching venues: $e');
      return [];
    }
  }

  // You can re-implement other methods for Firestore if needed
}
