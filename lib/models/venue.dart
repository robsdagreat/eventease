import 'package:cloud_firestore/cloud_firestore.dart';

class Venue {
  final String id;
  final String name;
  final String location;
  final double rating;
  final String? imageUrl;
  final int capacity; // Number of people the venue can accommodate
  final String
      venueType; // Type of events the venue is suitable for (e.g., 'Wedding', 'Conference', 'Concert', etc.)
  final String description; // Detailed description of the venue
  final List<String> amenities; // List of available amenities
  final double pricePerHour;
  final double pricePerDay;
  final bool isAvailable;
  final String? contactEmail;
  final String? contactPhone;
  final String? website;
  final List<String>? images;
  final Map<String, dynamic>? availability;
  final Map<String, dynamic>? pricing;
  final List<String>? restrictions;
  final List<String>? features;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final double? latitude;
  final double? longitude;

  Venue({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    this.imageUrl,
    required this.capacity,
    required this.venueType,
    required this.description,
    required this.amenities,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.isAvailable,
    this.contactEmail,
    this.contactPhone,
    this.website,
    this.images,
    this.availability,
    this.pricing,
    this.restrictions,
    this.features,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.latitude,
    this.longitude,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      rating: json['rating']?.toDouble() ?? 0.0,
      imageUrl: json['image_url'],
      capacity: json['capacity'],
      venueType: json['venue_type'],
      description: json['description'],
      amenities: List<String>.from(json['amenities'] ?? []),
      pricePerHour: json['price_per_hour']?.toDouble() ?? 0.0,
      pricePerDay: json['price_per_day']?.toDouble() ?? 0.0,
      isAvailable: json['is_available'] ?? true,
      contactEmail: json['contact_email'],
      contactPhone: json['contact_phone'],
      website: json['website'],
      images: List<String>.from(json['images'] ?? []),
      availability: json['availability'],
      pricing: json['pricing'],
      restrictions: List<String>.from(json['restrictions'] ?? []),
      features: List<String>.from(json['features'] ?? []),
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postal_code'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'rating': rating,
      'image_url': imageUrl,
      'capacity': capacity,
      'venue_type': venueType,
      'description': description,
      'amenities': amenities,
      'price_per_hour': pricePerHour,
      'price_per_day': pricePerDay,
      'is_available': isAvailable,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'website': website,
      'images': images,
      'availability': availability,
      'pricing': pricing,
      'restrictions': restrictions,
      'features': features,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
