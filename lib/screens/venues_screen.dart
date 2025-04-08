import 'package:flutter/material.dart';
import '../models/venue.dart';
import '../widgets/cards/venue_card.dart';
import 'single_venue_screen.dart';

class VenuesScreen extends StatefulWidget {
  const VenuesScreen({Key? key}) : super(key: key);

  @override
  State<VenuesScreen> createState() => _VenuesScreenState();
}

class _VenuesScreenState extends State<VenuesScreen> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Wedding',
    'Corporate',
    'Concert',
    'Exhibition',
    'Birthday',
    'Multi-purpose'
  ];

  // Demo venues - you can replace this with Firebase fetch later
  final List<Venue> _venues = [
    Venue(
      id: '1',
      name: 'The Elements',
      location: 'South Jakarta',
      rating: 5.0,
      imageUrl: 'https://picsum.photos/id/237/400/300',
      capacity: 250,
      venueType: 'Wedding',
      description:
          'A luxurious venue perfect for weddings and grand celebrations. Features modern architecture with elegant interiors.',
      amenities: [
        'Parking',
        'WiFi',
        'Catering Services',
        'Sound System',
        'Stage'
      ],
    ),
    Venue(
      id: '2',
      name: 'Urban Loft',
      location: 'City Center',
      rating: 4.9,
      imageUrl: 'https://picsum.photos/id/238/400/300',
      capacity: 100,
      venueType: 'Corporate',
      description:
          'Modern corporate space ideal for conferences, seminars, and business meetings.',
      amenities: [
        'High-speed Internet',
        'Projector',
        'Conference System',
        'Coffee Service'
      ],
    ),
    Venue(
      id: '3',
      name: 'Country Mansion',
      location: 'Countryside',
      rating: 4.7,
      imageUrl: 'https://picsum.photos/id/239/400/300',
      capacity: 400,
      venueType: 'Multi-purpose',
      description:
          'Spacious mansion with both indoor and outdoor spaces, perfect for any type of event.',
      amenities: ['Garden', 'Pool', 'Kitchen', 'Parking', 'Security'],
    ),
    Venue(
      id: '4',
      name: 'Arena Stadium',
      location: 'Entertainment District',
      rating: 4.9,
      imageUrl: 'https://picsum.photos/id/247/400/300',
      capacity: 5000,
      venueType: 'Concert',
      description:
          'Massive indoor arena with excellent acoustics and viewing angles.',
      amenities: [
        'Professional Sound System',
        'Lighting Rig',
        'Green Rooms',
        'VIP Areas',
        'Multiple Bars'
      ],
    ),
    Venue(
      id: '5',
      name: 'Convention Center',
      location: 'Downtown',
      rating: 4.8,
      imageUrl: 'https://picsum.photos/id/249/400/300',
      capacity: 2000,
      venueType: 'Exhibition',
      description:
          'Large convention center with flexible space configurations.',
      amenities: [
        'Exhibition Halls',
        'Meeting Rooms',
        'Loading Docks',
        'Catering',
        'WiFi'
      ],
    ),
    Venue(
      id: '6',
      name: 'Fun Zone',
      location: 'Entertainment Center',
      rating: 4.6,
      imageUrl: 'https://picsum.photos/id/251/400/300',
      capacity: 100,
      venueType: 'Birthday',
      description: 'Exciting venue with games and activities for all ages.',
      amenities: [
        'Game Room',
        'Party Rooms',
        'Catering',
        'Sound System',
        'Party Supplies'
      ],
    ),
  ];

  List<Venue> get _filteredVenues {
    if (_selectedFilter == 'All') {
      return _venues;
    }
    return _venues
        .where((venue) => venue.venueType == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Explore Venues',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://picsum.photos/id/1048/800/400',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filterOptions.length,
                itemBuilder: (context, index) {
                  final filter = _filterOptions[index];
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(filter),
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      selectedColor: Colors.purpleAccent.withOpacity(0.2),
                      checkmarkColor: Colors.purpleAccent,
                      backgroundColor: Colors.grey.shade800,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.purpleAccent : Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final venue = _filteredVenues[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleVenueScreen(venue: venue),
                        ),
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Stack(
                              children: [
                                Image.network(
                                  venue.imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.amber,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          venue.rating.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    venue.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          venue.location,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade400,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.people,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Up to ${venue.capacity}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _filteredVenues.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
