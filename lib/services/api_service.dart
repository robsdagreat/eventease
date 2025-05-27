import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../models/venue.dart';
import '../models/special.dart';
import 'auth_service.dart';

class ApiService {
  // For Android Emulator
  static const String _androidEmulatorUrl = 'http://10.0.2.2:8000';
  // For physical device - replace with your computer's IP address
  static const String _physicalDeviceUrl = 'http://192.168.247.214:8000';

  // Use this to switch between emulator and physical device
  static const String baseUrl = _physicalDeviceUrl;

  final http.Client _client = http.Client();
  final AuthService _authService;
  final Duration timeout = const Duration(seconds: 30); // Increased timeout
  final int maxRetries = 3;
  final Duration retryDelay = const Duration(seconds: 2);

  ApiService(this._authService);

  // Helper method to get request headers with Firebase ID token
  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Helper method to handle API responses
  dynamic _handleResponse(http.Response response) {
    print('API Response Status: ${response.statusCode}');
    print('API Response Body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        final decoded = json.decode(response.body);
        print('Decoded response type: ${decoded.runtimeType}');
        return decoded;
      } catch (e) {
        print('JSON Parse Error: $e');
        throw Exception('Failed to parse response: $e');
      }
    } else {
      print('API Error: ${response.statusCode} - ${response.body}');
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }

  // Helper method to safely cast to list
  List<T> _safeListCast<T>(
      dynamic data, T Function(Map<String, dynamic>) fromJson) {
    if (data == null) return [];

    if (data is List) {
      return data.map((item) {
        if (item is Map<String, dynamic>) {
          return fromJson(item);
        } else {
          throw Exception(
              'Expected Map<String, dynamic> but got ${item.runtimeType}');
        }
      }).toList();
    } else if (data is Map &&
        data.containsKey('data') &&
        data['data'] is List) {
      // Handle wrapped response like { "data": [...] }
      return _safeListCast(data['data'], fromJson);
    } else {
      throw Exception(
          'Expected List or wrapped response but got ${data.runtimeType}');
    }
  }

  Future<T> _makeRequest<T>({
    required String endpoint,
    required Future<T> Function(http.Response) parseResponse,
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    int retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        final headers = await _getHeaders();
        final uri = Uri.parse('$baseUrl$endpoint');

        print('Making $method request to $uri');

        final response = await http
            .get(
              uri,
              headers: headers,
            )
            .timeout(timeout);

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          return await parseResponse(response);
        } else if (response.statusCode == 401) {
          // Handle unauthorized error
          throw Exception('Unauthorized: Please log in again');
        } else if (response.statusCode == 404) {
          // Handle not found error
          throw Exception('Resource not found');
        } else {
          throw Exception('Server error: ${response.statusCode}');
        }
      } on TimeoutException {
        print('Request timed out, attempt ${retryCount + 1} of $maxRetries');
        retryCount++;
        if (retryCount == maxRetries) {
          throw Exception('Request timed out after $maxRetries attempts');
        }
        await Future.delayed(retryDelay * retryCount);
      } on SocketException catch (e) {
        print('Network error: $e, attempt ${retryCount + 1} of $maxRetries');
        retryCount++;
        if (retryCount == maxRetries) {
          throw Exception('Network error: $e');
        }
        await Future.delayed(retryDelay * retryCount);
      } catch (e) {
        print('Error: $e, attempt ${retryCount + 1} of $maxRetries');
        retryCount++;
        if (retryCount == maxRetries) {
          throw Exception('Failed after $maxRetries attempts: $e');
        }
        await Future.delayed(retryDelay * retryCount);
      }
    }
    throw Exception('Failed to complete request after $maxRetries attempts');
  }

  // Venue endpoints
  Future<List<Venue>> getVenues() async {
    return _makeRequest<List<Venue>>(
      endpoint: '/venues',
      parseResponse: (response) async {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Venue.fromJson(json)).toList();
      },
    );
  }

  Future<Venue> getVenue(String id) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/venues/$id'),
        headers: await _getHeaders(),
      );
      final data = _handleResponse(response);
      if (data is Map<String, dynamic>) {
        return Venue.fromJson(data);
      } else {
        throw Exception(
            'Expected Map<String, dynamic> but got ${data.runtimeType}');
      }
    } catch (e) {
      print('Error fetching venue $id: $e');
      rethrow;
    }
  }

  Future<Venue> createVenue(Venue venue) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/venues'),
        headers: await _getHeaders(),
        body: json.encode(venue.toJson()),
      );
      final data = _handleResponse(response);
      if (data is Map<String, dynamic>) {
        return Venue.fromJson(data);
      } else {
        throw Exception(
            'Expected Map<String, dynamic> but got ${data.runtimeType}');
      }
    } catch (e) {
      print('Error creating venue: $e');
      rethrow;
    }
  }

  Future<Venue> updateVenue(String id, Venue venue) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/api/venues/$id'),
        headers: await _getHeaders(),
        body: json.encode(venue.toJson()),
      );
      final data = _handleResponse(response);
      if (data is Map<String, dynamic>) {
        return Venue.fromJson(data);
      } else {
        throw Exception(
            'Expected Map<String, dynamic> but got ${data.runtimeType}');
      }
    } catch (e) {
      print('Error updating venue $id: $e');
      rethrow;
    }
  }

  Future<void> deleteVenue(String id) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/api/venues/$id'),
        headers: await _getHeaders(),
      );
      _handleResponse(response);
    } catch (e) {
      print('Error deleting venue $id: $e');
      rethrow;
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
        headers: await _getHeaders(),
      );
      final data = _handleResponse(response);
      return _safeListCast(data, (json) => Venue.fromJson(json));
    } catch (e) {
      print('Error searching venues: $e');
      rethrow;
    }
  }

  Future<List<Venue>> getAvailableVenues() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/venues/available'),
        headers: await _getHeaders(),
      );
      final data = _handleResponse(response);
      return _safeListCast(data, (json) => Venue.fromJson(json));
    } catch (e) {
      print('Error fetching available venues: $e');
      rethrow;
    }
  }

  // Event endpoints
  Future<List<Event>> getEvents() async {
    return _makeRequest<List<Event>>(
      endpoint: '/events',
      parseResponse: (response) async {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Event.fromJson(json)).toList();
      },
    );
  }

  Future<Event> getEvent(String id) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/events/$id'),
        headers: await _getHeaders(),
      );
      final data = _handleResponse(response);
      if (data is Map<String, dynamic>) {
        return Event.fromJson(data);
      } else {
        throw Exception(
            'Expected Map<String, dynamic> but got ${data.runtimeType}');
      }
    } catch (e) {
      print('Error fetching event $id: $e');
      rethrow;
    }
  }

  Future<Event> createEvent(Event event) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/events'),
        headers: await _getHeaders(),
        body: json.encode(event.toJson()),
      );
      final data = _handleResponse(response);
      if (data is Map<String, dynamic>) {
        return Event.fromJson(data);
      } else {
        throw Exception(
            'Expected Map<String, dynamic> but got ${data.runtimeType}');
      }
    } catch (e) {
      print('Error creating event: $e');
      rethrow;
    }
  }

  Future<Event> updateEvent(String id, Event event) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/api/events/$id'),
        headers: await _getHeaders(),
        body: json.encode(event.toJson()),
      );
      final data = _handleResponse(response);
      if (data is Map<String, dynamic>) {
        return Event.fromJson(data);
      } else {
        throw Exception(
            'Expected Map<String, dynamic> but got ${data.runtimeType}');
      }
    } catch (e) {
      print('Error updating event $id: $e');
      rethrow;
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/api/events/$id'),
        headers: await _getHeaders(),
      );
      _handleResponse(response);
    } catch (e) {
      print('Error deleting event $id: $e');
      rethrow;
    }
  }

  Future<List<Event>> getEventsByVenue(String venueId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/events/venue/$venueId'),
        headers: await _getHeaders(),
      );
      final data = _handleResponse(response);
      return _safeListCast(data, (json) => Event.fromJson(json));
    } catch (e) {
      print('Error fetching events by venue $venueId: $e');
      rethrow;
    }
  }

  Future<List<Event>> getEventsByType(String type) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/events/type/$type'),
        headers: await _getHeaders(),
      );
      final data = _handleResponse(response);
      return _safeListCast(data, (json) => Event.fromJson(json));
    } catch (e) {
      print('Error fetching events by type $type: $e');
      rethrow;
    }
  }

  Future<List<Event>> getEventsByStatus(String status) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/events/status/$status'),
        headers: await _getHeaders(),
      );
      final data = _handleResponse(response);
      return _safeListCast(data, (json) => Event.fromJson(json));
    } catch (e) {
      print('Error fetching events by status $status: $e');
      rethrow;
    }
  }

  Future<List<Event>> getUpcomingEvents() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/events/upcoming'),
        headers: await _getHeaders(),
      );
      final data = _handleResponse(response);
      return _safeListCast(data, (json) => Event.fromJson(json));
    } catch (e) {
      print('Error fetching upcoming events: $e');
      rethrow;
    }
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
    try {
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
        headers: await _getHeaders(),
      );
      final data = _handleResponse(response);
      return _safeListCast(data, (json) => Event.fromJson(json));
    } catch (e) {
      print('Error searching events: $e');
      rethrow;
    }
  }

  Future<List<Event>> getEventsByUser(String userId) async {
    return _makeRequest<List<Event>>(
      endpoint: '/events/user/$userId',
      parseResponse: (response) async {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Event.fromJson(json)).toList();
      },
    );
  }

  // Special endpoints
  Future<List<Special>> getSpecials() async {
    return _makeRequest<List<Special>>(
      endpoint: '/specials',
      parseResponse: (response) async {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Special.fromJson(json)).toList();
      },
    );
  }

  Future<Special> getSpecial(String id) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/specials/$id'),
        headers: await _getHeaders(),
      );
      final data = _handleResponse(response);
      if (data is Map<String, dynamic>) {
        return Special.fromJson(data);
      } else {
        throw Exception(
            'Expected Map<String, dynamic> but got ${data.runtimeType}');
      }
    } catch (e) {
      print('Error fetching special $id: $e');
      rethrow;
    }
  }

  // Venue suggestion endpoint
  Future<List<Venue>> getSuggestedVenues({
    required String eventType,
    required int expectedAttendees,
    required DateTime date,
    String? location,
  }) async {
    try {
      final queryParams = {
        'event_type': eventType,
        'expected_attendees': expectedAttendees.toString(),
        'date': date.toIso8601String(),
        if (location != null) 'location': location,
      };

      final response = await _client.get(
        Uri.parse('$baseUrl/venues/suggest')
            .replace(queryParameters: queryParams),
        headers: await _getHeaders(),
      );

      final data = _handleResponse(response);
      return _safeListCast(data, (json) => Venue.fromJson(json));
    } catch (e) {
      print('Error fetching suggested venues: $e');
      rethrow;
    }
  }

  void dispose() {
    _client.close();
  }
}
