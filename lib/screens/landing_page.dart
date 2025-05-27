import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
//import 'admin/admin_dashboard_screen.dart';
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
import '../services/api_service.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  // Remove all dummy data lists
  // Add state variables for backend data
  List<Venue> _venues = [];
  List<Event> _events = [];
  List<Special> _specials = [];
  bool _isLoading = true;
  String? _error;

  late ApiService _apiService;

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

  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    // _fetchAllData(); // Call this in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authService = Provider.of<AuthService>(context);
    _apiService = ApiService(authService);
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      print('Fetching all data...');

      // Fetch venues
      print('Fetching venues...');
      final venues = await _apiService.getVenues();

      // Fetch events
      print('Fetching events...');
      final events = await _apiService.getEvents();

      // Fetch specials
      print('Fetching specials...');
      final specials = await _apiService.getSpecials();

      print('Venues fetched: ${venues.length}');
      print('Events fetched: ${events.length}');
      print('Specials fetched: ${specials.length}');

      setState(() {
        _venues = venues;
        _events = events;
        _specials = specials;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

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
        return _events;
      case 1:
        return _venues;
      case 2:
        return _specials;
      default:
        return _events;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final isLoggedIn = authService.isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: $_error',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchAllData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Fixed header content
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Current Location',
                                        style: TextStyle(
                                            color: AppColors.white70,
                                            fontSize: 12),
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
                                        icon: const Icon(
                                            Icons.notifications_none,
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
                                                builder: (context) =>
                                                    const ProfileScreen(),
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
                                        events: _events,
                                        venues: _venues,
                                        specials: _specials,
                                      ),
                                    ),
                                  );
                                },
                                child: AbsorbPointer(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText:
                                          'Search for events, venues, or specials...',
                                      hintStyle: const TextStyle(
                                          color: AppColors.white70),
                                      prefixIcon: const Icon(Icons.search,
                                          color: AppColors.white70),
                                      filled: true,
                                      fillColor: AppColors.darkGrey,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.filter_list,
                                            color: AppColors.white70),
                                        onPressed: () {},
                                      ),
                                    ),
                                    style:
                                        const TextStyle(color: AppColors.white),
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
                                          isLoggedIn
                                              ? Icons.edit
                                              : Icons.emoji_events,
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
                                          color: AppColors.white70,
                                          fontSize: 15),
                                    ),
                                    if (isLoggedIn)
                                      Column(
                                        children: [
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              _buildFeatureIcon(
                                                  Icons.location_on,
                                                  'Find Perfect Venues',
                                                  () {}),
                                              _buildFeatureIcon(
                                                  Icons.calendar_today,
                                                  'Easy Planning',
                                                  () {}),
                                              _buildFeatureIcon(Icons.bar_chart,
                                                  'Get Insights', () {}),
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
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                  fontSize: 16,
                                                  color: AppColors.white),
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
                                      onTap: () => setState(
                                          () => _selectedCategoryIndex = index),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _categories[
                                                        _selectedCategoryIndex]
                                                    .title,
                                                style: const TextStyle(
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _categories[
                                                        _selectedCategoryIndex]
                                                    .description,
                                                style: const TextStyle(
                                                  color: AppColors.white70,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          _categories[_selectedCategoryIndex]
                                              .icon,
                                          color: AppColors.white,
                                          size: 40,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // The list area: always visible, fixed height
                            SizedBox(
                              height: constraints.maxHeight *
                                  0.45, // 45% of screen height
                              child: _selectedCategoryIndex == 0
                                  ? EventList(events: _events)
                                  : _selectedCategoryIndex == 1
                                      ? VenueList(venues: _venues)
                                      : SpecialList(specials: _specials),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    },
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
