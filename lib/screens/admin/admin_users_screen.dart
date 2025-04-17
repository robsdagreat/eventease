import 'package:flutter/material.dart';
import 'package:eventease/services/admin_service.dart';
import 'package:eventease/models/user.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({Key? key}) : super(key: key);

  @override
  _AdminUsersScreenState createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final AdminService _adminService = AdminService();
  List<User> _users = [];
  bool _isLoading = true;
  bool _showAdminsOnly = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await _adminService.getUsers(
        admin: _showAdminsOnly ? true : null,
      );
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users: $e')),
      );
    }
  }

  Future<void> _toggleUserAdmin(String userId) async {
    try {
      final success = await _adminService.toggleUserAdmin(userId);
      if (success) {
        setState(() {
          final user = _users.firstWhere((u) => u.id == userId);
          user.isAdmin = !user.isAdmin;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User admin status updated')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        actions: [
          Switch(
            value: _showAdminsOnly,
            onChanged: (value) {
              setState(() {
                _showAdminsOnly = value;
                _loadUsers();
              });
            },
            activeColor: Colors.purple,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text('Admins Only'),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUsers,
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(user.name[0].toUpperCase()),
                      ),
                      title: Text(user.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.email),
                          Text(
                            'Events: ${user.eventsCount}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              user.isAdmin
                                  ? Icons.admin_panel_settings
                                  : Icons.person,
                              color: user.isAdmin ? Colors.purple : Colors.grey,
                            ),
                            onPressed: () => _toggleUserAdmin(user.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete User'),
                                  content: Text(
                                    'Are you sure you want to delete ${user.name}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // Implement delete user
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
