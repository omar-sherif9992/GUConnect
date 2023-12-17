
// import 'dart:ffi';

import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/CommentProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:GUConnect/src/widgets/comment.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
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
Widget build(BuildContext context) {
  return 
    FractionallySizedBox(
      heightFactor: 0.95,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Loader()
            : Column(
                children: [
                  const Icon(Icons.maximize),
                  Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const SizedBox(height: 20),
                            CommentW(
                              comment: comments[index],
                              postId: widget.postId,
                              callback: refresh,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  _buildCommentInput(),
                ],
              ),
      ),
  );
}

Widget _buildCommentInput() {
  final CustomUser trgt = (userProvider.user ?? posterPerson);
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(userProvider.user?.image ?? ''),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Portal(
            child: FlutterMentions(
              suggestionPosition: SuggestionPosition.Top,
              suggestionListDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color.fromARGB(255, 239, 236, 236),
              ),
              mentions: [
                Mention(
                  trigger: '@',
                  data: [
                    {
                      'id': trgt.user_id,
                      'display': trgt.userName,
                      'image': trgt.image
                    },
                    // ... Other mentions data
                  ],
                  suggestionBuilder: (e) {
                    return _buildSuggestionsList(e);
                  },
                  style: const TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            final String commentText = _commentController.text;
            addComment(commentText);
            _commentController.clear();
          },
        ),
      ],
    ),
  );
}


  Widget _buildSuggestionsList(Map<String, dynamic> data) {

    return 
        Container(
          padding: const EdgeInsets.all(8),
          height: 50,
          child: Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundImage: NetworkImage(data['image']),
              ),
              const SizedBox(width: 8),
              Text(
                data['display'],
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        );
}
}