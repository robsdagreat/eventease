import 'package:flutter/material.dart';
import '../models/event_type.dart';
import '../models/venue.dart';
import '../widgets/cards/venue_card.dart';
import 'event_registration_screen.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import 'auth_screen.dart';
import '../theme/app_colors.dart';
import '../services/api_service.dart';

class EventVenueFinderScreen extends StatefulWidget {
  const EventVenueFinderScreen({Key? key}) : super(key: key);

  @override
  State<EventVenueFinderScreen> createState() => _EventVenueFinderScreenState();
}

class _EventVenueFinderScreenState extends State<EventVenueFinderScreen> {
  final TextEditingController _capacityController = TextEditingController();
  List<Venue> _suggestedVenues = [];
  bool _isLoading = false;
  String? _errorMessage;
  late AuthService _authService;
  late ApiService _apiService;

  List<EventType> _eventTypes = [];
  EventType? _selectedEventType;

  @override
  void initState() {
    super.initState();
    _eventTypes = EventType.types;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authService = Provider.of<AuthService>(context, listen: false);
    _apiService = ApiService(_authService);
    _fetchSuggestedVenues();
  }

  @override
  void dispose() {
    _capacityController.dispose();
    super.dispose();
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'wedding':
        return Icons.favorite;
      case 'corporate event':
        return Icons.business;
      case 'birthday party':
        return Icons.cake;
      case 'concert':
        return Icons.music_note;
      case 'exhibition':
        return Icons.museum;
      case 'social gathering':
        return Icons.group;
      default:
        return Icons.event;
    }
  }

  Future<void> _fetchSuggestedVenues() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final capacity = int.tryParse(_capacityController.text) ?? 0;
      final eventType = _selectedEventType?.name;
      final venues = await _apiService.getVenues();
      // Filter client-side as before
      final filteredVenues = venues.where((venue) {
        final capacityMatch = capacity <= 0 || venue.capacity >= capacity;
        final typeMatch = eventType == null ||
            venue.venueType.toLowerCase() == eventType.toLowerCase() ||
            venue.venueType == 'Multi-purpose';
        return capacityMatch && typeMatch;
      }).toList();
      setState(() {
        _suggestedVenues = filteredVenues;
        if (_suggestedVenues.isEmpty) {
          _errorMessage =
              'No venues found for your criteria. Try adjusting filters or capacity.';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _suggestedVenues = [];
        _errorMessage = 'Error fetching venues. Please try again.';
        _isLoading = false;
      });
      debugPrint('Error fetching venues: $e');
    }
  }

  void _onVenueSelected(Venue venue) {
    if (_authService.currentUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
      return;
    }

    final eventTypeForRegistration = _selectedEventType ??
        EventType(
            id: 'general',
            name: 'General',
            description: 'General Event',
            imageUrl: '');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventRegistrationScreen(
          eventType: eventTypeForRegistration,
          venue: venue,
          expectedCapacity: int.tryParse(_capacityController.text) ?? 0,
        ),
      ),
    ).then((createdEvent) {
      if (createdEvent != null) {
        // Pop back to the landing page and refresh
        Navigator.pop(context, createdEvent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final isLoggedIn = authService.currentUser != null;

    if (!isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _authService.currentUser == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AuthScreen()),
          );
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('Find a Venue'),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Expected Number of Guests',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _capacityController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter number of guests (optional)',
                    hintStyle: const TextStyle(color: AppColors.white70),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: AppColors.white70),
                      onPressed: _fetchSuggestedVenues,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.darkGrey,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (_) => _fetchSuggestedVenues(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Filter by Event Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    FilterChip(
                      label: const Text('All Types'),
                      selected: _selectedEventType == null,
                      onSelected: (selected) {
                        setState(() {
                          _selectedEventType = null;
                        });
                        _fetchSuggestedVenues();
                      },
                      avatar: const Icon(Icons.apps, color: AppColors.white70),
                      selectedColor: AppColors.pink,
                      checkmarkColor: AppColors.white,
                      backgroundColor: AppColors.darkerPurple,
                      labelStyle: TextStyle(
                        color: _selectedEventType == null
                            ? AppColors.white
                            : AppColors.white70,
                        fontWeight: _selectedEventType == null
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    ..._eventTypes.map((type) {
                      final isSelected = _selectedEventType?.id == type.id;
                      return FilterChip(
                        label: Text(type.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedEventType = selected ? type : null;
                          });
                          _fetchSuggestedVenues();
                        },
                        avatar: Icon(_getIconData(type.name),
                            color: isSelected
                                ? AppColors.white
                                : AppColors.white70),
                        selectedColor: AppColors.pink,
                        checkmarkColor: AppColors.white,
                        backgroundColor: AppColors.darkerPurple,
                        labelStyle: TextStyle(
                          color:
                              isSelected ? AppColors.white : AppColors.white70,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ],
                ),
                const SizedBox(height: 8),
                if (_selectedEventType != null)
                  Text(
                    'Recommended capacity for ${_selectedEventType!.name}: 1 - 10000 people',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.white70,
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 32, color: AppColors.darkGrey),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: AppColors.pink),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.pink)))
                : _suggestedVenues.isEmpty
                    ? const Center(
                        child: Text(
                          'No venues match your criteria.',
                          style:
                              TextStyle(fontSize: 16, color: AppColors.white70),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 16),
                        itemCount: _suggestedVenues.length,
                        itemBuilder: (context, index) {
                          final venue = _suggestedVenues[index];
                          return VenueCard(
                            venue: venue,
                            onTap: () => _onVenueSelected(venue),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
