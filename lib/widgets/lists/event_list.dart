import 'package:flutter/material.dart';
import '../../models/event.dart';
import '../animated_slide_card.dart';
import '../cards/event_card.dart';

class EventList extends StatelessWidget {
  final List<Event> events;

  const EventList({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return AnimatedSlideCard(
          child: EventCard(event: events[index]),
          index: index,
        );
      },
    );
  }
}
