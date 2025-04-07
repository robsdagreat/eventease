import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_ease/services/auth_service.dart';
import 'package:event_ease/screens/profile_screen.dart';
import 'package:event_ease/screens/auth_screen.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Location Information
          const Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Location',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Kigali, Rwanda',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Icons on the right
          Row(
            children: [
              // Notification Icon
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  icon: const Icon(Icons.notifications_outlined,
                      color: Colors.white),
                  onPressed: () {
                    // Handle notifications
                  },
                ),
              ),

              // Profile Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    final authService =
                        Provider.of<AuthService>(context, listen: false);
                    if (authService.currentUser != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileScreen()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AuthScreen()),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
