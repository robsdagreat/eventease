class Special {
  final String id;
  final String title;
  final String description;
  final String establishmentName;
  final String establishmentType;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final double discountPercentage;
  final String? imageUrl;
  final bool isActive;
  final List<String>? terms;
  final String? contactEmail;
  final String? contactPhone;
  final String? website;
  final DateTime createdAt;
  final DateTime updatedAt;

  Special({
    required this.id,
    required this.title,
    required this.description,
    required this.establishmentName,
    required this.establishmentType,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.discountPercentage,
    this.imageUrl,
    required this.isActive,
    this.terms,
    this.contactEmail,
    this.contactPhone,
    this.website,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Special.fromJson(Map<String, dynamic> json) {
    return Special(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      establishmentName: json['establishment_name'] ?? '',
      establishmentType: json['establishment_type'] ?? '',
      location: json['location'] ?? '',
      startDate: DateTime.parse(
          json['start_date'] ?? DateTime.now().toIso8601String()),
      endDate:
          DateTime.parse(json['end_date'] ?? DateTime.now().toIso8601String()),
      type: json['type'] ?? 'Other',
      discountPercentage: (json['discount_percentage'] ?? 0).toDouble(),
      imageUrl: json['image_url'],
      isActive: json['is_active'] ?? true,
      terms: json['terms'] != null ? List<String>.from(json['terms']) : null,
      contactEmail: json['contact_email'],
      contactPhone: json['contact_phone'],
      website: json['website'],
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'establishment_name': establishmentName,
      'establishment_type': establishmentType,
      'location': location,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'type': type,
      'discount_percentage': discountPercentage,
      'image_url': imageUrl,
      'is_active': isActive,
      'terms': terms,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'website': website,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Special copyWith({
    String? id,
    String? title,
    String? description,
    String? establishmentName,
    String? establishmentType,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    double? discountPercentage,
    String? imageUrl,
    bool? isActive,
    List<String>? terms,
    String? contactEmail,
    String? contactPhone,
    String? website,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Special(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      establishmentName: establishmentName ?? this.establishmentName,
      establishmentType: establishmentType ?? this.establishmentType,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      terms: terms ?? this.terms,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      website: website ?? this.website,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
