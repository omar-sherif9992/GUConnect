import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/utils/dates.dart';
import 'package:GUConnect/src/widgets/comment_popup_menu.dart';
import 'package:flutter/material.dart';

class CommentW extends StatelessWidget
{
  final Comment comment;

  final String postId;

  const CommentW({super.key, required this.comment, required this.postId, required this.callback});

  final VoidCallback callback;

  @override
  Widget build(context)
  {
      return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(comment.commenter.image??''),
            backgroundColor: Colors.grey,
            radius: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.commenter.userName??'',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 12,),
                    Text(
                      timeAgo(comment.createdAt),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          CommentPopupMenu(comment: comment, reportCollectionNameType: comment.postType, postId: postId, callback: callback),
        ],
      ),
      ); 
  }

}