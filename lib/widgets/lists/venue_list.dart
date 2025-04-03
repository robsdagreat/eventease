import 'package:flutter/material.dart';
import '../../models/venue.dart';
import '../animated_slide_card.dart';
import '../cards/venue_card.dart';

class VenueList extends StatelessWidget {
  final List<Venue> venues;

  const VenueList({Key? key, required this.venues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: venues.length,
      itemBuilder: (context, index) {
        return AnimatedSlideCard(
          child: VenueCard(venue: venues[index]),
          index: index,
        );
      },
    );
  }
}
