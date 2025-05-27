import 'package:flutter/material.dart';
import '../models/venue.dart';
import 'single_venue_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/cards/venue_card.dart';
import '../services/venue_service.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

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

  List<Venue> _venues = [];
  bool _isLoading = true;
  String? _error;

  late ApiService _apiService;
  late VenueService _venueService;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authService = Provider.of<AuthService>(context);
    _apiService = ApiService(authService);
    _venueService = VenueService(_apiService);
    _fetchVenues();
  }

  Future<void> _fetchVenues() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final venues = await _venueService.getAllVenues();
      setState(() {
        _venues = venues;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: \\$_error',
                          style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchVenues,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : CustomScrollView(
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
                              'https://picsum.photos/id/1018/800/400',
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
                                    builder: (context) =>
                                        SingleVenueScreen(venue: venue),
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
