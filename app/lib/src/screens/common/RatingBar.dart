import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CRatingBar extends StatefulWidget {
  double rating;

  CRatingBar({required this.rating});

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<CRatingBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingBar.builder(
          initialRating: widget.rating,
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 35,
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              widget.rating = rating;
            });
          },
        ),
      ],
    );
  }
}
