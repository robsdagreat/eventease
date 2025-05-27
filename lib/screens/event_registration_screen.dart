import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/event_type.dart';
import '../models/venue.dart';
import '../models/event.dart';
import '../services/auth_service.dart';
import '../screens/auth_screen.dart';
import '../theme/app_colors.dart';
import '../services/api_service.dart';

class EventRegistrationScreen extends StatefulWidget {
  final EventType eventType;
  final Venue venue;
  final int expectedCapacity;

  const EventRegistrationScreen({
    Key? key,
    required this.eventType,
    required this.venue,
    required this.expectedCapacity,
  }) : super(key: key);

  @override
  State<EventRegistrationScreen> createState() =>
      _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _hostNameController = TextEditingController();
  final _hostContactController = TextEditingController();
  final _hostDescriptionController = TextEditingController();
  final _ticketPriceController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;
  String? _errorMessage;
  File? _imageFile;
  String? _uploadedImageUrl;
  String? _enteredImageUrl;
  final ImagePicker _imagePicker = ImagePicker();
  late AuthService _authService;
  String _hostType = 'personal';
  bool _isPublic = false;
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _authService = Provider.of<AuthService>(context, listen: false);
    _apiService = Provider.of<ApiService>(context, listen: false);

    // Check authentication state immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_authService.currentUser == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _hostNameController.dispose();
    _hostContactController.dispose();
    _hostDescriptionController.dispose();
    _ticketPriceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.pink,
              onPrimary: AppColors.white,
              surface: AppColors.darkGrey,
              onSurface: AppColors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.pink,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _uploadedImageUrl =
              null; // Clear the previous URL when new image is picked
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error picking image. Please try again.';
      });
      debugPrint('Error picking image: $e');
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) {
      print('No image file to upload.');
      return null;
    }

    try {
      print('Preparing to upload image...');
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('event_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      print('Starting upload task...');
      final uploadTask = storageRef.putFile(_imageFile!);

      // Listen for progress/errors
      uploadTask.snapshotEvents.listen((event) {
        print('Upload progress: ${event.bytesTransferred}/${event.totalBytes}');
      }, onError: (e) {
        print('Upload error: $e');
      });

      final snapshot = await uploadTask.whenComplete(() {});
      print('Upload complete, getting download URL...');
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('Download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image');
    }
  }

  Future<void> _registerEvent() async {
    print('Starting event registration');
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      setState(() {
        _errorMessage = 'Please fill in all required fields';
      });
      print('Validation failed: missing required fields');
      return;
    }

    // Validate that an image URL is provided
    if (_enteredImageUrl == null || _enteredImageUrl!.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an image URL for the event';
      });
      print('Validation failed: no image URL entered');
      return;
    }

    // Validate date is not in the past
    if (_selectedDate!.isBefore(DateTime.now())) {
      setState(() {
        _errorMessage = 'Event date cannot be in the past';
      });
      print('Validation failed: date in the past');
      return;
    }

    // Validate capacity is within event type limits
    if (widget.expectedCapacity < widget.eventType.minCapacity ||
        widget.expectedCapacity > widget.eventType.maxCapacity) {
      setState(() {
        _errorMessage =
            'Capacity must be between ${widget.eventType.minCapacity} and ${widget.eventType.maxCapacity} people';
      });
      print('Validation failed: capacity out of bounds');
      return;
    }

    // Validate professional host fields if needed
    if (_hostType == 'professional' && _isPublic) {
      if (_hostNameController.text.isEmpty ||
          _hostContactController.text.isEmpty ||
          _hostDescriptionController.text.isEmpty) {
        setState(() {
          _errorMessage = 'Please fill in all host information fields';
        });
        print('Validation failed: missing professional host info');
        return;
      }
    }

    // Validate ticket price
    final ticketPrice = double.tryParse(_ticketPriceController.text);
    if (ticketPrice == null || ticketPrice < 0) {
      setState(() {
        _errorMessage = 'Please enter a valid ticket price.';
      });
      print('Validation failed: invalid ticket price');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        setState(() {
          _errorMessage = 'Please sign in to register an event';
          _isLoading = false;
        });
        print('Validation failed: user not signed in');
        return;
      }

      final event = Event(
        id: '', // Will be set by the backend
        name: _nameController.text,
        description: _descriptionController.text,
        eventType: widget.eventType.name,
        venueId: widget.venue.id,
        venueName: widget.venue.name,
        startTime: _selectedDate!,
        endTime: _selectedDate!
            .add(const Duration(hours: 3)), // Default 3-hour duration
        status: 'upcoming',
        imageUrl: _enteredImageUrl,
        firebase_user_id: currentUser.id,
        organizerName: _hostType == 'professional'
            ? _hostNameController.text
            : 'Private Host',
        isPublic: _isPublic,
        expectedAttendees: widget.expectedCapacity,
        ticketPrice: ticketPrice,
        contactEmail:
            _hostType == 'professional' ? _hostContactController.text : null,
        contactPhone:
            _hostType == 'personal' ? _hostContactController.text : null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: [], // Optional tags
      );

      print('Creating event with data: ${event.toJson()}');
      final createdEvent = await _apiService
          .createEvent(event)
          .timeout(const Duration(seconds: 30));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event registered successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, createdEvent);
      }
    } catch (e) {
      print('Error creating event: $e');
      setState(() {
        _errorMessage = 'Failed to register event. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final isLoggedIn = authService.currentUser != null;

    if (!isLoggedIn) {
      return const AuthScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('Register Event'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Info Card
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                color: AppColors.darkerPurple,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.eventType.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.venue.name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.pink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Capacity: ${widget.expectedCapacity} people',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Event Image URL Option
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Or Enter Image URL',
                  hintText: 'Paste an image URL (https://...)',
                  labelStyle: const TextStyle(color: AppColors.white70),
                  hintStyle: const TextStyle(color: AppColors.white70),
                  prefixIcon: const Icon(Icons.link, color: AppColors.white70),
                  contentPadding: const EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.darkGrey,
                ),
                style: const TextStyle(color: AppColors.white),
                onChanged: (value) {
                  setState(() {
                    _enteredImageUrl = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Event Image Picker
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.darkGrey,
                      borderRadius: BorderRadius.circular(16),
                      image: _imageFile != null
                          ? DecorationImage(
                              image: FileImage(_imageFile!),
                              fit: BoxFit.cover,
                            )
                          : _uploadedImageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(_uploadedImageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),
                    child: _imageFile == null && _uploadedImageUrl == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 48,
                                color: AppColors.white70,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add Event Image',
                                style: TextStyle(
                                  color: AppColors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: AppColors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Event Type and Venue Info Card
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.darkGrey,
                      Color(0xFF2C0B3F),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.event,
                            color: AppColors.pink,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Event Type: ${widget.eventType.name}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      Icons.location_on,
                      'Venue',
                      widget.venue.name,
                      iconSize: 24,
                      fontSize: 16,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.map,
                      'Location',
                      widget.venue.location,
                      iconSize: 24,
                      fontSize: 16,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.people,
                      'Capacity',
                      '${widget.expectedCapacity} people',
                      iconSize: 24,
                      fontSize: 16,
                    ),
                    if (widget.venue.amenities.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Venue Amenities:',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.venue.amenities.map((amenity) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              amenity,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Host Type Selection
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                color: AppColors.darkGrey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Host Type',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Personal',
                                  style: TextStyle(color: AppColors.white70)),
                              subtitle: const Text(
                                  'Private events like weddings',
                                  style: TextStyle(color: AppColors.white70)),
                              value: 'personal',
                              groupValue: _hostType,
                              activeColor: AppColors.pink,
                              onChanged: (value) {
                                setState(() {
                                  _hostType = value!;
                                  _isPublic = false;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Professional',
                                  style: TextStyle(color: AppColors.white70)),
                              subtitle: const Text(
                                  'Public events and conferences',
                                  style: TextStyle(color: AppColors.white70)),
                              value: 'professional',
                              groupValue: _hostType,
                              activeColor: AppColors.pink,
                              onChanged: (value) {
                                setState(() {
                                  _hostType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      if (_hostType == 'professional') ...[
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Public Event',
                              style: TextStyle(color: AppColors.white70)),
                          subtitle: const Text(
                              'Promote this event on our platform',
                              style: TextStyle(color: AppColors.white70)),
                          value: _isPublic,
                          activeColor: AppColors.pink,
                          onChanged: (value) {
                            setState(() {
                              _isPublic = value;
                            });
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Professional Host Fields
              if (_hostType == 'professional' && _isPublic) ...[
                TextFormField(
                  controller: _hostNameController,
                  style: const TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    labelText: 'Host Organization Name',
                    hintText: 'Enter organization name',
                    labelStyle: const TextStyle(color: AppColors.white70),
                    hintStyle: const TextStyle(color: AppColors.white70),
                    prefixIcon:
                        const Icon(Icons.business, color: AppColors.white70),
                    contentPadding: const EdgeInsets.all(20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.darkGrey,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter organization name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _hostContactController,
                  style: const TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    labelText: 'Contact Information',
                    hintText: 'Email or phone number',
                    labelStyle: const TextStyle(color: AppColors.white70),
                    hintStyle: const TextStyle(color: AppColors.white70),
                    prefixIcon: const Icon(Icons.contact_mail,
                        color: AppColors.white70),
                    contentPadding: const EdgeInsets.all(20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.darkGrey,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter contact information';
                    }
                    if (_hostType == 'professional') {
                      // Email validation for professional hosts
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Please enter a valid email address';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _hostDescriptionController,
                  style: const TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    labelText: 'Host Description',
                    hintText: 'Tell us about your organization',
                    labelStyle: const TextStyle(color: AppColors.white70),
                    hintStyle: const TextStyle(color: AppColors.white70),
                    prefixIcon:
                        const Icon(Icons.description, color: AppColors.white70),
                    contentPadding: const EdgeInsets.all(20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.darkGrey,
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter host description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Ticket Price
              TextFormField(
                controller: _ticketPriceController,
                style: const TextStyle(color: AppColors.white),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Ticket Price (Optional)',
                  hintText: 'Enter ticket price',
                  labelStyle: const TextStyle(color: AppColors.white70),
                  hintStyle: const TextStyle(color: AppColors.white70),
                  prefixIcon:
                      const Icon(Icons.attach_money, color: AppColors.white70),
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
                  if (value != null && value.isNotEmpty) {
                    final price = double.tryParse(value);
                    if (price == null || price < 0) {
                      return 'Please enter a valid positive number for ticket price.';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Error message
              if (_errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.pink.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.pink,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: AppColors.pink,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Event Name
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  labelText: 'Event Name',
                  hintText: 'Enter your event name',
                  labelStyle: const TextStyle(color: AppColors.white70),
                  hintStyle: const TextStyle(color: AppColors.white70),
                  prefixIcon: const Icon(Icons.title, color: AppColors.white70),
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
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an event name';
                  }
                  if (value.trim().length < 3) {
                    return 'Event name must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Event Description
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  labelText: 'Event Description',
                  hintText: 'Describe your event',
                  labelStyle: const TextStyle(color: AppColors.white70),
                  hintStyle: const TextStyle(color: AppColors.white70),
                  prefixIcon:
                      const Icon(Icons.description, color: AppColors.white70),
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
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an event description';
                  }
                  if (value.trim().length < 20) {
                    return 'Description must be at least 20 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Event Date
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedDate == null
                          ? AppColors.pink
                          : AppColors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.darkGrey,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: _selectedDate == null
                            ? AppColors.pink
                            : AppColors.white70,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        _selectedDate == null
                            ? 'Select Event Date'
                            : 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedDate == null
                              ? AppColors.pink
                              : AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_selectedDate == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 12),
                  child: Text(
                    'Please select a date',
                    style: TextStyle(
                      color: AppColors.pink,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 40),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _registerEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.pink,
                          AppColors.pink,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      alignment: Alignment.center,
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white),
                              ),
                            )
                          : Text(
                              _hostType == 'professional' && _isPublic
                                  ? 'Register & Publish Event'
                                  : 'Register Event',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {double iconSize = 20, double fontSize = 14}) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.white70,
          size: iconSize,
        ),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            color: AppColors.white70,
            fontSize: fontSize,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: AppColors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
