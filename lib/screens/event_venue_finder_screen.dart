import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_type.dart';
import '../models/venue.dart';
import '../widgets/cards/venue_card.dart';
import 'event_registration_screen.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import 'auth_screen.dart';

class EventVenueFinderScreen extends StatefulWidget {
  const EventVenueFinderScreen({Key? key}) : super(key: key);

  @override
  State<EventVenueFinderScreen> createState() => _EventVenueFinderScreenState();
}

class _EventVenueFinderScreenState extends State<EventVenueFinderScreen> {
  final TextEditingController _capacityController = TextEditingController();
  List<Venue> _suggestedVenues = [];
  bool _isLoading = false;
  String? _errorMessage;
  late AuthService _authService;

  List<EventType> _eventTypes = [];
  EventType? _selectedEventType;

  @override
  void initState() {
    super.initState();
    _authService = Provider.of<AuthService>(context, listen: false);
    _eventTypes = EventType.types;
    _fetchSuggestedVenues();
  }

  @override
  void dispose() {
    _capacityController.dispose();
    super.dispose();
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'favorite':
        return Icons.favorite;
      case 'business':
        return Icons.business;
      case 'cake':
        return Icons.cake;
      case 'music_note':
        return Icons.music_note;
      case 'museum':
        return Icons.museum;
      case 'people':
        return Icons.people;
      case 'group':
        return Icons.group;
      default:
        return Icons.event;
    }
  }

  Future<void> _fetchSuggestedVenues() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate network delay (optional)
    // await Future.delayed(const Duration(milliseconds: 500));

    try {
      final capacity = int.tryParse(_capacityController.text) ?? 0;

      // --- REVERTED: Always use demo venues ---
      List<Venue> sourceVenues = _getDemoVenues();
      List<Venue> venues = [];
      // --- END REVERTED ---

      // Keep client-side filtering
      venues = sourceVenues.where((venue) {
        final capacityMatch = capacity <= 0 || venue.capacity >= capacity;
        final typeMatch = _selectedEventType == null ||
            venue.venueType.toLowerCase() ==
                _selectedEventType!.name.toLowerCase() ||
            venue.venueType == 'Multi-purpose';
        return capacityMatch && typeMatch;
      }).toList();

      setState(() {
        _suggestedVenues = venues;
        if (_suggestedVenues.isEmpty) {
          _errorMessage =
              'No venues found for your criteria. Try adjusting filters or capacity.';
        }
        _isLoading = false; // Set loading false here
      });
    } catch (e) {
      // Keep error handling for potential issues in demo data or filtering
      setState(() {
        _suggestedVenues = []; // Clear venues on error
        _errorMessage = 'Error filtering demo venues. Please try again.';
        _isLoading = false;
      });
      debugPrint('Error processing demo venues: $e');
    }
    // Removed finally block as isLoading is set within try/catch
  }

  List<Venue> _getDemoVenues() {
    return [
      Venue(
        id: '1',
        name: 'The Elements',
        location: 'South Jakarta',
        rating: 5.0,
        imageUrl: 'https://picsum.photos/id/237/400/300',
        capacity: 250,
        venueType: 'Wedding',
        description:
            'A luxurious venue perfect for weddings and grand celebrations.',
        amenities: ['Parking', 'WiFi', 'Catering', 'Sound System'],
      ),
      Venue(
        id: '2',
        name: 'Grand Ballroom Central',
        location: 'Central Jakarta',
        rating: 4.8,
        imageUrl: 'https://picsum.photos/id/238/400/300',
        capacity: 800,
        venueType: 'Corporate Event',
        description: 'Ideal for large corporate events and conferences.',
        amenities: ['Projector', 'Stage', 'Parking', 'WiFi'],
      ),
      Venue(
        id: '3',
        name: 'Cozy Cafe Corner',
        location: 'West Jakarta',
        rating: 4.5,
        imageUrl: 'https://picsum.photos/id/239/400/300',
        capacity: 50,
        venueType: 'Birthday Party',
        description: 'A small, intimate cafe for birthday parties.',
        amenities: ['WiFi', 'Coffee', 'Snacks'],
      ),
      Venue(
        id: '4',
        name: 'Exhibition Hall Alpha',
        location: 'North Jakarta',
        rating: 4.7,
        imageUrl: 'https://picsum.photos/id/240/400/300',
        capacity: 1500,
        venueType: 'Exhibition',
        description: 'Spacious hall for major conferences and exhibitions.',
        amenities: ['Large Screens', 'Booths', 'Parking', 'Food Court'],
      ),
      Venue(
        id: '5',
        name: 'Riverside Garden',
        location: 'East Jakarta',
        rating: 4.9,
        imageUrl: 'https://picsum.photos/id/241/400/300',
        capacity: 120,
        venueType: 'Social Gathering',
        description: 'Beautiful outdoor garden space for social events.',
        amenities: ['Garden', 'Outdoor Seating', 'BBQ Area'],
      ),
      Venue(
        id: '6',
        name: 'Multipurpose Hub One',
        location: 'Central Jakarta',
        rating: 4.6,
        imageUrl: 'https://picsum.photos/id/242/400/300',
        capacity: 300,
        venueType: 'Multi-purpose',
        description: 'Flexible space suitable for various event types.',
        amenities: ['Parking', 'WiFi', 'AV Equipment', 'Kitchenette'],
      ),
      Venue(
        id: '7',
        name: 'Arena Maxima',
        location: 'South Jakarta',
        rating: 4.9,
        imageUrl: 'https://picsum.photos/id/243/400/300',
        capacity: 4500,
        venueType: 'Concert',
        description: 'Large arena for concerts and major performances.',
        amenities: ['Stage', 'Sound System', 'Parking', 'Seating'],
      ),
    ];
  }

  void _onVenueSelected(Venue venue) {
    if (_authService.currentUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
      return;
    }

    final eventTypeForRegistration = _selectedEventType ??
        EventType(
            id: 'general',
            name: 'General',
            icon: 'event',
            description: 'General Event',
            imageUrl: '',
            minCapacity: 1,
            maxCapacity: 10000);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventRegistrationScreen(
          eventType: eventTypeForRegistration,
          venue: venue,
          expectedCapacity: int.tryParse(_capacityController.text) ?? 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final isLoggedIn = authService.currentUser != null;

    if (!isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _authService.currentUser == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AuthScreen()),
          );
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Venue'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    hintText: 'Enter number of guests (optional)',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _fetchSuggestedVenues,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (_) => _fetchSuggestedVenues(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Filter by Event Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    FilterChip(
                      label: const Text('All Types'),
                      selected: _selectedEventType == null,
                      onSelected: (selected) {
                        setState(() {
                          _selectedEventType = null;
                        });
                        _fetchSuggestedVenues();
                      },
                      avatar: const Icon(Icons.apps),
                    ),
                    ..._eventTypes.map((type) {
                      return FilterChip(
                        label: Text(type.name),
                        selected: _selectedEventType?.id == type.id,
                        onSelected: (selected) {
                          setState(() {
                            _selectedEventType = selected ? type : null;
                          });
                          _fetchSuggestedVenues();
                        },
                        avatar: Icon(_getIconData(type.icon)),
                      );
                    }).toList(),
                  ],
                ),
                const SizedBox(height: 8),
                if (_selectedEventType != null)
                  Text(
                    'Recommended capacity for ${_selectedEventType!.name}: ${_selectedEventType!.minCapacity} - ${_selectedEventType!.maxCapacity} people',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 32),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _suggestedVenues.isEmpty
                    ? const Center(
                        child: Text(
                          'No venues match your criteria.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 16),
                        itemCount: _suggestedVenues.length,
                        itemBuilder: (context, index) {
                          final venue = _suggestedVenues[index];
                          return VenueCard(
                            venue: venue,
                            onTap: () => _onVenueSelected(venue),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
