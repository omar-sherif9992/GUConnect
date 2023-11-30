import 'package:flutter/material.dart';
import 'package:GUConnect/src/dummy_data/posts.dart';

class Post_Widget extends StatelessWidget {
  const Post_Widget(this.post);
  final Post post;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              post.text,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Image.network(
            post.imageUrl,
            fit: BoxFit.cover,
            height: 200.0,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up),
                    SizedBox(width: 4.0),
                    Text('${post.likes} Likes'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.comment),
                    SizedBox(width: 4.0),
                    Text('${post.comments} Comments'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
