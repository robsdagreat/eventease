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
import 'package:event_ease/models/user.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  // Sample data for demonstration
  final List<Venue> _suggestedVenues = [
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

  final List<Event> _upcomingEvents = [
    Event(
      id: '1',
      name: 'Summer Festival',
      description:
          'A fun-filled summer festival with music, food, and activities',
      imageUrl: 'https://picsum.photos/id/1000/400/300',
      date: DateTime(2025, 6, 15),
      capacity: 1000,
      eventType: 'Festival',
      venueId: '1',
      userId: '1',
      isApproved: true,
    ),
    Event(
      id: '2',
      name: 'Tech Conference',
      description: 'Annual technology conference featuring industry leaders',
      imageUrl: 'https://picsum.photos/id/1001/400/300',
      date: DateTime(2025, 5, 22),
      capacity: 500,
      eventType: 'Conference',
      venueId: '2',
      userId: '1',
      isApproved: true,
    ),
    Event(
      id: '3',
      name: 'Food & Wine Expo',
      description: 'Experience the finest food and wine from around the world',
      imageUrl: 'https://picsum.photos/id/1002/400/300',
      date: DateTime(2025, 7, 3),
      capacity: 300,
      eventType: 'Expo',
      venueId: '3',
      userId: '1',
      isApproved: true,
    ),
  ];

  final List<Special> _specialOffers = [
    Special(
      id: '1',
      name: 'Beach Resort Weekend',
      discount: '30% Off',
      location: 'Coastal Bay',
      imageUrl: 'https://picsum.photos/id/1003/400/300',
      originalPrice: 300,
      discountedPrice: 210,
    ),
    Special(
      id: '2',
      name: 'Spa Retreat Package',
      discount: '25% Off',
      location: 'Mountain View',
      imageUrl: 'https://picsum.photos/id/1004/400/300',
      originalPrice: 250,
      discountedPrice: 187.5,
    ),
    Special(
      id: '3',
      name: 'City Tour Bundle',
      discount: '40% Off',
      location: 'Downtown',
      imageUrl: 'https://picsum.photos/id/1005/400/300',
      originalPrice: 120,
      discountedPrice: 72,
    ),
    Special(
      id: '4',
      name: 'Valentine\'s Day Dinner',
      discount: '20% Off',
      location: 'Luxury Hotel',
      imageUrl: 'https://picsum.photos/id/1006/400/300',
      originalPrice: 180,
      discountedPrice: 144,
    ),
    Special(
      id: '5',
      name: 'Couple\'s Retreat',
      discount: '35% Off',
      location: 'Seaside Resort',
      imageUrl: 'https://picsum.photos/id/1007/400/300',
      originalPrice: 350,
      discountedPrice: 227.5,
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
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedCategoryIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EventEase'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to EventEase!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminDashboardScreen(),
                  ),
                );
              },
              child: const Text('Go to Admin Dashboard'),
            ),
          ],
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
