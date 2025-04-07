import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';
import '../widgets/cards/event_card.dart';
import 'event_type_screen.dart';

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
        location: 'Central Park',
        date: DateTime(2025, 6, 15),
        capacity: 1000,
        eventTypeId: 'festival',
        venueId: '1',
        userId: '1',
        isActive: true,
      ),
      Event(
        id: '2',
        name: 'Tech Conference',
        description: 'Annual technology conference featuring industry leaders',
        imageUrl: 'https://picsum.photos/id/1001/400/300',
        location: 'Convention Center',
        date: DateTime(2025, 5, 22),
        capacity: 500,
        eventTypeId: 'conference',
        venueId: '2',
        userId: '1',
        isActive: true,
      ),
      Event(
        id: '3',
        name: 'Food & Wine Expo',
        description:
            'Experience the finest food and wine from around the world',
        imageUrl: 'https://picsum.photos/id/1002/400/300',
        location: 'Riverside Gardens',
        date: DateTime(2025, 7, 3),
        capacity: 300,
        eventTypeId: 'expo',
        venueId: '3',
        userId: '1',
        isActive: true,
      ),
    ];
  }

  Future<void> _fetchEvents() async {
    try {
      // Get current date at midnight
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('date', isGreaterThanOrEqualTo: today)
          .orderBy('date')
          .get();

      final firebaseEvents =
          querySnapshot.docs.map((doc) => Event.fromMap(doc.data())).toList();

      setState(() {
        // If no events in Firebase, use demo events
        _events = firebaseEvents.isEmpty ? _getDemoEvents() : firebaseEvents;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching events: $e');
      // If there's an error, fall back to demo events
      setState(() {
        _events = _getDemoEvents();
        _isLoading = false;
      });
    }
  }

  List<Event> _getFilteredEvents() {
    if (_selectedFilter == 'All') {
      return _events;
    }
    return _events
        .where((event) =>
            event.eventTypeId.toLowerCase() == _selectedFilter.toLowerCase())
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
                    // Header section with styled container
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
                          Row(
                            children: [
                              Icon(
                                Icons.event,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
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
                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: _filterOptions.map((option) {
                          final isSelected = _selectedFilter == option;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(
                                option,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.purple,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFilter = option;
                                });
                              },
                              selectedColor: Colors.purpleAccent,
                              backgroundColor: Colors.purple.withOpacity(0.1),
                              checkmarkColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
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
                                  const Text(
                                    'No events found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Be the first to host an event!',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EventTypeScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purpleAccent,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    icon: const Icon(Icons.add),
                                    label: const Text(
                                      'Host an Event',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: _getFilteredEvents().length,
                              itemBuilder: (context, index) {
                                final event = _getFilteredEvents()[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: EventCard(event: event),
                                );
                              },
                            ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EventTypeScreen(),
            ),
          );
        },
        backgroundColor: Colors.purpleAccent,
        icon: const Icon(Icons.add),
        label: const Text('Host Event'),
      ),
    );
  }
}
