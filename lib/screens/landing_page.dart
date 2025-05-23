import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'admin/admin_dashboard_screen.dart';
import 'auth_screen.dart';
import 'upcoming_events_screen.dart';
import 'venues_screen.dart';
import 'profile_screen.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/promotional_section.dart';
import '../models/event.dart';
import '../models/venue.dart';
import '../models/special.dart';
import '../models/category_data.dart';
import 'search_page.dart';
import '../widgets/app_drawer.dart';
import '../widgets/lists/event_list.dart';
import '../widgets/lists/venue_list.dart';
import '../widgets/lists/special_list.dart';
import '../theme/app_colors.dart';
import 'event_venue_finder_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  // Sample data for demonstration
  final List<Venue> _suggestedVenues = [
    Venue(
      id: '1',
      name: 'The Elements',
      description: 'A luxurious venue...',
      location: 'South Jakarta',
      address: '123 Main St',
      city: 'Jakarta',
      state: 'Jakarta',
      country: 'Indonesia',
      postalCode: '12345',
      venueType: 'Wedding',
      capacity: 250,
      rating: 5.0,
      amenities: ['Parking', 'WiFi', 'Catering'],
      images: ['https://picsum.photos/id/237/400/300'],
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Venue(
      id: '2',
      name: 'Urban Loft',
      location: 'City Center',
      address: '123 Main St',
      city: 'Jakarta',
      state: 'Jakarta',
      country: 'Indonesia',
      postalCode: '12345',
      rating: 4.9,
      images: ['https://picsum.photos/id/238/400/300'],
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
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Venue(
      id: '3',
      name: 'Country Mansion',
      location: 'Countryside',
      address: '123 Main St',
      city: 'Jakarta',
      state: 'Jakarta',
      country: 'Indonesia',
      postalCode: '12345',
      rating: 4.7,
      images: ['https://picsum.photos/id/239/400/300'],
      capacity: 400,
      venueType: 'Multi-purpose',
      description:
          'Spacious mansion with both indoor and outdoor spaces, perfect for any type of event.',
      amenities: ['Garden', 'Pool', 'Kitchen', 'Parking', 'Security'],
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Venue(
      id: '4',
      name: 'Arena Stadium',
      location: 'Entertainment District',
      address: '123 Main St',
      city: 'Jakarta',
      state: 'Jakarta',
      country: 'Indonesia',
      postalCode: '12345',
      rating: 4.9,
      images: ['https://picsum.photos/id/247/400/300'],
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
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Venue(
      id: '5',
      name: 'Convention Center',
      location: 'Downtown',
      address: '123 Main St',
      city: 'Jakarta',
      state: 'Jakarta',
      country: 'Indonesia',
      postalCode: '12345',
      rating: 4.8,
      images: ['https://picsum.photos/id/249/400/300'],
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
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Venue(
      id: '6',
      name: 'Fun Zone',
      location: 'Entertainment Center',
      address: '123 Main St',
      city: 'Jakarta',
      state: 'Jakarta',
      country: 'Indonesia',
      postalCode: '12345',
      rating: 4.6,
      images: ['https://picsum.photos/id/251/400/300'],
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
      isAvailable: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  final List<Event> _upcomingEvents = [
    Event(
      id: '1',
      name: 'Summer Festival',
      description: 'A fun-filled summer festival...',
      startTime: DateTime(2025, 6, 15),
      endTime: DateTime(2025, 6, 16),
      eventType: 'Festival',
      venueId: '1',
      venueName: 'The Elements',
      userId: '1234',
      organizerName: 'Event Organizers Inc',
      isPublic: true,
      expectedAttendees: 1000,
      status: 'published',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      imageUrl: 'https://picsum.photos/id/1000/400/300',
    ),
    Event(
      id: '2',
      name: 'Tech Conference',
      description: 'Annual technology conference featuring industry leaders',
      startTime: DateTime(2025, 5, 22),
      endTime: DateTime(2025, 5, 23),
      eventType: 'Conference',
      venueId: '2',
      venueName: 'Urban Loft',
      userId: '1',
      organizerName: 'Tech Events Co',
      isPublic: true,
      expectedAttendees: 500,
      status: 'published',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      imageUrl: 'https://picsum.photos/id/1001/400/300',
    ),
    Event(
      id: '3',
      name: 'Food & Wine Expo',
      description: 'Experience the finest food and wine from around the world',
      startTime: DateTime(2025, 7, 3),
      endTime: DateTime(2025, 7, 4),
      eventType: 'Expo',
      venueId: '3',
      venueName: 'Country Mansion',
      userId: '1',
      organizerName: 'Gourmet Events',
      isPublic: true,
      expectedAttendees: 300,
      status: 'published',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      imageUrl: 'https://picsum.photos/id/1002/400/300',
    ),
  ];

  final List<Special> _specialOffers = [
    Special(
      id: '1',
      title: 'Beach Resort Weekend',
      description: 'Enjoy a luxurious weekend at our beach resort',
      venueId: '1',
      venueName: 'The Elements',
      startDate: DateTime(2025, 6, 1),
      endDate: DateTime(2025, 6, 30),
      type: 'weekend',
      discountPercentage: 30.0,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      imageUrl: 'https://picsum.photos/id/1010/400/300',
    ),
    Special(
      id: '2',
      title: 'Spa Retreat Package',
      description: 'Relax and rejuvenate with our special spa package',
      venueId: '2',
      venueName: 'Urban Loft',
      startDate: DateTime(2025, 5, 1),
      endDate: DateTime(2025, 5, 31),
      type: 'spa',
      discountPercentage: 25.0,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      imageUrl: 'https://picsum.photos/id/1011/400/300',
    ),
    Special(
      id: '3',
      title: 'City Tour Bundle',
      description: 'Explore the city with our comprehensive tour package',
      venueId: '3',
      venueName: 'Country Mansion',
      startDate: DateTime(2025, 7, 1),
      endDate: DateTime(2025, 7, 31),
      type: 'tour',
      discountPercentage: 40.0,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      imageUrl: 'https://picsum.photos/id/1012/400/300',
    ),
  ];

  final List<CategoryData> _categories = [
    CategoryData(
      title: 'Events',
      description:
          'Get ready for the event of your life, the get you out of shell right away',
      icon: Icons.event_available,
    ),
    CategoryData(
      title: 'Venues',
      description:
          "We've got you just the right venue for your next big event, only a few clicks away",
      icon: Icons.location_city,
    ),
    CategoryData(
      title: 'Specials',
      description:
          'Kick the boredom right out of the existence with our weekend specials from your favourite places',
      icon: Icons.star,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _selectedCategoryIndex = 0;

  void _navigateToAuth(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AuthScreen(),
      ),
    );
  }

  // Method to get filtered items based on selected category
  List<dynamic> _getFilteredItems() {
    switch (_selectedCategoryIndex) {
      case 0:
        return _upcomingEvents;
      case 1:
        return _suggestedVenues;
      case 2:
        return _specialOffers;
      default:
        return _upcomingEvents;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final isLoggedIn = authService.isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed header content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Location',
                        style:
                            TextStyle(color: AppColors.white70, fontSize: 12),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: AppColors.white, size: 18),
                          SizedBox(width: 4),
                          Text(
                            'Kigali, Rwanda',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none,
                            color: AppColors.white),
                        onPressed: () {},
                      ),
          IconButton(
                        icon: const Icon(Icons.account_circle,
                            color: AppColors.white),
            onPressed: () {
                          if (isLoggedIn) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          } else {
                            _navigateToAuth(context);
                          }
            },
          ),
        ],
      ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: GestureDetector(
                onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchPage(
                        events: _upcomingEvents,
                        venues: _suggestedVenues,
                        specials: _specialOffers,
                      ),
                    ),
                  );
                },
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for events, venues, or specials...',
                      hintStyle: const TextStyle(color: AppColors.white70),
                      prefixIcon:
                          const Icon(Icons.search, color: AppColors.white70),
                      filled: true,
                      fillColor: AppColors.darkGrey,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.filter_list,
                            color: AppColors.white70),
                        onPressed: () {
                          // TODO: Implement filter logic or navigate to filter screen
                        },
                      ),
                    ),
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
              ),
            ),

            // Promotional section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.darkerPurple,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isLoggedIn ? Icons.edit : Icons.emoji_events,
                          color: AppColors.white,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isLoggedIn
                                ? 'Ready to Create Your Dream Event?'
                                : 'Got an event you planning to host in near future?',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isLoggedIn
                          ? 'Transform your vision into reality! Browse our curated venues, get expert insights, and start planning your perfect event.'
                          : 'Join EventEase today and unlock a world of possibilities for your next event. Sign up now to start planning!',
                      style: const TextStyle(
                          color: AppColors.white70, fontSize: 15),
                    ),
                    if (isLoggedIn)
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildFeatureIcon(
                                  Icons.location_on, 'Find Perfect Venues', () {
                                // TODO: Implement navigation
                              }),
                              _buildFeatureIcon(
                                  Icons.calendar_today, 'Easy Planning', () {
                                // TODO: Implement navigation
                              }),
                              _buildFeatureIcon(Icons.bar_chart, 'Get Insights',
                                  () {
                                // TODO: Implement navigation
                              }),
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          if (isLoggedIn) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const EventVenueFinderScreen(),
                              ),
                            );
                          } else {
                            _navigateToAuth(context);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isLoggedIn
                                  ? Icons.add_circle_outline
                                  : Icons.login,
                              color: AppColors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isLoggedIn
                                  ? 'Host Your Own Event'
                                  : 'Login to Host Event',
                              style: const TextStyle(
                                  fontSize: 16, color: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Navigation chips
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return _NavChip(
                      label: _categories[index].title,
                      selected: _selectedCategoryIndex == index,
                      onTap: () =>
                          setState(() => _selectedCategoryIndex = index),
                    );
                  },
                ),
              ),
            ),

            // Category header section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.darkerPurple,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _categories[_selectedCategoryIndex].title,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _categories[_selectedCategoryIndex].description,
                                style: const TextStyle(
                                  color: AppColors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _categories[_selectedCategoryIndex].icon,
                          color: AppColors.white,
                          size: 40,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable content list wrapped with Expanded
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: _selectedCategoryIndex == 0
                    ? EventList(events: _getFilteredItems().cast<Event>())
                    : _selectedCategoryIndex == 1
                        ? VenueList(venues: _getFilteredItems().cast<Venue>())
                        : SpecialList(
                            specials: _getFilteredItems().cast<Special>()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: AppColors.white, size: 30),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(color: AppColors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NavChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF2C0B3F)
                : Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? Colors.purpleAccent
                  : Colors.purple.withOpacity(0.3),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.white : Colors.purple,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverCategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverCategoryHeaderDelegate({
    required this.child,
  });

  @override
  double get minExtent => 56.0;

  @override
  double get maxExtent => 56.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SliverCategoryHeaderDelegate oldDelegate) {
    return false;
  }
}
