class Venue {
  final String id;
  final String name;
  final String location;
  final double pricePerDay;
  final double rating;
  final String imageUrl;
  final int capacity;
  final int beds;
  final int baths;
  final int size;

  Venue({
    required this.id,
    required this.name,
    required this.location,
    required this.pricePerDay,
    required this.rating,
    required this.imageUrl,
    required this.capacity,
    required this.beds,
    required this.baths,
    required this.size,
  });
}
