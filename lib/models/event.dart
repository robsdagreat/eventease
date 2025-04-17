import 'venue.dart';
import 'user.dart';

class Event {
  final String id;
  final String name;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String eventType;
  final String venueId;
  final String userId;
  final String hostType;
  final bool isPublic;
  final int guestCount;
  final String? imageUrl;
  final String? status;
  final double? budget;
  final List<String>? requirements;
  final Map<String, dynamic>? additionalInfo;
  final String? contactPerson;
  final String? contactPhone;
  final String? contactEmail;
  final List<String>? tags;
  final bool isCancelled;
  final DateTime? cancelledAt;
  final String? cancellationReason;
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
    required this.userId,
    required this.hostType,
    required this.isPublic,
    required this.guestCount,
    this.imageUrl,
    this.status,
    this.budget,
    this.requirements,
    this.additionalInfo,
    this.contactPerson,
    this.contactPhone,
    this.contactEmail,
    this.tags,
    required this.isCancelled,
    this.cancelledAt,
    this.cancellationReason,
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
      userId: json['user_id'],
      hostType: json['host_type'],
      isPublic: json['is_public'] ?? false,
      guestCount: json['guest_count'] ?? 0,
      imageUrl: json['image_url'],
      status: json['status'],
      budget: json['budget']?.toDouble(),
      requirements: List<String>.from(json['requirements'] ?? []),
      additionalInfo: json['additional_info'],
      contactPerson: json['contact_person'],
      contactPhone: json['contact_phone'],
      contactEmail: json['contact_email'],
      tags: List<String>.from(json['tags'] ?? []),
      isCancelled: json['is_cancelled'] ?? false,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'])
          : null,
      cancellationReason: json['cancellation_reason'],
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
      'user_id': userId,
      'host_type': hostType,
      'is_public': isPublic,
      'guest_count': guestCount,
      'image_url': imageUrl,
      'status': status,
      'budget': budget,
      'requirements': requirements,
      'additional_info': additionalInfo,
      'contact_person': contactPerson,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'tags': tags,
      'is_cancelled': isCancelled,
      'cancelled_at': cancelledAt?.toIso8601String(),
      'cancellation_reason': cancellationReason,
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
    String? userId,
    String? hostType,
    bool? isPublic,
    int? guestCount,
    String? imageUrl,
    String? status,
    double? budget,
    List<String>? requirements,
    Map<String, dynamic>? additionalInfo,
    String? contactPerson,
    String? contactPhone,
    String? contactEmail,
    List<String>? tags,
    bool? isCancelled,
    DateTime? cancelledAt,
    String? cancellationReason,
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
      userId: userId ?? this.userId,
      hostType: hostType ?? this.hostType,
      isPublic: isPublic ?? this.isPublic,
      guestCount: guestCount ?? this.guestCount,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      budget: budget ?? this.budget,
      requirements: requirements ?? this.requirements,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      contactPerson: contactPerson ?? this.contactPerson,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      tags: tags ?? this.tags,
      isCancelled: isCancelled ?? this.isCancelled,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
