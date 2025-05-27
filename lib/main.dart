import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/auth_screen.dart';
import 'screens/landing_page.dart';
//import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/upcoming_events_screen.dart';
import 'screens/venues_screen.dart';
import 'screens/specials_screen.dart';
import 'services/auth_service.dart';
import 'firebase_options.dart';
import 'widgets/cards/event_card.dart';
import 'models/event.dart';
import 'widgets/cards/special_card.dart';
import 'models/special.dart';
import 'services/booking_service.dart';
import 'services/api_service.dart';
import 'services/event_service.dart';
import 'services/venue_service.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => BookingService()),
        Provider<ApiService>(create: (context) {
          final authService = Provider.of<AuthService>(context, listen: false);
          return ApiService(authService);
        }),
        Provider<EventService>(create: (context) {
          final apiService = Provider.of<ApiService>(context, listen: false);
          return EventService(apiService);
        }),
        Provider<VenueService>(create: (context) {
          final apiService = Provider.of<ApiService>(context, listen: false);
          return VenueService(apiService);
        }),
      ],
      child: MaterialApp(
        title: 'EventEase',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MainNavigation(),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final isLoggedIn = authService.isAuthenticated;

    // If user is not logged in, show AuthScreen
    if (!isLoggedIn) {
      return const AuthScreen();
    }

    final List<Widget> screens = [
      const LandingPage(),
      const UpcomingEventsScreen(),
      const VenuesScreen(),
      const SpecialsScreen(),
      isLoggedIn ? const ProfileScreen() : const AuthScreen(),
    ];

    // Adjust selected index if it points to the profile screen when not logged in
    if (!isLoggedIn && _selectedIndex == 4) {
      _selectedIndex = 0; // Or another default screen index
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            // Prevent navigating to Profile tab if not logged in
            if (index == 4 && !isLoggedIn) {
              // Optionally show a message or just do nothing, as the AuthScreen is already there
            } else {
              _selectedIndex = index;
            }
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A1A1A), // Dark grey background
        selectedItemColor: Colors.white, // White selected icon/text
        unselectedItemColor:
            Colors.white70, // Slightly transparent white for unselected
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            label: 'Venues',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Specials',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool isLoggedIn;
  const HomeScreen({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy event data
    final List<Event> events = [
      Event(
        id: '1',
        name: 'Summer Festival',
        description: 'A fun-filled summer festival...',
        imageUrl: 'https://picsum.photos/id/1000/400/300',
        startTime: DateTime(2025, 6, 15),
        endTime: DateTime(2025, 6, 16),
        eventType: 'Festival',
        venueId: '1',
        venueName: 'The Elements',
        firebase_user_id: '1234',
        organizerName: 'Event Organizers Inc',
        isPublic: true,
        expectedAttendees: 1000,
        status: 'published',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Event(
        id: '2',
        name: 'Tech Conference',
        description: 'Annual technology conference featuring industry leaders',
        imageUrl: 'https://picsum.photos/id/1001/400/300',
        startTime: DateTime(2025, 5, 22),
        endTime: DateTime(2025, 5, 23),
        eventType: 'Conference',
        venueId: '2',
        venueName: 'Urban Loft',
        firebase_user_id: '1',
        organizerName: 'Tech Events Co',
        isPublic: true,
        expectedAttendees: 500,
        status: 'published',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          children: [
            // Location and icons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Current Location',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Colors.white, size: 18),
                          SizedBox(width: 4),
                          Text(
                            'Kigali, Rwanda',
                            style: TextStyle(
                              color: Colors.white,
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
                            color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.account_circle,
                            color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for events, venues, or specials...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            // Call to action card
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF4B1868),
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
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isLoggedIn
                                ? 'Ready to Create Your Dream Event?'
                                : 'Got an event you planning to host in near future?',
                            style: const TextStyle(
                              color: Colors.white,
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
                          : 'Join RventEase today and unlock a world of possibilities for your next event. Sign up now to start planning!',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 15),
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
                          // TODO: Implement navigation to host event or login
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isLoggedIn
                                  ? Icons.add_circle_outline
                                  : Icons.login,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isLoggedIn
                                  ? 'Host Your Own Event'
                                  : 'Login to  Host Event',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
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
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  _NavChip(label: 'Events', selected: true),
                  SizedBox(width: 8),
                  _NavChip(label: 'Venues', selected: false),
                  SizedBox(width: 8),
                  _NavChip(label: 'Specials', selected: false),
                ],
              ),
            ),
            // Filter indicator section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF4B1868), // Darker purple background
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                padding: const EdgeInsets.all(16),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Events', // Dynamically change this based on selected filter
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Get ready for event of your life, the kind of event that get you out of your shell right away', // Dynamically change this description
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.calendar_today,
                        color: Colors.white,
                        size: 40), // Placeholder icon, replace as needed
                  ],
                ),
              ),
            ),
            // Event cards
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                children:
                    events.map((event) => EventCard(event: event)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _NavChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.purple : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.white70,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
