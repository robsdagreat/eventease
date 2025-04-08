import '../models/event.dart';
import '../models/venue.dart';
import '../models/special.dart';

class SearchService {
  // Search across all categories
  static List<dynamic> searchAll({
    required List<Event> events,
    required List<Venue> venues,
    required List<Special> specials,
    required String query,
  }) {
    final results = <dynamic>[];
    final queryLower = query.toLowerCase();

    // Search events
    results.addAll(events.where((event) {
      // Find the associated venue for the event
      final venue = venues.firstWhere(
        (v) => v.id == event.venueId,
        orElse: () => Venue(
          id: '',
          name: '',
          location: '',
          rating: 0,
          imageUrl: '',
          capacity: 0,
          venueType: '',
          description: '',
          amenities: [],
        ),
      );

      return event.name.toLowerCase().contains(queryLower) ||
          event.description.toLowerCase().contains(queryLower) ||
          event.eventType.toLowerCase().contains(queryLower) ||
          venue.location.toLowerCase().contains(queryLower) ||
          _formatDate(event.date).toLowerCase().contains(queryLower);
    }));

    // Search venues
    results.addAll(venues.where((venue) =>
        venue.name.toLowerCase().contains(queryLower) ||
        venue.location.toLowerCase().contains(queryLower) ||
        venue.venueType.toLowerCase().contains(queryLower)));

    // Search specials
    results.addAll(specials.where((special) =>
        special.name.toLowerCase().contains(queryLower) ||
        special.location.toLowerCase().contains(queryLower) ||
        special.discount.toLowerCase().contains(queryLower)));

    return results;
  }

  // Helper method to format date for search
  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Get type of search result item
  static String getItemType(dynamic item) {
    if (item is Event) return 'Event';
    if (item is Venue) return 'Venue';
    if (item is Special) return 'Special';
    return 'Unknown';
  }

  // Get recent searches (this would be expanded with shared preferences storage)
  static List<String> getRecentSearches() {
    // In a real app, these would be stored and retrieved from SharedPreferences
    return [
      'Beach events',
      'Wedding venues',
      'Weekend specials',
      'Conference rooms'
    ];
  }

  // Save a search query (in a real app)
  static Future<void> saveSearch(String query) async {
    // Here you would implement saving to SharedPreferences or other storage
    // For example:
    // final prefs = await SharedPreferences.getInstance();
    // List<String> searches = prefs.getStringList('recent_searches') ?? [];
    // if (!searches.contains(query)) {
    //   searches.insert(0, query);
    //   if (searches.length > 10) searches = searches.sublist(0, 10);
    //   await prefs.setStringList('recent_searches', searches);
    // }
  }
}
