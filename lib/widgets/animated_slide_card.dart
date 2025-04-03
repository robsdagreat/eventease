import 'package:flutter/material.dart';

class AnimatedSlideCard extends StatefulWidget {
  final Widget child;
  final int index;

  const AnimatedSlideCard({
    Key? key,
    required this.child,
    required this.index,
  }) : super(key: key);

  @override
  State<AnimatedSlideCard> createState() => _AnimatedSlideCardState();
}

class _AnimatedSlideCardState extends State<AnimatedSlideCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800 + (widget.index * 200)),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Start the animation after a delay based on index
    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: widget.child,
    );
  }
}
