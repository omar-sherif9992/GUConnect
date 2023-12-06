
// import 'dart:ffi';

import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/CommentProvider.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:GUConnect/src/widgets/comment.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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

  late List<Comment> comments;

  bool _isLoading = true;

  final CustomUser posterPerson = CustomUser(email: 'hussein.ebrahim@student.guc.edu.eg', password: 'Don Ciristiane Ronaldo', userType: UserType.student,
    image: 'https://images.mubicdn.net/images/cast_member/25100/cache-2388-1688754259/image-w856.jpg', fullName: 'Mr Milad Ghantous');

  @override
  void initState()
  {
    super.initState();

    commentProvider = Provider.of<CommentProvider>(context, listen: false);

    

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
    final Comment newComment = Comment(content: content, commenter: posterPerson, createdAt: DateTime.now(), postType: widget.postType);
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

  bool isEmojiPickerVisible = false;


  final
   Config emojiPicker = const Config(
        columns: 7,
        verticalSpacing: 0,
        horizontalSpacing: 0,
        gridPadding: EdgeInsets.zero,
        initCategory: Category.RECENT,
        bgColor: Color(0xFFF2F2F2),
        indicatorColor: Colors.blue,
        iconColor: Colors.grey,
        iconColorSelected: Colors.blue,
        backspaceColor: Colors.blue,
        skinToneDialogBgColor: Colors.white,
        skinToneIndicatorColor: Colors.grey,
        enableSkinTones: true,
        recentTabBehavior: RecentTabBehavior.RECENT,
        recentsLimit: 28,
        noRecents:  Text(
          'No Recents',
          style: TextStyle(fontSize: 20, color: Colors.black26),
          textAlign: TextAlign.center,
        ), // Needs to be const Widget
        loadingIndicator: SizedBox.shrink(), // Needs to be const Widget
        tabIndicatorAnimDuration: kTabScrollDuration,    
        categoryIcons:  CategoryIcons(),
        buttonMode: ButtonMode.MATERIAL,
    );


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
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(height: 20,),
                    CommentW(
                      comment: comments[index].content,
                      userName: comments[index].commenter.fullName??'',
                      userImgUrl: comments[index].commenter.image??'',
                      createdAt: comments[index].createdAt,
                    )
                  ],
                );
                }
            ),
          ),
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
        const CircleAvatar(
                    // User profile picture
                    radius: 18,
                    // Replace with your image URL
                    backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Jason_Statham_2018.jpg/330px-Jason_Statham_2018.jpg'),
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
              print(commentText + " Raye7 ahu");

              // Clear the comment input field
              _commentController.clear();
            },
          ),
        ],
      ),
    );
  }
}