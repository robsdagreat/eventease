class Special {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final String? venueId;
  final String? eventTypeId;

  Special({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    this.venueId,
    this.eventTypeId,
  });

  factory Special.fromJson(Map<String, dynamic> json) {
    return Special(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      isActive: json['is_active'],
      venueId: json['venue_id'],
      eventTypeId: json['event_type_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': isActive,
      'venue_id': venueId,
      'event_type_id': eventTypeId,
    };
  }
}
