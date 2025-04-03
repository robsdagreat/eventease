import 'package:flutter/material.dart';
import '../models/event.dart';
import '../models/venue.dart';
import '../models/special.dart';
import '../widgets/cards/event_card.dart';
import '../widgets/cards/venue_card.dart';
import '../widgets/cards/special_card.dart';

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

  void _filterResults() {
    // Filter events
    if (_selectedFilter == 'All' || _selectedFilter == 'Events') {
      _filteredEvents = widget.events
          .where((event) =>
              event.name.toLowerCase().contains(_searchQuery) ||
              event.location.toLowerCase().contains(_searchQuery) ||
              event.date.toLowerCase().contains(_searchQuery))
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
              special.name.toLowerCase().contains(_searchQuery) ||
              special.location.toLowerCase().contains(_searchQuery) ||
              special.discount.toLowerCase().contains(_searchQuery))
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
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search for events, venues, or specials...',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            ),
          PopupMenuButton<String>(
            icon: Row(
              children: [
                const Icon(Icons.filter_list),
                const SizedBox(width: 4),
                Text(_selectedFilter, style: const TextStyle(fontSize: 14)),
              ],
            ),
            onSelected: (String value) {
              setState(() {
                _selectedFilter = value;
                _filterResults();
              });
            },
            itemBuilder: (BuildContext context) {
              return _filterOptions.map((String option) {
                return PopupMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: !hasResults && _searchQuery.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 80,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No results found for "$_searchQuery"',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : _searchQuery.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 80,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Search for events, venues, or specials',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 16,
                        ),
                      ),
                    ],
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
                          'Special Offers',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ..._filteredSpecials
                          .map((special) => SpecialCard(special: special)),
                    ],
                  ],
                ),
    );
  }
}
