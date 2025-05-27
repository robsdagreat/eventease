import 'package:flutter/material.dart';
import '../../models/special.dart';
import '../../theme/app_colors.dart';
import '../cards/special_card.dart';

class SpecialList extends StatelessWidget {
  final List<Special> specials;

  const SpecialList({
    Key? key,
    required this.specials,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (specials.isEmpty) {
      return const Center(
        child: Text(
          'No specials available',
          style: TextStyle(color: AppColors.white70),
        ),
      );
    }

    return ListView.builder(
      itemCount: specials.length,
      itemBuilder: (context, index) {
        final special = specials[index];
        return SpecialCard(special: special);
      },
    );
  }
}
