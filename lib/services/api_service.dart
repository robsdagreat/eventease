import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../models/venue.dart';
import '../models/special.dart';

class ApiService {
  static const String baseUrl =
      'YOUR_BACKEND_API_URL'; // Replace with your actual backend URL
  final http.Client _client = http.Client();

  // Helper method to handle API responses
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }

  // Venue endpoints
  Future<List<Venue>> getVenues() async {
    final response = await _client.get(Uri.parse('$baseUrl/api/venues'));
    final data = _handleResponse(response);
    return (data as List).map((json) => Venue.fromJson(json)).toList();
  }

  Future<Venue> getVenue(String id) async {
    final response = await _client.get(Uri.parse('$baseUrl/api/venues/$id'));
    final data = _handleResponse(response);
    return Venue.fromJson(data);
  }

  Future<Venue> createVenue(Venue venue) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/venues'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(venue.toJson()),
    );
    final data = _handleResponse(response);
    return Venue.fromJson(data);
  }

  Future<Venue> updateVenue(String id, Venue venue) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/api/venues/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(venue.toJson()),
    );
    final data = _handleResponse(response);
    return Venue.fromJson(data);
  }

  Future<void> deleteVenue(String id) async {
    final response = await _client.delete(Uri.parse('$baseUrl/api/venues/$id'));
    _handleResponse(response);
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
    final queryParams = {
      if (name != null) 'name': name,
      if (venueType != null) 'venue_type': venueType,
      if (location != null) 'location': location,
      if (minCapacity != null) 'min_capacity': minCapacity.toString(),
      if (maxCapacity != null) 'max_capacity': maxCapacity.toString(),
      if (minRating != null) 'min_rating': minRating.toString(),
      if (amenities != null) 'amenities': amenities.join(','),
      if (isAvailable != null) 'is_available': isAvailable.toString(),
    };

    final response = await _client.get(
      Uri.parse('$baseUrl/api/venues/search')
          .replace(queryParameters: queryParams),
    );
    final data = _handleResponse(response);
    return (data as List).map((json) => Venue.fromJson(json)).toList();
  }

  Future<List<Venue>> getAvailableVenues() async {
    final response =
        await _client.get(Uri.parse('$baseUrl/api/venues/available'));
    final data = _handleResponse(response);
    return (data as List).map((json) => Venue.fromJson(json)).toList();
  }

  // Event endpoints
  Future<List<Event>> getEvents() async {
    final response = await _client.get(Uri.parse('$baseUrl/api/events'));
    final data = _handleResponse(response);
    return (data as List).map((json) => Event.fromJson(json)).toList();
  }

  Future<Event> getEvent(String id) async {
    final response = await _client.get(Uri.parse('$baseUrl/api/events/$id'));
    final data = _handleResponse(response);
    return Event.fromJson(data);
  }

  Future<Event> createEvent(Event event) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/events'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(event.toJson()),
    );
    final data = _handleResponse(response);
    return Event.fromJson(data);
  }

  Future<Event> updateEvent(String id, Event event) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/api/events/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(event.toJson()),
    );
    final data = _handleResponse(response);
    return Event.fromJson(data);
  }

  Future<void> deleteEvent(String id) async {
    final response = await _client.delete(Uri.parse('$baseUrl/api/events/$id'));
    _handleResponse(response);
  }

  Future<List<Event>> getEventsByVenue(String venueId) async {
    final response =
        await _client.get(Uri.parse('$baseUrl/api/events/venue/$venueId'));
    final data = _handleResponse(response);
    return (data as List).map((json) => Event.fromJson(json)).toList();
  }

  Future<List<Event>> getEventsByType(String type) async {
    final response =
        await _client.get(Uri.parse('$baseUrl/api/events/type/$type'));
    final data = _handleResponse(response);
    return (data as List).map((json) => Event.fromJson(json)).toList();
  }

  Future<List<Event>> getEventsByStatus(String status) async {
    final response =
        await _client.get(Uri.parse('$baseUrl/api/events/status/$status'));
    final data = _handleResponse(response);
    return (data as List).map((json) => Event.fromJson(json)).toList();
  }

  Future<List<Event>> getUpcomingEvents() async {
    final response =
        await _client.get(Uri.parse('$baseUrl/api/events/upcoming'));
    final data = _handleResponse(response);
    return (data as List).map((json) => Event.fromJson(json)).toList();
  }

  Future<List<Event>> searchEvents({
    String? name,
    String? eventType,
    String? venueId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    double? minPrice,
    double? maxPrice,
    bool? isPublic,
    List<String>? tags,
  }) async {
    final queryParams = {
      if (name != null) 'name': name,
      if (eventType != null) 'event_type': eventType,
      if (venueId != null) 'venue_id': venueId,
      if (status != null) 'status': status,
      if (startDate != null) 'start_date': startDate.toIso8601String(),
      if (endDate != null) 'end_date': endDate.toIso8601String(),
      if (minPrice != null) 'min_price': minPrice.toString(),
      if (maxPrice != null) 'max_price': maxPrice.toString(),
      if (isPublic != null) 'is_public': isPublic.toString(),
      if (tags != null) 'tags': tags.join(','),
    };

    final response = await _client.get(
      Uri.parse('$baseUrl/api/events/search')
          .replace(queryParameters: queryParams),
    );
    final data = _handleResponse(response);
    return (data as List).map((json) => Event.fromJson(json)).toList();
  }

  Future<List<Event>> getEventsByUser(String userId) async {
    final response =
        await _client.get(Uri.parse('$baseUrl/api/events/user/$userId'));
    final data = _handleResponse(response);
    return (data as List).map((json) => Event.fromJson(json)).toList();
  }

  // Special endpoints
  Future<List<Special>> getSpecials() async {
    final response = await _client.get(Uri.parse('$baseUrl/api/specials'));
    final data = _handleResponse(response);
    return (data as List).map((json) => Special.fromJson(json)).toList();
  }

  Future<Special> getSpecial(String id) async {
    final response = await _client.get(Uri.parse('$baseUrl/api/specials/$id'));
    final data = _handleResponse(response);
    return Special.fromJson(data);
  }

  // Venue suggestion endpoint
  Future<List<Venue>> getSuggestedVenues({
    required String eventType,
    required int expectedAttendees,
    required DateTime date,
    String? location,
  }) async {
    final queryParams = {
      'event_type': eventType,
      'expected_attendees': expectedAttendees.toString(),
      'date': date.toIso8601String(),
      if (location != null) 'location': location,
    };

    final response = await _client.get(
      Uri.parse(
        '$baseUrl/venues/suggest',
      ).replace(queryParameters: queryParams),
    );

    final data = _handleResponse(response);
    return (data as List).map((json) => Venue.fromJson(json)).toList();
  }

  void dispose() {
    _client.close();
  }
}
