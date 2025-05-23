import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../models/venue.dart';

class AdminVenuesScreen extends StatefulWidget {
  const AdminVenuesScreen({Key? key}) : super(key: key);

  @override
  State<AdminVenuesScreen> createState() => _AdminVenuesScreenState();
}

class _AdminVenuesScreenState extends State<AdminVenuesScreen> {
  final AdminService _adminService = AdminService();
  List<Venue> _venues = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVenues();
  }

  Future<void> _loadVenues() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final venues = await _adminService.getVenues();
      if (!mounted) return;
      setState(() {
        _venues = venues;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load venues: $e')),
      );
    }
  }

  Future<void> _deleteVenue(String venueId) async {
    try {
      await _adminService.deleteVenue(venueId);
      if (mounted) {
        setState(() {
          _venues.removeWhere((venue) => venue.id == venueId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Venue deleted successfully')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete venue: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Venues'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add venue screen
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadVenues,
              child: ListView.builder(
                itemCount: _venues.length,
                itemBuilder: (context, index) {
                  final venue = _venues[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(venue.images.first),
                      ),
                      title: Text(venue.name),
                      subtitle: Text(
                        '${venue.location} • ${venue.venueType} • Capacity: ${venue.capacity}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Navigate to edit venue screen
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Venue'),
                                  content: Text(
                                    'Are you sure you want to delete ${venue.name}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _deleteVenue(venue.id);
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
