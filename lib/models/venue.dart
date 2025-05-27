class Venue {
  final String id;
  final String name;
  final String description;
  final String location;
  final String address;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final String venueType; // e.g., 'restaurant', 'hotel', 'conference_center'
  final int capacity;
  final double rating;
  final List<String> amenities;
  final List<String> images;
  final String? contactEmail;
  final String? contactPhone;
  final String? website;
  final Map<String, dynamic>? pricing;
  final List<String>? specialOffers; // List of special offer IDs
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  Venue({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.venueType,
    required this.capacity,
    required this.rating,
    required this.amenities,
    required this.images,
    this.contactEmail,
    this.contactPhone,
    this.website,
    this.pricing,
    this.specialOffers,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      location: json['location'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postal_code'].toString(),
      venueType: json['venue_type'].toString(),
      capacity: json['capacity'],
      rating: json['rating']?.toDouble() ?? 0.0,
      amenities: List<String>.from(json['amenities'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      contactEmail: json['contact_email'],
      contactPhone: json['contact_phone'],
      website: json['website'],
      pricing: json['pricing'],
      specialOffers: json['special_offers'] == null
          ? null
          : List<String>.from(json['special_offers']),
      isAvailable: json['is_available'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
      'venue_type': venueType,
      'capacity': capacity,
      'rating': rating,
      'amenities': amenities,
      'images': images,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'website': website,
      'pricing': pricing,
      'special_offers': specialOffers,
      'is_available': isAvailable,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Venue copyWith({
    String? id,
    String? name,
    String? description,
    String? location,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    double? latitude,
    double? longitude,
    String? venueType,
    int? capacity,
    double? rating,
    List<String>? amenities,
    List<String>? images,
    String? contactEmail,
    String? contactPhone,
    String? website,
    Map<String, dynamic>? pricing,
    List<String>? specialOffers,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Venue(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      venueType: venueType ?? this.venueType,
      capacity: capacity ?? this.capacity,
      rating: rating ?? this.rating,
      amenities: amenities ?? this.amenities,
      images: images ?? this.images,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      website: website ?? this.website,
      pricing: pricing ?? this.pricing,
      specialOffers: specialOffers ?? this.specialOffers,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
