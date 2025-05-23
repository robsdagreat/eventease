class Special {
  final String id;
  final String title;
  final String description;
  final String venueId;
  final String venueName;
  final DateTime startDate;
  final DateTime endDate;
  final String type; // e.g., 'couple', 'weekend', 'valentine'
  final double discountPercentage;
  final String? imageUrl;
  final bool isActive;
  final Map<String, dynamic>? terms;
  final DateTime createdAt;
  final DateTime updatedAt;

  Special({
    required this.id,
    required this.title,
    required this.description,
    required this.venueId,
    required this.venueName,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.discountPercentage,
    this.imageUrl,
    required this.isActive,
    this.terms,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Special.fromJson(Map<String, dynamic> json) {
    return Special(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      venueId: json['venue_id'],
      venueName: json['venue_name'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      type: json['type'],
      discountPercentage: json['discount_percentage']?.toDouble() ?? 0.0,
      imageUrl: json['image_url'],
      isActive: json['is_active'] ?? true,
      terms: json['terms'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'venue_id': venueId,
      'venue_name': venueName,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'type': type,
      'discount_percentage': discountPercentage,
      'image_url': imageUrl,
      'is_active': isActive,
      'terms': terms,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Special copyWith({
    String? id,
    String? title,
    String? description,
    String? venueId,
    String? venueName,
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    double? discountPercentage,
    String? imageUrl,
    bool? isActive,
    Map<String, dynamic>? terms,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Special(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      venueId: venueId ?? this.venueId,
      venueName: venueName ?? this.venueName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      terms: terms ?? this.terms,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
