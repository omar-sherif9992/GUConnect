import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CRatingBar extends StatefulWidget {
  double rating;
  Function(double) onRatingSubmit = (rating) => print(rating);
  Function() onRatingDelete = () => print('delete');
  bool isRatingEnabled = true;
  bool isRatingSubmitted = false;

  CRatingBar(
      {required this.rating,
      required this.onRatingSubmit,
      required this.onRatingDelete}) {
    isRatingEnabled = rating == 0;
    isRatingSubmitted = rating != 0;
  }

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
          ignoreGestures: !widget.isRatingEnabled,
        ),
        SizedBox(width: 10),
        if (widget.isRatingEnabled)
          ElevatedButton(
            onPressed: () {
              widget.onRatingSubmit(widget.rating);
              setState(() {
                widget.isRatingEnabled = false;
                widget.isRatingSubmitted = true;
              });
            },
            child: const Text('Submit'),
          ),
        if (widget.isRatingSubmitted)
          ElevatedButton(
            onPressed: () {
              widget.onRatingDelete();
              setState(() {
                widget.isRatingEnabled = true;
                widget.isRatingSubmitted = false;
              });
            },
            child: const Text('Remove'),
          ),
      ],
    );
  }
}
