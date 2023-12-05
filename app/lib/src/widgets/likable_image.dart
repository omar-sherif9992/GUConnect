import 'package:GUConnect/src/widgets/loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LikeableImage extends StatefulWidget {
  final String imageUrl;

  final Function(int) handleLike;

  LikeableImage({required this.imageUrl, required this.handleLike });

  @override
  _LikeableImageState createState() => _LikeableImageState();
}

class _LikeableImageState extends State<LikeableImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.4,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.6,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.addListener(() {
      setState(() {});
    });
 
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (_controller.isAnimating) {
      // Animation is already in progress, do nothing to avoid restarting
      return;
    }

    if (_controller.status == AnimationStatus.completed) {
      // If the animation is completed, reset it before starting again
      _controller.reset();
    }

    // Start the animation
    _controller.forward();

    widget.handleLike(0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CachedNetworkImage(placeholder: (context, url) => const Loader(), imageUrl: widget.imageUrl,),
          if (_controller.isAnimating)
            Positioned.fill(
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 80.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}