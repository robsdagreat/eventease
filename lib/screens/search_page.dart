import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/venue.dart';
import '../models/special.dart';
import '../widgets/cards/event_card.dart';
import '../widgets/cards/venue_card.dart';
import '../widgets/cards/special_card.dart';
import '../theme/app_colors.dart';

class SearchPage extends StatefulWidget {
  final List<Event> events;
  final List<Venue> venues;
  final List<Special> specials;

  const SearchPage({
    Key? key,
    required this.events,
    required this.venues,
    required this.specials,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Lists to hold filtered results
  List<Event> _filteredEvents = [];
  List<Venue> _filteredVenues = [];
  List<Special> _filteredSpecials = [];

  // Filter type selection
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Events', 'Venues', 'Specials'];

  @override
  void initState() {
    super.initState();
    // Initialize with all items
    _filteredEvents = widget.events;
    _filteredVenues = widget.venues;
    _filteredSpecials = widget.specials;

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filterResults();
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _filterResults() {
    // Filter events
    if (_selectedFilter == 'All' || _selectedFilter == 'Events') {
      _filteredEvents = widget.events
          .where((event) =>
              event.name.toLowerCase().contains(_searchQuery) ||
              event.description.toLowerCase().contains(_searchQuery) ||
              event.eventType.toLowerCase().contains(_searchQuery) ||
              _formatDate(event.startTime).toLowerCase().contains(_searchQuery))
          .toList();
    } else {
      _filteredEvents = [];
    }

    // Filter venues
    if (_selectedFilter == 'All' || _selectedFilter == 'Venues') {
      _filteredVenues = widget.venues
          .where((venue) =>
              venue.name.toLowerCase().contains(_searchQuery) ||
              venue.location.toLowerCase().contains(_searchQuery))
          .toList();
    } else {
      _filteredVenues = [];
    }

    // Filter specials
    if (_selectedFilter == 'All' || _selectedFilter == 'Specials') {
      _filteredSpecials = widget.specials
          .where((special) =>
              special.title.toLowerCase().contains(_searchQuery) ||
              special.venueName.toLowerCase().contains(_searchQuery) ||
              '${special.discountPercentage}%'
                  .toLowerCase()
                  .contains(_searchQuery))
          .toList();
    } else {
      _filteredSpecials = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasResults = _filteredEvents.isNotEmpty ||
        _filteredVenues.isNotEmpty ||
        _filteredSpecials.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Search events, venues, or specials...',
                hintStyle: const TextStyle(color: AppColors.white70),
                prefixIcon: const Icon(Icons.search, color: AppColors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.darkGrey,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
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
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedFilter = option;
                          _filterResults();
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
                            option,
                            style: TextStyle(
                              color:
                                  isSelected ? AppColors.white : Colors.purple,
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
              }).toList(),
            ),
          ),

          // Results
          Expanded(
            child: !hasResults
                ? const Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.white70,
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      // Events section
                      if (_filteredEvents.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Events',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        ..._filteredEvents
                            .map((event) => EventCard(event: event)),
                      ],

                      // Venues section
                      if (_filteredVenues.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Venues',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        ..._filteredVenues
                            .map((venue) => VenueCard(venue: venue)),
                      ],

                      // Specials section
                      if (_filteredSpecials.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Specials',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        ..._filteredSpecials
                            .map((special) => SpecialCard(special: special)),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
