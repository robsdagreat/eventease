class Venue {
  final String id;
  final String name;
  final String location;
  final double rating;
  final String imageUrl;
  final int capacity; // Number of people the venue can accommodate
  final String
      venueType; // Type of events the venue is suitable for (e.g., 'Wedding', 'Conference', 'Concert', etc.)
  final String description; // Detailed description of the venue
  final List<String> amenities; // List of available amenities

  Venue({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.imageUrl,
    required this.capacity,
    required this.venueType,
    required this.description,
    required this.amenities,
  });

  // Factory method to create a Venue from a map (useful for Firebase)
  factory Venue.fromMap(Map<String, dynamic> map) {
    return Venue(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      capacity: map['capacity'] ?? 0,
      venueType: map['venueType'] ?? '',
      description: map['description'] ?? '',
      amenities: List<String>.from(map['amenities'] ?? []),
    );
  }

  // Method to convert Venue to a map (useful for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'rating': rating,
      'imageUrl': imageUrl,
      'capacity': capacity,
      'venueType': venueType,
      'description': description,
      'amenities': amenities,
    };
  }
}
