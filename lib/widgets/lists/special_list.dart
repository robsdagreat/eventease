import 'package:flutter/material.dart';
import '../../models/special.dart';
import '../animated_slide_card.dart';
import '../cards/special_card.dart';

class SpecialList extends StatelessWidget {
  final List<Special> specials;

  const SpecialList({Key? key, required this.specials}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: specials.length,
      itemBuilder: (context, index) {
        return AnimatedSlideCard(
          child: SpecialCard(special: specials[index]),
          index: index,
        );
      },
    );
  }
}
