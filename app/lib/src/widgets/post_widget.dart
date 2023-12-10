import 'package:flutter/material.dart';
import 'package:GUConnect/src/models/Post.dart';

class Post_Widget extends StatelessWidget {
  const Post_Widget(this.post);
  final Post post;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.content,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          post.image != null
              ? Image.network(
                  post.image!,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : SizedBox(),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.thumb_up),
                  SizedBox(width: 4),
                  Text('${post.likes}'),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.comment),
                  SizedBox(width: 4),
                  // Text('${post.comments.length}'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
