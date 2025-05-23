import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ImagePlaceholder extends StatelessWidget {
  final IconData icon;

  const ImagePlaceholder({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkGrey, // Placeholder background color
      child: Center(
        child: Icon(
          icon,
          size: 60,
          color: AppColors.white70, // Placeholder icon color
        ),
      ),
    );
  }
}
