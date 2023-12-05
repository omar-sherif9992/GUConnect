import 'package:GUConnect/src/utils/dates.dart';
import 'package:flutter/material.dart';

class CommentW extends StatelessWidget
{
  final String comment;
  final String userName;
  final String userImgUrl;
  final DateTime createdAt;

  const CommentW({super.key, required this.comment,
  required this.userName, required this.userImgUrl, required this.createdAt});

  @override
  Widget build(context)
  {
      return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(userImgUrl),
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
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 12,),
                    Text(
                      timeAgo(createdAt),
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
                  comment,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
      ); 
  }

}