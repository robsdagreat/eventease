import 'package:flutter/foundation.dart';
import '../models/event.dart';
import 'api_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_db_service.dart';

class EventService {
  final ApiService _apiService;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  EventService(this._apiService);

  Future<List<Event>> getAllEvents() async {
    try {
      return await _apiService.getEvents();
    } catch (e) {
      debugPrint('Error fetching events: $e');
      return [];
    }
  }

  Future<Event?> getEventById(String eventId) async {
    try {
      return await _apiService.getEvent(eventId);
    } catch (e) {
      debugPrint('Error fetching event: $e');
      return null;
    }
  }

  Future<List<Event>> getEventsByVenue(String venueId) async {
    try {
      return await _apiService.getEventsByVenue(venueId);
    } catch (e) {
      debugPrint('Error fetching events by venue: $e');
      return [];
    }
  }

  Future<List<Event>> getEventsByType(String type) async {
    try {
      return await _apiService.getEventsByType(type);
    } catch (e) {
      debugPrint('Error fetching events by type: $e');
      return [];
    }
  }

  Future<List<Event>> getEventsByStatus(String status) async {
    try {
      return await _apiService.getEventsByStatus(status);
    } catch (e) {
      debugPrint('Error fetching events by status: $e');
      return [];
    }
  }

  Future<List<Event>> getUpcomingEvents() async {
    try {
      return await _apiService.getUpcomingEvents();
    } catch (e) {
      debugPrint('Error fetching upcoming events: $e');
      return [];
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
      return await _apiService.searchEvents(
        name: name,
        eventType: eventType,
        venueId: venueId,
        status: status,
        startDate: startDate,
        endDate: endDate,
        minPrice: minPrice,
        maxPrice: maxPrice,
        isPublic: isPublic,
        tags: tags,
      );
    } catch (e) {
      debugPrint('Error searching events: $e');
      return [];
    }
  }

  Future<Event> createEvent(Event event) async {
    try {
      final createdEvent = await _apiService.createEvent(event);

      // Show local notification
      await _localNotifications.show(
        0,
        'Event Created Successfully!',
        'Your event "${event.name}" has been created.',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'event_channel',
            'Event Notifications',
            channelDescription: 'Notifications for event creation',
            importance: Importance.max,
            priority: Priority.high,
            icon: 'ic_stat_notify',
          ),
        ),
      );

      // Save notification to SQLite
      await NotificationDBService().insertNotification(
        'Event Created Successfully!',
        'Your event "${event.name}" has been created.',
      );

      return createdEvent;
    } catch (e) {
      debugPrint('Error creating event: $e');
      rethrow;
    }
  }

  Future<Event> updateEvent(String id, Event event) async {
    try {
      return await _apiService.updateEvent(id, event);
    } catch (e) {
      debugPrint('Error updating event: $e');
      rethrow;
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await _apiService.deleteEvent(id);
    } catch (e) {
      debugPrint('Error deleting event: $e');
      rethrow;
    }
  }

  Future<List<Event>> getEventsByUser(String userId) async {
    try {
      return await _apiService.getEventsByUser(userId);
    } catch (e) {
      debugPrint('Error fetching events by user: $e');
      return [];
    }
  }
}
