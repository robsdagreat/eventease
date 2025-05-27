class EventType {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final int minCapacity;
  final int maxCapacity;

  EventType({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.minCapacity = 1,
    this.maxCapacity = 1000,
  });

  factory EventType.fromJson(Map<String, dynamic> json) {
    return EventType(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      minCapacity: json['min_capacity'] ?? 1,
      maxCapacity: json['max_capacity'] ?? 1000,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'min_capacity': minCapacity,
      'max_capacity': maxCapacity,
    };
  }

  // Predefined event types
  static final List<EventType> types = [
    EventType(
      id: 'wedding',
      name: 'Wedding',
      description: 'Find the perfect venue for your special day',
      imageUrl: 'https://picsum.photos/id/1033/400/300',
    ),
    EventType(
      id: 'corporate',
      name: 'Corporate Event',
      description:
          'Professional spaces for meetings, conferences, and seminars',
      imageUrl: 'https://picsum.photos/id/1048/400/300',
    ),
    EventType(
      id: 'birthday',
      name: 'Birthday Party',
      description: 'Celebrate your special day in style',
      imageUrl: 'https://picsum.photos/id/1058/400/300',
    ),
    EventType(
      id: 'concert',
      name: 'Concert',
      description: 'Large venues for music events and performances',
      imageUrl: 'https://picsum.photos/id/1082/400/300',
    ),
    EventType(
      id: 'exhibition',
      name: 'Exhibition',
      description: 'Showcase your art, products, or ideas',
      imageUrl: 'https://picsum.photos/id/1076/400/300',
    ),
  ];
}