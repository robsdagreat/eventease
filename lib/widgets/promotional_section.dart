import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../screens/event_type_screen.dart';
import '../screens/auth_screen.dart';

class PromotionalSection extends StatelessWidget {
  final VoidCallback onGetStarted;

  const PromotionalSection({
    Key? key,
    required this.onGetStarted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        final isLoggedIn = authService.currentUser != null;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: const Color(0xFF2C0B3F),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isLoggedIn ? Icons.edit : Icons.emoji_events_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      isLoggedIn
                          ? 'Ready to Create Your Dream Event?'
                          : 'Got an event you planning to host in near future?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                isLoggedIn
                    ? 'Transform your vision into reality! Browse our curated venues, get expert insights, and start planning your perfect event. Our platform makes it easy to:'
                    : 'Join EventEase today and unlock a world of possibilities for your next event. Sign up now to start planning!',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              if (isLoggedIn) ...[
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFeatureItem(
                      icon: Icons.place_outlined,
                      label: 'Find Perfect Venues',
                    ),
                    _buildFeatureItem(
                      icon: Icons.event_outlined,
                      label: 'Easy Planning',
                    ),
                    _buildFeatureItem(
                      icon: Icons.insights_outlined,
                      label: 'Get Insights',
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (isLoggedIn) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EventTypeScreen(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    isLoggedIn ? 'Start Planning' : 'Get Started',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
