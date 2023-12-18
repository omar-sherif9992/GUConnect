
// import 'dart:ffi';

import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/CommentProvider.dart';
import 'package:GUConnect/src/providers/UsabilityProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:GUConnect/src/widgets/comment.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class CommentModal extends StatefulWidget
{
  const CommentModal({super.key, required this.postType, required this.postId});

  

  final int postType;

  final String postId;



  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {

  late CommentProvider commentProvider;

  late UserProvider userProvider; 
  late UsabilityProvider usabilityProvider;

  late List<Comment> comments;

  bool _isLoading = true;

  final CustomUser posterPerson = CustomUser(email: 'hussein.ebrahim@student.guc.edu.eg', password: 'Don Ciristiane Ronaldo', 
    image: 'https://images.mubicdn.net/images/cast_member/25100/cache-2388-1688754259/image-w856.jpg', fullName: 'Mr Milad Ghantous',userName: "Milad Ghantous");

  @override
  void initState()
  {
    super.initState();

    commentProvider = Provider.of<CommentProvider>(context, listen: false);

    userProvider = Provider.of<UserProvider>(context, listen: false);
    usabilityProvider = Provider.of<UsabilityProvider>(context, listen: false);

    refresh();

  }

  void refresh()
  {
    commentProvider.getPostComments(widget.postId, widget.postType).then((value){
      setState(() {
        comments = value;
        comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _isLoading = false;
      });
    });
  }

  Future addComment(String content) async
  {
    final Comment newComment = Comment(content: content, commenter: userProvider.user!, createdAt: DateTime.now(), postType: widget.postType);
    commentProvider.addComment(newComment, widget.postId).then(
      (val){
        setState(() {
          comments = val;
          comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        });
      }
    );
  }

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(context)
  {
    return 
      FractionallySizedBox(
        heightFactor: 0.95,
        child: Padding(
          padding:  const EdgeInsets.all(16.0),
          child: 
          _isLoading? const Loader():
          Column(
            children: [
              const Icon(Icons.maximize,),
              Text(
                'Comments',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
              ),
              Expanded(
            child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            usabilityProvider.logEvent(userProvider.user!.email, 'Scrolling_Up_In_Comments');           
          } else if (notification.direction == ScrollDirection.reverse) {
            usabilityProvider.logEvent(userProvider.user!.email, 'Scrolling_Down_In_Comments');
          }
          return false; // Return false to allow the notification to continue to be dispatched.
        },
        child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(height: 20,),
                    CommentW(
                      comment: comments[index],
                      postId: widget.postId,
                      callback: refresh,
                    )
                  ],
                );
                }
            ),
          )),
          _buildCommentInput(),
          /*if (isEmojiPickerVisible) SizedBox(
            height: 200,
            child: EmojiPicker(
                textEditingController: _commentController,
                config: emojiPicker,
              ),
          ) else Container()*/
            ],
          ),
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
          /*IconButton(
            icon: const Icon(Icons.emoji_emotions),
            onPressed: () {
              setState(() {
                isEmojiPickerVisible = !isEmojiPickerVisible;
              });
            },
          ),*/
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              // Handle comment submission here
              final String commentText = _commentController.text;
              // Perform any necessary actions with the commentText

              addComment(commentText);
              // Clear the comment input field
              _commentController.clear();
              usabilityProvider.logEvent(userProvider.user!.email, 'Add_Comment');
            },
          ),
        ],
      ),
    );
  }
}