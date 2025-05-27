import 'package:flutter/material.dart';
import '../../models/venue.dart';
import '../../theme/app_colors.dart';
import '../cards/venue_card.dart';

class VenueList extends StatelessWidget {
  final List<Venue> venues;

  const VenueList({
    Key? key,
    required this.venues,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (venues.isEmpty) {
      return const Center(
        child: Text(
          'No venues available',
          style: TextStyle(color: AppColors.white70),
        ),
      );
    }

    return ListView.builder(
      itemCount: venues.length,
      itemBuilder: (context, index) {
        final venue = venues[index];
        return VenueCard(venue: venue);
      },
    );
  }
}
