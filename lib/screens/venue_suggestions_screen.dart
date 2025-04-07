import 'package:flutter/material.dart';
import '../models/event_type.dart';
import '../models/venue.dart';
import '../widgets/cards/venue_card.dart';

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
    setState(() => _isLoading = true);

    try {
      // TODO: Replace with actual Firebase query
      // For now, using sample data
      await Future.delayed(const Duration(seconds: 1));
      _suggestedVenues = [
        Venue(
          id: '1',
          name: 'Grand Ballroom',
          location: 'City Center',
          rating: 4.8,
          imageUrl: 'https://picsum.photos/id/1031/400/300',
          capacity: 300,
          venueType: widget.eventType.id,
          description: 'Elegant venue with modern amenities',
          amenities: ['Parking', 'WiFi', 'Sound System', 'Catering'],
        ),
        Venue(
          id: '2',
          name: 'Garden Paradise',
          location: 'Suburban Area',
          rating: 4.5,
          imageUrl: 'https://picsum.photos/id/1040/400/300',
          capacity: 200,
          venueType: widget.eventType.id,
          description: 'Beautiful outdoor venue with indoor backup',
          amenities: ['Garden', 'Parking', 'Catering', 'Lighting'],
        ),
      ];
    } catch (e) {
      // Handle error
      debugPrint('Error fetching venues: $e');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Venues for ${widget.eventType.name}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
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
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: VenueCard(venue: _suggestedVenues[index]),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
