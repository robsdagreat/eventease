import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_type.dart';
import '../models/venue.dart';
import '../widgets/cards/venue_card.dart';
import 'event_registration_screen.dart';

class VenueSuggestionsScreen extends StatefulWidget {
  final EventType eventType;

  const VenueSuggestionsScreen({
    Key? key,
    required this.eventType,
  }) : super(key: key);

  @override
  State<VenueSuggestionsScreen> createState() => _VenueSuggestionsScreenState();
}

class _VenueSuggestionsScreenState extends State<VenueSuggestionsScreen> {
  final TextEditingController _capacityController = TextEditingController();
  List<Venue> _suggestedVenues = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _capacityController.text = widget.eventType.minCapacity.toString();
    _fetchSuggestedVenues();
  }

  @override
  void dispose() {
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _fetchSuggestedVenues() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final capacity = int.tryParse(_capacityController.text) ??
          widget.eventType.minCapacity;

      // Demo venues including homepage venues and additional ones for each category
      final demoVenues = [
        // Original venues from homepage
        {
          'id': '1',
          'name': 'The Elements',
          'location': 'South Jakarta',
          'rating': 5.0,
          'imageUrl': 'https://picsum.photos/id/237/400/300',
          'capacity': 250,
          'venueType': 'Wedding',
          'description':
              'A luxurious venue perfect for weddings and grand celebrations. Features modern architecture with elegant interiors.',
          'amenities': [
            'Parking',
            'WiFi',
            'Catering Services',
            'Sound System',
            'Stage'
          ],
        },
        {
          'id': '2',
          'name': 'Urban Loft',
          'location': 'City Center',
          'rating': 4.9,
          'imageUrl': 'https://picsum.photos/id/238/400/300',
          'capacity': 100,
          'venueType': 'Corporate',
          'description':
              'Modern corporate space ideal for conferences, seminars, and business meetings.',
          'amenities': [
            'High-speed Internet',
            'Projector',
            'Conference System',
            'Coffee Service'
          ],
        },
        {
          'id': '3',
          'name': 'Country Mansion',
          'location': 'Countryside',
          'rating': 4.7,
          'imageUrl': 'https://picsum.photos/id/239/400/300',
          'capacity': 400,
          'venueType': 'Multi-purpose',
          'description':
              'Spacious mansion with both indoor and outdoor spaces, perfect for any type of event.',
          'amenities': ['Garden', 'Pool', 'Kitchen', 'Parking', 'Security'],
        },
        // Additional Wedding Venues
        {
          'id': '4',
          'name': 'Garden Paradise',
          'location': 'Botanical Gardens',
          'rating': 4.8,
          'imageUrl': 'https://picsum.photos/id/243/400/300',
          'capacity': 300,
          'venueType': 'Wedding',
          'description':
              'Beautiful outdoor venue surrounded by lush gardens and water features.',
          'amenities': [
            'Outdoor Ceremony Space',
            'Indoor Reception Hall',
            'Bridal Suite',
            'Parking',
            'Catering Kitchen'
          ],
        },
        {
          'id': '5',
          'name': 'Grand Ballroom',
          'location': 'Luxury Hotel',
          'rating': 4.9,
          'imageUrl': 'https://picsum.photos/id/244/400/300',
          'capacity': 500,
          'venueType': 'Wedding',
          'description':
              'Elegant ballroom with crystal chandeliers and marble floors.',
          'amenities': [
            'Bridal Suite',
            'Catering Services',
            'Sound System',
            'Lighting',
            'Valet Parking'
          ],
        },
        // Additional Corporate Venues
        {
          'id': '6',
          'name': 'Tech Hub',
          'location': 'Silicon Valley',
          'rating': 4.8,
          'imageUrl': 'https://picsum.photos/id/245/400/300',
          'capacity': 200,
          'venueType': 'Corporate',
          'description':
              'Modern venue with state-of-the-art technology for conferences and meetings.',
          'amenities': [
            '5G WiFi',
            'Video Conferencing',
            'Breakout Rooms',
            'Catering',
            'Tech Support'
          ],
        },
        {
          'id': '7',
          'name': 'Business Center',
          'location': 'Financial District',
          'rating': 4.7,
          'imageUrl': 'https://picsum.photos/id/246/400/300',
          'capacity': 300,
          'venueType': 'Corporate',
          'description':
              'Professional venue with multiple conference rooms and networking spaces.',
          'amenities': [
            'Meeting Rooms',
            'Presentation Equipment',
            'Business Center',
            'Coffee Bar',
            'Parking'
          ],
        },
        // Concert Venues
        {
          'id': '8',
          'name': 'Arena Stadium',
          'location': 'Entertainment District',
          'rating': 4.9,
          'imageUrl': 'https://picsum.photos/id/247/400/300',
          'capacity': 5000,
          'venueType': 'Concert',
          'description':
              'Massive indoor arena with excellent acoustics and viewing angles.',
          'amenities': [
            'Professional Sound System',
            'Lighting Rig',
            'Green Rooms',
            'VIP Areas',
            'Multiple Bars'
          ],
        },
        {
          'id': '9',
          'name': 'Amphitheater',
          'location': 'Riverside Park',
          'rating': 4.6,
          'imageUrl': 'https://picsum.photos/id/248/400/300',
          'capacity': 3000,
          'venueType': 'Concert',
          'description':
              'Beautiful outdoor venue with natural acoustics and river views.',
          'amenities': [
            'Stage',
            'Sound System',
            'Lawn Seating',
            'Food Court',
            'Restrooms'
          ],
        },
        // Exhibition Venues
        {
          'id': '10',
          'name': 'Convention Center',
          'location': 'Downtown',
          'rating': 4.8,
          'imageUrl': 'https://picsum.photos/id/249/400/300',
          'capacity': 2000,
          'venueType': 'Exhibition',
          'description':
              'Large convention center with flexible space configurations.',
          'amenities': [
            'Exhibition Halls',
            'Meeting Rooms',
            'Loading Docks',
            'Catering',
            'WiFi'
          ],
        },
        {
          'id': '11',
          'name': 'Art Gallery',
          'location': 'Cultural District',
          'rating': 4.7,
          'imageUrl': 'https://picsum.photos/id/250/400/300',
          'capacity': 800,
          'venueType': 'Exhibition',
          'description':
              'Modern gallery space with excellent lighting and display options.',
          'amenities': [
            'Display Lighting',
            'Security System',
            'Climate Control',
            'Storage',
            'Gift Shop'
          ],
        },
        // Birthday Venues
        {
          'id': '12',
          'name': 'Fun Zone',
          'location': 'Entertainment Center',
          'rating': 4.6,
          'imageUrl': 'https://picsum.photos/id/251/400/300',
          'capacity': 100,
          'venueType': 'Birthday',
          'description':
              'Exciting venue with games and activities for all ages.',
          'amenities': [
            'Game Room',
            'Party Rooms',
            'Catering',
            'Sound System',
            'Party Supplies'
          ],
        },
        {
          'id': '13',
          'name': 'Theme Park Hall',
          'location': 'Adventure Park',
          'rating': 4.5,
          'imageUrl': 'https://picsum.photos/id/252/400/300',
          'capacity': 200,
          'venueType': 'Birthday',
          'description': 'Themed party venue with access to park attractions.',
          'amenities': [
            'Theme Decorations',
            'Catering',
            'Entertainment',
            'Party Hosts',
            'Photo Area'
          ],
        },
        // Additional Multi-purpose Venue
        {
          'id': '14',
          'name': 'City Hall',
          'location': 'Central Square',
          'rating': 4.8,
          'imageUrl': 'https://picsum.photos/id/253/400/300',
          'capacity': 600,
          'venueType': 'Multi-purpose',
          'description':
              'Historic venue suitable for various events with classic architecture.',
          'amenities': [
            'Multiple Halls',
            'Kitchen',
            'Sound System',
            'Parking',
            'Outdoor Space'
          ],
        }
      ];

      // Try to get venues from Firestore first
      final querySnapshot = await FirebaseFirestore.instance
          .collection('venues')
          .where('capacity', isGreaterThanOrEqualTo: capacity)
          .get();

      List<Venue> venues = [];

      if (querySnapshot.docs.isEmpty) {
        // If no venues in Firestore, use demo venues
        venues = demoVenues
            .map((data) => Venue.fromMap(data))
            .where((venue) =>
                venue.venueType.toLowerCase() ==
                    widget.eventType.name.toLowerCase() ||
                venue.venueType == 'Multi-purpose')
            .where((venue) => venue.capacity >= capacity)
            .toList();
      } else {
        venues = querySnapshot.docs
            .map((doc) => Venue.fromMap(doc.data()))
            .where((venue) =>
                venue.venueType.toLowerCase() ==
                    widget.eventType.name.toLowerCase() ||
                venue.venueType == 'Multi-purpose')
            .toList();
      }

      setState(() {
        _suggestedVenues = venues;
        if (_suggestedVenues.isEmpty) {
          _errorMessage =
              'No venues found for your criteria. Try adjusting the capacity.';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching venues. Please try again.';
      });
      debugPrint('Error fetching venues: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onVenueSelected(Venue venue) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventRegistrationScreen(
          eventType: widget.eventType,
          venue: venue,
          expectedCapacity: int.tryParse(_capacityController.text) ??
              widget.eventType.minCapacity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.eventType.name} Venues'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Capacity input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Expected Number of Guests',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _capacityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter number of guests',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _fetchSuggestedVenues,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Recommended capacity: ${widget.eventType.minCapacity} - ${widget.eventType.maxCapacity} people',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Error message
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          // Venue list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _suggestedVenues.isEmpty
                    ? const Center(
                        child: Text('No venues found for your criteria'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _suggestedVenues.length,
                        itemBuilder: (context, index) {
                          final venue = _suggestedVenues[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GestureDetector(
                              onTap: () => _onVenueSelected(venue),
                              child: VenueCard(venue: venue),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
