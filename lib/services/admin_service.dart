import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:logging/logging.dart';
import '../models/venue.dart';
import '../models/event.dart';
import '../models/special.dart';
import '../models/user.dart';

class AdminService {
  static const String baseUrl = 'http://localhost:8000/api';
  final _logger = Logger('AdminService');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  // Check if user is admin
  Future<bool> isAdmin(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final user = json.decode(response.body);
        return user['is_admin'] ?? false;
      }
      return false;
    } catch (e) {
      _logger.severe('Error checking admin status: $e');
      return false;
    }
  }

  // Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/stats'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {
        'totalVenues': 0,
        'totalEvents': 0,
        'totalUsers': 0,
        'totalSpecials': 0,
      };
    } catch (e) {
      _logger.severe('Error fetching dashboard stats: $e');
      return {
        'totalVenues': 0,
        'totalEvents': 0,
        'totalUsers': 0,
        'totalSpecials': 0,
      };
    }
  }

  // Venue management
  Future<List<Venue>> getVenues() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/venues'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> venuesJson = json.decode(response.body);
        return venuesJson.map((json) => Venue.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      _logger.severe('Error fetching venues: $e');
      return [];
    }
  }

  Future<Venue> addVenue(Venue venue) async {
    final response = await http.post(
      Uri.parse('$baseUrl/venues'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(venue.toJson()),
    );
    if (response.statusCode == 201) {
      return Venue.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to add venue');
  }

  Future<Venue> updateVenue(Venue venue) async {
    final response = await http.put(
      Uri.parse('$baseUrl/venues/${venue.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(venue.toJson()),
    );
    if (response.statusCode == 200) {
      return Venue.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to update venue');
  }

  Future<void> deleteVenue(String venueId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/venues/$venueId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete venue');
    }
  }

  // Event management
  Future<List<Event>> getEvents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/events'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> eventsJson = json.decode(response.body);
        return eventsJson.map((json) => Event.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      _logger.severe('Error fetching events: $e');
      return [];
    }
  }

  Future<Event> updateEvent(Event event) async {
    final response = await http.put(
      Uri.parse('$baseUrl/events/${event.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(event.toJson()),
    );
    if (response.statusCode == 200) {
      return Event.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to update event');
  }

  Future<void> deleteEvent(String eventId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/events/$eventId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete event');
    }
  }

  // Special management
  Future<List<Special>> getSpecials() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/specials'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> specialsJson = json.decode(response.body);
        return specialsJson.map((json) => Special.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      _logger.severe('Error fetching specials: $e');
      return [];
    }
  }

  Future<Special> addSpecial(Special special) async {
    final response = await http.post(
      Uri.parse('$baseUrl/specials'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(special.toJson()),
    );
    if (response.statusCode == 201) {
      return Special.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to add special');
  }

  Future<Special> updateSpecial(Special special) async {
    final response = await http.put(
      Uri.parse('$baseUrl/specials/${special.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(special.toJson()),
    );
    if (response.statusCode == 200) {
      return Special.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to update special');
  }

  Future<void> deleteSpecial(String specialId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/specials/$specialId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete special');
    }
  }

  // User management
  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> usersJson = json.decode(response.body);
        return usersJson.map((json) => User.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      _logger.severe('Error fetching users: $e');
      return [];
    }
  }

  Future<User> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to update user');
  }

  Future<void> deleteUser(String userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  // Firestore Operations
  Future<List<Map<String, dynamic>>> getVenuesFirestore() async {
    final snapshot = await _firestore.collection('venues').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getEventsFirestore() async {
    final snapshot = await _firestore.collection('events').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getSpecialsFirestore() async {
    final snapshot = await _firestore.collection('specials').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getUsersFirestore() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> updateVenueFirestore(
      String venueId, Map<String, dynamic> data) async {
    await _firestore.collection('venues').doc(venueId).update(data);
  }

  Future<void> updateEventFirestore(
      String eventId, Map<String, dynamic> data) async {
    await _firestore.collection('events').doc(eventId).update(data);
  }

  Future<void> updateSpecialFirestore(
      String specialId, Map<String, dynamic> data) async {
    await _firestore.collection('specials').doc(specialId).update(data);
  }

  Future<void> updateUserFirestore(
      String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update(data);
  }

  Future<void> deleteVenueFirestore(String venueId) async {
    await _firestore.collection('venues').doc(venueId).delete();
  }

  Future<void> deleteEventFirestore(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }

  Future<void> deleteSpecialFirestore(String specialId) async {
    await _firestore.collection('specials').doc(specialId).delete();
  }

  Future<void> deleteUserFirestore(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }
}
