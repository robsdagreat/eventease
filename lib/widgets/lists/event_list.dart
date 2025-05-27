import 'package:flutter/material.dart';
import '../../models/event.dart';
import '../../theme/app_colors.dart';
import '../cards/event_card.dart';

class EventList extends StatelessWidget {
  final List<Event> events;

  const EventList({
    Key? key,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(
        child: Text(
          'No events available',
          style: TextStyle(color: AppColors.white70),
        ),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventCard(event: event);
      },
    );
  }
}
