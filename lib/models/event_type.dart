import 'package:flutter/material.dart';

class EventType {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String icon;
  final int minCapacity;
  final int maxCapacity;

  EventType({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.icon,
    required this.minCapacity,
    required this.maxCapacity,
  });

  factory EventType.fromMap(Map<String, dynamic> map) {
    return EventType(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      icon: map['icon'] ?? '',
      minCapacity: map['minCapacity'] ?? 0,
      maxCapacity: map['maxCapacity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'icon': icon,
      'minCapacity': minCapacity,
      'maxCapacity': maxCapacity,
    };
  }

  // Predefined event types
  static final List<EventType> types = [
    EventType(
      id: 'wedding',
      name: 'Wedding',
      description: 'Find the perfect venue for your special day',
      imageUrl: 'https://picsum.photos/id/1033/400/300',
      icon: 'favorite',
      minCapacity: 50,
      maxCapacity: 500,
    ),
    EventType(
      id: 'corporate',
      name: 'Corporate Event',
      description:
          'Professional spaces for meetings, conferences, and seminars',
      imageUrl: 'https://picsum.photos/id/1048/400/300',
      icon: 'business',
      minCapacity: 10,
      maxCapacity: 1000,
    ),
    EventType(
      id: 'birthday',
      name: 'Birthday Party',
      description: 'Celebrate your special day in style',
      imageUrl: 'https://picsum.photos/id/1058/400/300',
      icon: 'cake',
      minCapacity: 10,
      maxCapacity: 200,
    ),
    EventType(
      id: 'concert',
      name: 'Concert',
      description: 'Large venues for music events and performances',
      imageUrl: 'https://picsum.photos/id/1082/400/300',
      icon: 'music_note',
      minCapacity: 100,
      maxCapacity: 5000,
    ),
    EventType(
      id: 'exhibition',
      name: 'Exhibition',
      description: 'Showcase your art, products, or ideas',
      imageUrl: 'https://picsum.photos/id/1076/400/300',
      icon: 'museum',
      minCapacity: 50,
      maxCapacity: 2000,
    ),
  ];
}
