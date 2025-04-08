import 'package:flutter/material.dart';
import '../models/event_type.dart';
import 'venue_suggestions_screen.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';
import 'package:provider/provider.dart';

class EventTypeScreen extends StatefulWidget {
  const EventTypeScreen({Key? key}) : super(key: key);

  @override
  State<EventTypeScreen> createState() => _EventTypeScreenState();
}

class _EventTypeScreenState extends State<EventTypeScreen> {
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'favorite':
        return Icons.favorite;
      case 'business':
        return Icons.business;
      case 'cake':
        return Icons.cake;
      case 'music_note':
        return Icons.music_note;
      case 'museum':
        return Icons.museum;
      default:
        return Icons.event;
    }
  }

  Widget _buildEventTypeCard(BuildContext context, EventType eventType) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VenueSuggestionsScreen(
                eventType: eventType,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    eventType.imageUrl,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconData(eventType.icon),
                    color: Colors.purple,
                    size: 24,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventType.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    eventType.description,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Capacity: ${eventType.minCapacity} - ${eventType.maxCapacity} people',
                    style: const TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final isLoggedIn = authService.currentUser != null;

    if (!isLoggedIn) {
      return const AuthScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Event Type'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildEventTypeCard(
            context,
            EventType(
              id: 'wedding',
              name: 'Wedding',
              description: 'Find the perfect venue for your special day',
              imageUrl: 'https://picsum.photos/id/1033/400/300',
              icon: 'favorite',
              minCapacity: 50,
              maxCapacity: 500,
            ),
          ),
          const SizedBox(height: 16),
          _buildEventTypeCard(
            context,
            EventType(
              id: 'corporate',
              name: 'Corporate',
              description:
                  'Professional spaces for meetings, conferences, and seminars',
              imageUrl: 'https://picsum.photos/id/1048/400/300',
              icon: 'business',
              minCapacity: 10,
              maxCapacity: 1000,
            ),
          ),
          const SizedBox(height: 16),
          _buildEventTypeCard(
            context,
            EventType(
              id: 'birthday',
              name: 'Birthday',
              description: 'Celebrate your special day in style',
              imageUrl: 'https://picsum.photos/id/1058/400/300',
              icon: 'cake',
              minCapacity: 10,
              maxCapacity: 200,
            ),
          ),
          const SizedBox(height: 16),
          _buildEventTypeCard(
            context,
            EventType(
              id: 'concert',
              name: 'Concert',
              description: 'Large venues for music events and performances',
              imageUrl: 'https://picsum.photos/id/1082/400/300',
              icon: 'music_note',
              minCapacity: 100,
              maxCapacity: 5000,
            ),
          ),
          const SizedBox(height: 16),
          _buildEventTypeCard(
            context,
            EventType(
              id: 'exhibition',
              name: 'Exhibition',
              description: 'Showcase your art, products, or ideas',
              imageUrl: 'https://picsum.photos/id/1076/400/300',
              icon: 'museum',
              minCapacity: 50,
              maxCapacity: 2000,
            ),
          ),
        ],
      ),
    );
  }
}
