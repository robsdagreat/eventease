import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final List<String> imagePaths;

  const AnimatedBackground({
    Key? key,
    required this.child,
    required this.imagePaths,
  }) : super(key: key);

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> {
  int _currentImageIndex = 0;
  Timer? _timer;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        _currentImageIndex =
            (_currentImageIndex + 1) % widget.imagePaths.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image or Fallback Color
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          child: _hasError
              ? Container(
                  key: const ValueKey('fallback'),
                  color: Colors.purple.shade900,
                  width: double.infinity,
                  height: double.infinity,
                )
              : Image.asset(
                  widget.imagePaths[_currentImageIndex],
                  key: ValueKey<int>(_currentImageIndex),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    _hasError = true;
                    return Container(
                      key: const ValueKey('error'),
                      color: Colors.purple.shade900,
                      width: double.infinity,
                      height: double.infinity,
                    );
                  },
                ),
        ),
        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
        ),
        // Content
        widget.child,
      ],
    );
  }
}
