import 'package:flutter/foundation.dart';
import '../models/venue.dart';
import 'api_service.dart';

class VenueService {
  final ApiService _apiService = ApiService();

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

  Future<List<Venue>> getAvailableVenues() async {
    try {
      return await _apiService.getAvailableVenues();
    } catch (e) {
      debugPrint('Error fetching available venues: $e');
      return [];
    }
  }

  Future<List<Venue>> searchVenues({
    String? name,
    String? venueType,
    String? location,
    int? minCapacity,
    int? maxCapacity,
    double? minRating,
    List<String>? amenities,
    bool? isAvailable,
  }) async {
    try {
      return await _apiService.searchVenues(
        name: name,
        venueType: venueType,
        location: location,
        minCapacity: minCapacity,
        maxCapacity: maxCapacity,
        minRating: minRating,
        amenities: amenities,
        isAvailable: isAvailable,
      );
    } catch (e) {
      debugPrint('Error searching venues: $e');
      return [];
    }
  }

  Future<Venue> createVenue(Venue venue) async {
    try {
      return await _apiService.createVenue(venue);
    } catch (e) {
      debugPrint('Error creating venue: $e');
      rethrow;
    }
  }

  Future<Venue> updateVenue(String id, Venue venue) async {
    try {
      return await _apiService.updateVenue(id, venue);
    } catch (e) {
      debugPrint('Error updating venue: $e');
      rethrow;
    }
  }

  Future<void> deleteVenue(String id) async {
    try {
      await _apiService.deleteVenue(id);
    } catch (e) {
      debugPrint('Error deleting venue: $e');
      rethrow;
    }
  }
}
