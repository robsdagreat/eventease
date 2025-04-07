import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_type.dart';
import '../models/venue.dart';
import '../models/event.dart';
import '../services/auth_service.dart';

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
  DateTime? _selectedDate;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _registerEvent() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final currentUser = AuthService().currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final event = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        imageUrl: widget.venue.imageUrl,
        location: widget.venue.location,
        date: _selectedDate!,
        capacity: widget.expectedCapacity,
        eventTypeId: widget.eventType.id,
        venueId: widget.venue.id,
        userId: currentUser.id,
      );

      await FirebaseFirestore.instance
          .collection('events')
          .doc(event.id)
          .set(event.toMap());

      if (mounted) {
        Navigator.pop(context); // Return to venue suggestions
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event registered successfully!')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error registering event. Please try again.';
      });
      debugPrint('Error registering event: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Event'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Type and Venue Info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Event Type: ${widget.eventType.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Venue: ${widget.venue.name}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Location: ${widget.venue.location}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Capacity: ${widget.expectedCapacity} people',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Error message
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Event Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Event Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Event Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date Selection
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Event Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'Select a date'
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _registerEvent,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Register Event'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
