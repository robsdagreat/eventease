import 'package:flutter/material.dart';
import '../../models/venue.dart';
import '../animated_slide_card.dart';
import '../cards/venue_card.dart';
import '../../screens/single_venue_screen.dart';

class VenueList extends StatelessWidget {
  final List<Venue> venues;

  const VenueList({Key? key, required this.venues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: venues.length,
      itemBuilder: (context, index) {
        final venue = venues[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingleVenueScreen(venue: venue),
              ),
            );
          },
          child: AnimatedSlideCard(
            index: index,
            child: VenueCard(venue: venue),
          ),
        );
      },
    );
  }
}
