import 'package:flutter/material.dart';
import '../models/event.dart';
import '../widgets/cards/event_card.dart';
import 'event_venue_finder_screen.dart';
import '../theme/app_colors.dart'; // Import AppColors

class UpcomingEventsScreen extends StatefulWidget {
  const UpcomingEventsScreen({Key? key}) : super(key: key);

  @override
  State<UpcomingEventsScreen> createState() => _UpcomingEventsScreenState();
}

class _UpcomingEventsScreenState extends State<UpcomingEventsScreen> {
  final List<String> _filterOptions = [
    'All',
    'Wedding',
    'Corporate',
    'Birthday',
    'Concert',
    'Exhibition',
    'Other'
  ];
  String _selectedFilter = 'All';
  List<Event> _events = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  List<Event> _getDemoEvents() {
    return [
      Event(
        id: '1',
        name: 'Summer Festival',
        description:
            'A fun-filled summer festival with music, food, and activities',
        imageUrl: 'https://picsum.photos/id/1000/400/300',
        startTime: DateTime(2025, 6, 15),
        endTime: DateTime(2025, 6, 16),
        eventType: 'Festival',
        venueId: '1',
        venueName: 'The Elements',
        userId: '1',
        organizerName: 'Event Organizers Inc',
        isPublic: true,
        expectedAttendees: 1000,
        status: 'published',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Event(
        id: '2',
        name: 'Tech Conference',
        description: 'Annual technology conference featuring industry leaders',
        imageUrl: 'https://picsum.photos/id/1001/400/300',
        startTime: DateTime(2025, 5, 22),
        endTime: DateTime(2025, 5, 23),
        eventType: 'Corporate',
        venueId: '2',
        venueName: 'Urban Loft',
        userId: '1',
        organizerName: 'Tech Events Co',
        isPublic: true,
        expectedAttendees: 500,
        status: 'published',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Event(
        id: '3',
        name: 'Food & Wine Expo',
        description:
            'Experience the finest food and wine from around the world',
        imageUrl: 'https://picsum.photos/id/1002/400/300',
        startTime: DateTime(2025, 7, 3),
        endTime: DateTime(2025, 7, 4),
        eventType: 'Exhibition',
        venueId: '3',
        venueName: 'Country Mansion',
        userId: '1',
        organizerName: 'Gourmet Events',
        isPublic: true,
        expectedAttendees: 300,
        status: 'published',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final fetchedEvents = _getDemoEvents();

      // Filter for upcoming dates
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final upcomingDemoEvents = fetchedEvents
          .where((event) => !event.startTime.isBefore(today))
          .toList();
      // Sort demo events by start time
      upcomingDemoEvents.sort((a, b) => a.startTime.compareTo(b.startTime));

      setState(() {
        _events = upcomingDemoEvents;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _events = [];
        _errorMessage = 'Error processing demo events. Please try again.';
        _isLoading = false;
      });
      debugPrint('Error processing demo events: $e');
    }
  }

  List<Event> _getFilteredEvents() {
    if (_selectedFilter == 'All') {
      return _events;
    }
    return _events
        .where((event) =>
            event.eventType.toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: AppColors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchEvents,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C0B3F),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.event,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Discover Amazing Events',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'From weddings to concerts, find the perfect event to attend or get inspired to host your own!',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: 16), // Added space below the container
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0), // Added horizontal padding
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .purple, // Using a purple color similar to the image
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const EventVenueFinderScreen(),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Added row for icon and text
                              Icon(Icons.add,
                                  color: Colors.white), // Added icon
                              SizedBox(width: 8), // Added spacing
                              Text(
                                'Host Your Own Event',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: _filterOptions.map((filter) {
                          final isSelected = _selectedFilter == filter;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedFilter = filter;
                                  });
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF2C0B3F)
                                        : Colors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.purpleAccent
                                          : Colors.purple.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    filter,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.purple,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Events list
                    Expanded(
                      child: _getFilteredEvents().isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.event_busy,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No upcoming events match your filters.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.add),
                                    label: const Text('Host an Event Instead?'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EventVenueFinderScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purpleAccent,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                      textStyle: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16),
                              itemCount: _getFilteredEvents().length,
                              itemBuilder: (context, index) {
                                final event = _getFilteredEvents()[index];
                                return EventCard(event: event);
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}
