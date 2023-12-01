
import 'package:GUConnect/src/dummy_data/posts.dart';
import 'package:flutter/material.dart';
import 'package:GUConnect/src/widgets/comment.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class CommentModal extends StatefulWidget
{
  const CommentModal({super.key, required this.comments});

  final List<Comment> comments;

  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {

  final TextEditingController _commentController = TextEditingController();

  bool isEmojiPickerVisible = false;

  final Config emojiPicker = const Config(
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
          child: Column(
            children: [
              const Icon(Icons.maximize,),
              Text(
                'Comments',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
              ),
              Expanded(
            child: ListView.builder(
              itemCount: widget.comments.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(height: 20,),
                    CommentW(
                      comment: widget.comments[index].content,
                      userName: widget.comments[index].userName,
                      userImgUrl: widget.comments[index].userImgUrl,
                      createdAt: widget.comments[index].createdAt,
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
              print('Comment submitted: $commentText');

              // Clear the comment input field
              _commentController.clear();
            },
          ),
        ],
      ),
    );
  }
}