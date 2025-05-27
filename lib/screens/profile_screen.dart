import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/account_dialogs.dart';
import 'auth_screen.dart';
import '../theme/app_colors.dart';
import '../services/booking_service.dart';
import '../services/event_service.dart';
import '../models/venue.dart';
import '../models/event.dart';
import '../models/booking.dart';
import '../services/venue_service.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _notificationsEnabled = true;
  ThemeMode _themeMode = ThemeMode.system;
  late AuthService _authService;
  late BookingService _bookingService;
  late EventService _eventService;
  late VenueService _venueService;
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _authService = Provider.of<AuthService>(context, listen: false);
    _bookingService = Provider.of<BookingService>(context, listen: false);
    _apiService = ApiService(_authService);
    _eventService = EventService(_apiService);
    _venueService = VenueService(_apiService);
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      setState(() {
        _nameController.text = user.name;
        _emailController.text = user.email ?? '';
        _notificationsEnabled = user.notificationsEnabled;
        _themeMode = user.themeMode;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.updateProfile(
        name: _nameController.text,
        notificationsEnabled: _notificationsEnabled,
        themeMode: _themeMode,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => const ChangePasswordDialog(),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => const DeleteAccountDialog(),
    );
  }

  void _handleLogout() async {
    try {
      await _authService.signOut();
      if (!mounted) return;

      // Navigate to auth screen and clear the entire stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<Venue?> _getVenueById(String venueId) async {
    return await _venueService.getVenueById(venueId);
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = _authService.currentUser != null;
    if (!isLoggedIn) {
      print('User not logged in. Showing fallback message.');
      return Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.white),
        ),
        body: const Center(
          child: Text(
            'Please log in to view your profile and bookings.',
            style: TextStyle(color: AppColors.white70, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.white),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon:
                      const Icon(Icons.person, color: AppColors.white70),
                  labelStyle: const TextStyle(color: AppColors.white70),
                  hintStyle: const TextStyle(color: AppColors.white70),
                  contentPadding: const EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.pink,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.darkGrey,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(color: AppColors.white),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email, color: AppColors.white70),
                  labelStyle: const TextStyle(color: AppColors.white70),
                  hintStyle: const TextStyle(color: AppColors.white70),
                  contentPadding: const EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.pink,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Preferences',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Enable Notifications',
                    style: TextStyle(color: AppColors.white70)),
                subtitle: const Text(
                    'Receive notifications about events and updates',
                    style: TextStyle(color: AppColors.white70)),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                activeColor: AppColors.pink,
                tileColor: AppColors.darkGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Theme Mode',
                    style: TextStyle(color: AppColors.white70)),
                subtitle: const Text('Choose your preferred theme',
                    style: TextStyle(color: AppColors.white70)),
                leading: const Icon(Icons.color_lens, color: AppColors.white70),
                tileColor: AppColors.darkGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                trailing: DropdownButton<ThemeMode>(
                  value: _themeMode,
                  dropdownColor: AppColors.darkGrey,
                  style: const TextStyle(color: AppColors.white),
                  icon: const Icon(Icons.arrow_drop_down,
                      color: AppColors.white70),
                  onChanged: (ThemeMode? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _themeMode = newValue;
                      });
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Account Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.lock, color: AppColors.white70),
                title: const Text('Change Password',
                    style: TextStyle(color: AppColors.white70)),
                tileColor: AppColors.darkGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: _showChangePasswordDialog,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading:
                    const Icon(Icons.delete_forever, color: AppColors.pink),
                title: const Text('Delete Account',
                    style: TextStyle(color: AppColors.pink)),
                tileColor: AppColors.darkGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: _showDeleteAccountDialog,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pink,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.white),
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              // --- Booked Venues Section ---
              const SizedBox(height: 32),
              const Text(
                'My Booked Venues',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white),
              ),
              const SizedBox(height: 8),
              StreamBuilder<List<Booking>>(
                stream: _bookingService.getUserBookings(),
                builder: (context, snapshot) {
                  print(
                      'StreamBuilder: connectionState = \${snapshot.connectionState}, hasData = \${snapshot.hasData}, error = \${snapshot.error}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print('StreamBuilder error: \${snapshot.error}');
                    return const Text(
                        'Error loading bookings: \${snapshot.error}',
                        style: TextStyle(color: Colors.redAccent));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    print('No bookings found for user.');
                    return const Text('No bookings yet.',
                        style: TextStyle(color: AppColors.white70));
                  }
                  final bookings = snapshot.data!;
                  print('Fetched bookings: \${bookings.length}');
                  return Column(
                    children: bookings.map((booking) {
                      print(
                          'Booking: id=\${booking.id}, venueId=\${booking.venueId}, startTime=\${booking.startTime}, endTime=\${booking.endTime}, time=\${booking.time}');
                      return FutureBuilder<Venue?>(
                        future: _getVenueById(booking.venueId),
                        builder: (context, venueSnapshot) {
                          print(
                              'FutureBuilder for venueId=\${booking.venueId}: connectionState=\${venueSnapshot.connectionState}, hasData=\${venueSnapshot.hasData}, error=\${venueSnapshot.error}');
                          if (venueSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                                height: 48,
                                child:
                                    Center(child: CircularProgressIndicator()));
                          }
                          if (venueSnapshot.hasError) {
                            print('Venue fetch error: \${venueSnapshot.error}');
                            return Text(
                                'Error loading venue: \${venueSnapshot.error}',
                                style: TextStyle(color: Colors.redAccent));
                          }
                          if (!venueSnapshot.hasData ||
                              venueSnapshot.data == null) {
                            print(
                                'Venue not found for venueId=\${booking.venueId}');
                            return const ListTile(
                              title: Text('Venue not found',
                                  style: TextStyle(color: Colors.orangeAccent)),
                              subtitle: Text(
                                  'This booking references a missing venue.',
                                  style: TextStyle(color: AppColors.white70)),
                            );
                          }
                          final venue = venueSnapshot.data!;
                          return Card(
                            color: AppColors.darkGrey,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              title: Text(venue.name,
                                  style:
                                      const TextStyle(color: AppColors.white)),
                              subtitle: Text(
                                  '${booking.startTime.toLocal().toString().split(' ')[0]} - ${booking.time}',
                                  style: const TextStyle(
                                      color: AppColors.white70)),
                              trailing: Text('${venue.city}',
                                  style: const TextStyle(
                                      color: AppColors.white70)),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              // --- Created Events Section ---
              const SizedBox(height: 32),
              const Text(
                'My Created Events',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white),
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<Event>>(
                future: _eventService
                    .getEventsByUser(_authService.currentUser?.id ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No events created.',
                        style: TextStyle(color: AppColors.white70));
                  }
                  final events = snapshot.data!;
                  return Column(
                    children: events
                        .map((event) => Card(
                              color: AppColors.darkGrey,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(event.name,
                                    style: const TextStyle(
                                        color: AppColors.white)),
                                subtitle: Text(
                                    '${event.startTime.toLocal().toString().split(' ')[0]} - ${event.venueName}',
                                    style: const TextStyle(
                                        color: AppColors.white70)),
                                trailing: Text(event.status,
                                    style: const TextStyle(
                                        color: AppColors.white70)),
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
