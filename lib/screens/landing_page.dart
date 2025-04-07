import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/venue.dart';
import '../models/special.dart';
import '../models/category_data.dart';
import 'search_page.dart';
import 'auth_screen.dart';
import 'profile_screen.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/promotional_section.dart';
import '../widgets/lists/event_list.dart';
import '../widgets/lists/venue_list.dart';
import '../widgets/lists/special_list.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

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
  ];

  final List<Event> _upcomingEvents = [
    Event(
      id: '1',
      name: 'Summer Festival',
      date: 'June 15, 2025',
      location: 'Central Park',
      imageUrl: 'https://picsum.photos/id/1000/400/300',
      price: 75,
    ),
    Event(
      id: '2',
      name: 'Tech Conference',
      date: 'May 22, 2025',
      location: 'Convention Center',
      imageUrl: 'https://picsum.photos/id/1001/400/300',
      price: 120,
    ),
    Event(
      id: '3',
      name: 'Food & Wine Expo',
      date: 'July 3, 2025',
      location: 'Riverside Gardens',
      imageUrl: 'https://picsum.photos/id/1002/400/300',
      price: 60,
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
      body: _buildMainContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildMainContent() {
    if (_selectedIndex == 1) {
      return const ProfileScreen();
    }
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: CustomAppBar(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          SliverToBoxAdapter(
            child: buildFullWidthSearchBar(context),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
          ),
          SliverToBoxAdapter(
            child: PromotionalSection(
                onGetStarted: () => _navigateToAuth(context)),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 12),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverCategoryHeaderDelegate(
              child: Container(
                height: 56,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: buildCategoryList(),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          SliverToBoxAdapter(
            child: buildCategoryTabsSection(context),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                EventList(events: _upcomingEvents),
                VenueList(venues: _suggestedVenues),
                SpecialList(specials: _specialOffers),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFullWidthSearchBar(BuildContext context) {
    return GestureDetector(
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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Search for events, venues, or specials...',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.tune,
                size: 18,
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryTabsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.withOpacity(0.3),
            Colors.deepPurple.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.purple.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _categories[_selectedCategoryIndex].description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _categories[_selectedCategoryIndex].icon,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              children: List.generate(_categories.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _selectedCategoryIndex == index
                      ? MediaQuery.of(context).size.width * 0.5 - 32
                      : (MediaQuery.of(context).size.width * 0.5) /
                          (_categories.length * 2),
                  decoration: BoxDecoration(
                    color: _selectedCategoryIndex == index
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryList() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(
        _categories.length,
        (index) => buildCategoryPill(_categories[index].title, index),
      ),
    );
  }

  Widget buildCategoryPill(String category, int index) {
    bool isSelected = _selectedCategoryIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
          _tabController.animateTo(index);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.purpleAccent.withOpacity(0.2)
              : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(30),
          border: isSelected
              ? Border.all(color: Colors.purpleAccent, width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _categories[index].icon,
              size: 18,
              color: isSelected ? Colors.purpleAccent : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
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
            color: Colors.black.withOpacity(0.1),
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
