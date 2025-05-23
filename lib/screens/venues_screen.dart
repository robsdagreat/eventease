import 'package:flutter/material.dart';
import '../models/venue.dart';
import 'single_venue_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/cards/venue_card.dart';

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
      description:
          'A luxurious venue perfect for weddings and grand celebrations. Features modern architecture with elegant interiors.',
      location: 'South Jakarta',
      address: '123 Luxury Street',
      city: 'Jakarta',
      state: 'Jakarta',
      country: 'Indonesia',
      postalCode: '12345',
      venueType: 'Wedding',
      capacity: 250,
      rating: 5.0,
      amenities: [
        'Parking',
        'WiFi',
        'Catering Services',
        'Sound System',
        'Stage'
      ],
      images: ['https://picsum.photos/id/237/400/300'],
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Venue(
      id: '2',
      name: 'Urban Loft',
      description:
          'Modern corporate space ideal for conferences, seminars, and business meetings.',
      location: 'City Center',
      address: '456 Business Ave',
      city: 'Jakarta',
      state: 'Jakarta',
      country: 'Indonesia',
      postalCode: '67890',
      venueType: 'Corporate',
      capacity: 100,
      rating: 4.9,
      amenities: [
        'High-speed Internet',
        'Projector',
        'Conference System',
        'Coffee Service'
      ],
      images: ['https://picsum.photos/id/238/400/300'],
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Venue(
      id: '3',
      name: 'Country Mansion',
      description:
          'Spacious mansion with both indoor and outdoor spaces, perfect for any type of event.',
      location: 'Countryside',
      address: '789 Country Road',
      city: 'Bogor',
      state: 'West Java',
      country: 'Indonesia',
      postalCode: '54321',
      venueType: 'Multi-purpose',
      capacity: 400,
      rating: 4.7,
      amenities: ['Garden', 'Pool', 'Kitchen', 'Parking', 'Security'],
      images: ['https://picsum.photos/id/239/400/300'],
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Venue(
      id: '4',
      name: 'Arena Stadium',
      description:
          'Massive indoor arena with excellent acoustics and viewing angles.',
      location: 'Entertainment District',
      address: '101 Stadium Blvd',
      city: 'Jakarta',
      state: 'Jakarta',
      country: 'Indonesia',
      postalCode: '11223',
      venueType: 'Concert',
      capacity: 5000,
      rating: 4.9,
      amenities: [
        'Professional Sound System',
        'Lighting Rig',
        'Green Rooms',
        'VIP Areas',
        'Multiple Bars'
      ],
      images: ['https://picsum.photos/id/247/400/300'],
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Venue(
      id: '5',
      name: 'Convention Center',
      description:
          'Large convention center with flexible space configurations.',
      location: 'Downtown',
      address: '202 Convention St',
      city: 'Jakarta',
      state: 'Jakarta',
      country: 'Indonesia',
      postalCode: '44556',
      venueType: 'Exhibition',
      capacity: 2000,
      rating: 4.8,
      amenities: [
        'Exhibition Halls',
        'Meeting Rooms',
        'Loading Docks',
        'Catering',
        'WiFi'
      ],
      images: ['https://picsum.photos/id/249/400/300'],
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Venue(
      id: '6',
      name: 'Fun Zone',
      description: 'Exciting venue with games and activities for all ages.',
      location: 'Entertainment Center',
      address: '303 Fun Avenue',
      city: 'Jakarta',
      state: 'Jakarta',
      country: 'Indonesia',
      postalCode: '77889',
      venueType: 'Birthday',
      capacity: 100,
      rating: 4.6,
      amenities: [
        'Game Room',
        'Party Rooms',
        'Catering',
        'Sound System',
        'Party Supplies'
      ],
      images: ['https://picsum.photos/id/251/400/300'],
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
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
      backgroundColor: AppColors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: true,
            pinned: true,
            backgroundColor: AppColors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Explore Venues',
                style: TextStyle(
                  color: AppColors.white,
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
                          AppColors.black.withOpacity(0.7),
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
                          child: Center(
                            child: Text(
                              filter,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.white
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
                    ),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final venue = _filteredVenues[index];
                  return VenueCard(
                    venue: venue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleVenueScreen(venue: venue),
                        ),
                      );
                    },
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
