
// import 'dart:ffi';

import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/CommentProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCommentModal extends StatefulWidget
{
  const EditCommentModal({super.key, required this.postType, required this.postId, required this.originalComment, required this.callback});

  final int postType;

  final String postId;

  final Comment originalComment;

  final VoidCallback callback;

  @override
  State<EditCommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<EditCommentModal> {

  late CommentProvider commentProvider;

  late UserProvider userProvider; 

  final CustomUser posterPerson = CustomUser(email: 'hussein.ebrahim@student.guc.edu.eg', password: 'Don Ciristiane Ronaldo', 
    image: 'https://images.mubicdn.net/images/cast_member/25100/cache-2388-1688754259/image-w856.jpg', fullName: 'Mr Milad Ghantous',userName: "Milad Ghantous");

  @override
  void initState()
  {
    super.initState();

    commentProvider = Provider.of<CommentProvider>(context, listen: false);

    userProvider = Provider.of<UserProvider>(context, listen: false);

  }

  Future updateComment(String content) async
  {
    commentProvider.editComment(widget.originalComment.id, content, widget.postId, widget.postType).then((value){
      if(value) {
        Navigator.of(context).pop();
        widget.callback();
      } else
      {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Failed to update Comment. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
      }
    });
  }

  final TextEditingController _commentController = TextEditingController();
 

  @override
  Widget build(context)
  {
     _commentController.text = widget.originalComment.content;
    return 
      FractionallySizedBox(
        heightFactor: 0.95,
        child: Padding(
          padding:  const EdgeInsets.all(16.0),
          child: 
          _buildCommentInput(),
        ),
      );
  }

  Widget _buildCommentInput() {

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        children: [
        CircleAvatar(
                    // User profile picture
                    radius: 18,
                    // Replace with your image URL
                    backgroundImage: NetworkImage(userProvider.user?.image??''),
                  ),
                  const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              // Handle comment submission here
              final String commentText = _commentController.text;
              // Perform any necessary actions with the commentText
              updateComment(commentText);
              print(commentText + " Rage3 Raye7 ahu");

              // Clear the comment input field
              _commentController.clear();
            },
          ),
        ],
      ),
    );
  }
}