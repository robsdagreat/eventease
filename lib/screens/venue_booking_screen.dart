import 'package:flutter/material.dart';
import '../models/venue.dart'; // Assuming Venue model is needed
import '../theme/app_colors.dart'; // Assuming AppColors is used
import 'package:provider/provider.dart';
import '../services/auth_service.dart'; // Import AuthService
import 'auth_screen.dart'; // Import AuthScreen
import '../services/booking_service.dart'; // Import BookingService
import '../models/booking.dart'; // Import Booking model
import 'landing_page.dart'; // Import LandingPage for navigation

class VenueBookingScreen extends StatefulWidget {
  final Venue venue;

  const VenueBookingScreen({Key? key, required this.venue}) : super(key: key);

  @override
  State<VenueBookingScreen> createState() => _VenueBookingScreenState();
}

class _VenueBookingScreenState extends State<VenueBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _guestsController = TextEditingController();

  // Add controllers and state for booking form here

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _guestsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  void _bookVenue() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        // _isLoading = true; // Add loading state if needed
      });
      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        final bookingService =
            Provider.of<BookingService>(context, listen: false);

        final userId = authService.currentUser?.id;
        if (userId == null) {
          // Should not happen if button is only shown to logged in users, but good practice
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not logged in.')),
          );
          return;
        }

        final bookingDate = _selectedDate!;
        final bookingTime = _selectedTime!.format(context);
        final numberOfGuests = int.parse(_guestsController.text);

        final booking = Booking(
          id: '', // Firebase will generate the ID
          venueId: widget.venue.id,
          userId: userId,
          date: bookingDate,
          time: bookingTime,
          numberOfGuests: numberOfGuests,
          createdAt: DateTime.now(),
        );

        await bookingService.createBooking(booking);

        // Show success message and navigate to landing page
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking request submitted!')),
          );
          await Future.delayed(
              const Duration(milliseconds: 500)); // Let user see the toast
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LandingPage()),
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to submit booking: \\${e.toString()}')),
          );
        }
      } finally {
        setState(() {
          // _isLoading = false; // Reset loading state
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final isLoggedIn = authService.isAuthenticated;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text('Book ${widget.venue.name}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoggedIn
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // TODO: Add booking form fields (Date, Time, Guests, etc.)
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      style: const TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        labelText: 'Date',
                        hintText: 'Select Date',
                        hintStyle: const TextStyle(color: AppColors.white70),
                        labelStyle: const TextStyle(color: AppColors.white70),
                        prefixIcon: const Icon(Icons.calendar_today,
                            color: AppColors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.darkGrey,
                      ),
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _timeController,
                      readOnly: true,
                      style: const TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        labelText: 'Time',
                        hintText: 'Select Time',
                        hintStyle: const TextStyle(color: AppColors.white70),
                        labelStyle: const TextStyle(color: AppColors.white70),
                        prefixIcon: const Icon(Icons.access_time,
                            color: AppColors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.darkGrey,
                      ),
                      onTap: () => _selectTime(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a time';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _guestsController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        labelText: 'Number of Guests',
                        hintText: 'Enter number of guests',
                        hintStyle: const TextStyle(color: AppColors.white70),
                        labelStyle: const TextStyle(color: AppColors.white70),
                        prefixIcon:
                            const Icon(Icons.people, color: AppColors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.darkGrey,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter number of guests';
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return 'Please enter a valid number of guests';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Display contact info - Placeholder
                    Text(
                      'Phone: ${widget.venue.contactPhone ?? 'N/A'}',
                      style: TextStyle(color: AppColors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email: ${widget.venue.contactEmail ?? 'N/A'}',
                      style: TextStyle(color: AppColors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Website: ${widget.venue.website ?? 'N/A'}',
                      style: TextStyle(color: AppColors.white70, fontSize: 16),
                    ),

                    const SizedBox(height: 24),

                    // TODO: Add Booking Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _bookVenue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkerPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Submit Booking Request',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              // Show message and login button if not logged in
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please log in to book this venue.',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AuthScreen()),
                      ); // Navigate to login screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkerPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
    );
  }
}
