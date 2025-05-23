
class Event {
  final String id;
  final String name;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String eventType;
  final String venueId;
  final String venueName;
  final String userId;
  final String organizerName;
  final bool isPublic;
  final int expectedAttendees;
  final String? imageUrl;
  final String status; // 'draft', 'published', 'cancelled'
  final double? ticketPrice;
  final List<String>? tags;
  final String? contactEmail;
  final String? contactPhone;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.eventType,
    required this.venueId,
    required this.venueName,
    required this.userId,
    required this.organizerName,
    required this.isPublic,
    required this.expectedAttendees,
    this.imageUrl,
    required this.status,
    this.ticketPrice,
    this.tags,
    this.contactEmail,
    this.contactPhone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      eventType: json['event_type'],
      venueId: json['venue_id'],
      venueName: json['venue_name'],
      userId: json['user_id'],
      organizerName: json['organizer_name'],
      isPublic: json['is_public'] ?? false,
      expectedAttendees: json['expected_attendees'] ?? 0,
      imageUrl: json['image_url'],
      status: json['status'] ?? 'draft',
      ticketPrice: json['ticket_price']?.toDouble(),
      tags: List<String>.from(json['tags'] ?? []),
      contactEmail: json['contact_email'],
      contactPhone: json['contact_phone'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'event_type': eventType,
      'venue_id': venueId,
      'venue_name': venueName,
      'user_id': userId,
      'organizer_name': organizerName,
      'is_public': isPublic,
      'expected_attendees': expectedAttendees,
      'image_url': imageUrl,
      'status': status,
      'ticket_price': ticketPrice,
      'tags': tags,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Event copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? eventType,
    String? venueId,
    String? venueName,
    String? userId,
    String? organizerName,
    bool? isPublic,
    int? expectedAttendees,
    String? imageUrl,
    String? status,
    double? ticketPrice,
    List<String>? tags,
    String? contactEmail,
    String? contactPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      eventType: eventType ?? this.eventType,
      venueId: venueId ?? this.venueId,
      venueName: venueName ?? this.venueName,
      userId: userId ?? this.userId,
      organizerName: organizerName ?? this.organizerName,
      isPublic: isPublic ?? this.isPublic,
      expectedAttendees: expectedAttendees ?? this.expectedAttendees,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      ticketPrice: ticketPrice ?? this.ticketPrice,
      tags: tags ?? this.tags,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
