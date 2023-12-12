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
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (post.image != null) Image.network(
                  post.image!,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ) else const SizedBox(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.thumb_up),
                  const SizedBox(width: 4),
                  Text('${post.likes}'),
                ],
              ),
              const Row(
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
