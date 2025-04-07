import 'package:flutter/material.dart';

class EventType {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final IconData icon;
  final int minCapacity;
  final int maxCapacity;

  const EventType({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.icon,
    required this.minCapacity,
    required this.maxCapacity,
  });

  // Predefined event types
  static final List<EventType> types = [
    EventType(
      id: 'wedding',
      name: 'Wedding',
      description: 'Find the perfect venue for your special day',
      imageUrl: 'https://picsum.photos/id/1033/400/300',
      icon: Icons.favorite,
      minCapacity: 50,
      maxCapacity: 500,
    ),
    EventType(
      id: 'corporate',
      name: 'Corporate Event',
      description:
          'Professional spaces for meetings, conferences, and seminars',
      imageUrl: 'https://picsum.photos/id/1048/400/300',
      icon: Icons.business,
      minCapacity: 10,
      maxCapacity: 1000,
    ),
    EventType(
      id: 'birthday',
      name: 'Birthday Party',
      description: 'Celebrate your special day in style',
      imageUrl: 'https://picsum.photos/id/1058/400/300',
      icon: Icons.cake,
      minCapacity: 10,
      maxCapacity: 200,
    ),
    EventType(
      id: 'concert',
      name: 'Concert',
      description: 'Large venues for music events and performances',
      imageUrl: 'https://picsum.photos/id/1082/400/300',
      icon: Icons.music_note,
      minCapacity: 100,
      maxCapacity: 5000,
    ),
    EventType(
      id: 'exhibition',
      name: 'Exhibition',
      description: 'Showcase your art, products, or ideas',
      imageUrl: 'https://picsum.photos/id/1076/400/300',
      icon: Icons.museum,
      minCapacity: 50,
      maxCapacity: 2000,
    ),
  ];
}
