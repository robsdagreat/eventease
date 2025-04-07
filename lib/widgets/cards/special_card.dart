import 'package:flutter/material.dart';
import '../../models/special.dart';
import 'dart:developer' as developer;

class SpecialCard extends StatelessWidget {
  final Special special;

  const SpecialCard({Key? key, required this.special}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        height: 240,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image with improved loading and error states
                    Image.network(
                      special.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey.shade800,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.purple,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        developer.log('Error loading image',
                            error: error, stackTrace: stackTrace);
                        return Container(
                          color: Colors.grey.shade700,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.broken_image,
                                  size: 40, color: Colors.white54),
                              const SizedBox(height: 8),
                              Text(
                                'Failed to load image',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Discount chip
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_offer,
                                size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              special.discount,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Save button
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 20,
                          icon: const Icon(Icons.bookmark_border,
                              color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ),

                    // Bottom info overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Special name and price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    special.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$${special.originalPrice.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey.shade400,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '\$${special.discountedPrice.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Location
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 14, color: Colors.white70),
                                  const SizedBox(width: 4),
                                  Text(
                                    special.location,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Book Now Button
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purple,
                                    Colors.purpleAccent,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.calendar_today_outlined,
                                      size: 14, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'Book Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
