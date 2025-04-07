import 'package:flutter/material.dart';
import 'package:future_capsule/data/models/capsule_modal.dart';

class ManualAnimatedUserTile extends StatefulWidget {
  final Widget child;
  final int index;

  const ManualAnimatedUserTile({
    super.key,
    required this.child,
    required this.index,
  });

  @override
  ManualAnimatedUserTileState createState() => ManualAnimatedUserTileState();
}

class ManualAnimatedUserTileState extends State<ManualAnimatedUserTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Stagger the animation based on index.
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
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
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

class LikeableImage extends StatefulWidget {
  final CapsuleModel capsule;
  final String userId;
  final void Function() onLike;
  final Widget child;

  const LikeableImage({
    super.key,
    required this.capsule,
    required this.userId,
    required this.onLike,
    required this.child,
  });

  @override
  State<LikeableImage> createState() => _LikeableImageState();
}

class _LikeableImageState extends State<LikeableImage>
    with SingleTickerProviderStateMixin {
  bool showHeart = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation =
        Tween<double>(begin: 0.8, end: 1.4).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  void _handleDoubleTap() {
    widget.onLike();
    setState(() {
      showHeart = true;
    });

    _controller.forward(from: 0);

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          showHeart = false;
        });
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
    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Replace with your image or video
          widget.child,

          // Heart animation
          if (showHeart)
            ScaleTransition(
              scale: _scaleAnimation,
              child: const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 100,
              ),
            ),
        ],
      ),
    );
  }
}
