import 'package:GUConnect/src/dummy_data/posts.dart';
import 'package:GUConnect/src/widgets/comments_modal.dart';
import 'package:GUConnect/src/widgets/popup_menue_button.dart';
import 'package:flutter/material.dart';

class PostW extends StatelessWidget
{

  final String caption;

  final String imgUrl;

  final String username;

  final String userImage;

  final int likes;

  final List<Comment> comments;
  
  const PostW(
      {super.key,
      required this.caption,
      required this.imgUrl,
      required this.userImage,
      required this.username,
      required this.likes,
      required this.comments
      }
      );

  void showComments()
  {

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    // User profile picture
                    radius: 20,
                    // Replace with your image URL
                    backgroundImage: NetworkImage(userImage),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    // User name
                    username,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const PopupMenu(),
            ],
          ),
        ),
        // Caption
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            // Post caption
            caption,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        // Image or Video
        Image.network(
          // Replace with your image URL
          imgUrl,
          fit: BoxFit.cover,
          height: 300,
        ),
        // Action buttons (like, comment)
         Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: (){},
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onSecondary),
                    ),
                    icon: const Icon(Icons.favorite_border),
                    ),
                  //const SizedBox(width: 4),
                  /*Text('Like',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    )
                  ),*/
                ],
              ),
              const SizedBox(width: 5,),
              Row(
                children: [
                  IconButton(
                      onPressed: (){
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return CommentModal(comments: comments);
                          },
                          isScrollControlled: true, // Takes up the whole screen
                          isDismissible: true,
                        );
                      },
                      icon: const Icon(Icons.mode_comment_outlined),
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onSecondary),
                      ),
                  ),
                  //const SizedBox(width: 8),
                  /*Text('Comment',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    )
                  ),*/
                ],
              ),
            ],
          ),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text('$likes likes',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold
                    ),
                  ),),
        
      ],
    );
  }
}