import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade900,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple.withOpacity(0.8),
                  Colors.deepPurple.withOpacity(0.6),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35, color: Colors.purple),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome to EventEase',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Your Event Planning Partner',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.event, color: Colors.white),
            title:
                const Text('My Events', style: TextStyle(color: Colors.white)),
            onTap: () {
              // TODO: Navigate to My Events screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark, color: Colors.white),
            title: const Text('Saved Events',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              // TODO: Navigate to Saved Events screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title:
                const Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {
              // TODO: Navigate to Settings screen
            },
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.white),
            title: const Text('Help & Support',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              // TODO: Navigate to Help screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.white),
            title:
                const Text('About Us', style: TextStyle(color: Colors.white)),
            onTap: () {
              // TODO: Navigate to About screen
            },
          ),
        ],
      ),
    );
  }
}
