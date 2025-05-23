import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../models/special.dart';

class AdminSpecialsScreen extends StatefulWidget {
  const AdminSpecialsScreen({super.key});

  @override
  State<AdminSpecialsScreen> createState() => _AdminSpecialsScreenState();
}

class _AdminSpecialsScreenState extends State<AdminSpecialsScreen> {
  final AdminService _adminService = AdminService();
  List<Special> _specials = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSpecials();
  }

  Future<void> _loadSpecials() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final specials = await _adminService.getSpecials();
      if (!mounted) return;
      setState(() {
        _specials = specials;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading specials: $e')),
      );
    }
  }

  Future<void> _deleteSpecial(String specialId) async {
    if (!mounted) return;
    try {
      await _adminService.deleteSpecial(specialId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Special deleted successfully')),
      );
      _loadSpecials();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting special: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Specials'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to add special screen
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _specials.isEmpty
              ? const Center(child: Text('No specials found'))
              : ListView.builder(
                  itemCount: _specials.length,
                  itemBuilder: (context, index) {
                    final special = _specials[index];
                    return ListTile(
                      leading: special.imageUrl != null
                          ? Image.network(special.imageUrl!)
                          : const Icon(Icons.local_offer),
                      title: Text(special.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(special.description),
                          Text(
                            '${special.startDate.toString()} - ${special.endDate.toString()}',
                          ),
                          Text(
                            special.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color:
                                  special.isActive ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // TODO: Navigate to edit special screen
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Special'),
                                  content: Text(
                                      'Are you sure you want to delete ${special.title}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirmed == true) {
                                _deleteSpecial(special.id);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
