import 'package:GUConnect/src/dummy_data/posts.dart';
import 'package:GUConnect/src/utils/dates.dart';
import 'package:GUConnect/src/widgets/cached_image.dart';
import 'package:GUConnect/src/widgets/comments_modal.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:GUConnect/src/widgets/popup_menue_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostW extends StatelessWidget
{

  final String caption;

  final String imgUrl;

  final String username;

  final String userImage;

  final int likes;

  final List<Comment> comments;

  final DateTime createdAt;
  
  const PostW(
      {super.key,
      required this.caption,
      required this.imgUrl,
      required this.userImage,
      required this.username,
      required this.likes,
      required this.comments,
      required this.createdAt
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
                    backgroundImage: CachedNetworkImageProvider(userImage),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // User name
                        username,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5,),
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
        CachedNetworkImage(placeholder: (context, url) => const Loader(), imageUrl: imgUrl,),
        /*Image.network(
          // Replace with your image URL
          imgUrl,
          fit: BoxFit.cover,
        ),*/

        // Action buttons (like, comment)
         Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                  IconButton(
                    onPressed: (){},
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onSecondary),
                    ),
                    icon: const Icon(Icons.favorite_border),
                    iconSize: 28.0,
                    ),
        
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