import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/LikesProvider.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/utils/dates.dart';
import 'package:GUConnect/src/widgets/comments_modal.dart';
import 'package:GUConnect/src/widgets/likable_image.dart';
import 'package:GUConnect/src/widgets/popup_menue_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Confession_Widget extends StatefulWidget {
  final String caption;

  final String imgUrl;

  final CustomUser user;

  Set<String> likes;

  final List<Comment> comments;

  final DateTime createdAt;

  final int postType;

  final String postId;

  Confession_Widget({
    super.key,
    required this.postId,
    required this.caption,
    required this.imgUrl,
    required this.user,
    required this.likes,
    required this.comments,
    required this.createdAt,
    required this.postType,
  });

  @override
  State<Confession_Widget> createState() => _PostWState();
}

class _PostWState extends State<Confession_Widget> {
  final String userId = '1';

  late NewsEventClubProvider clubProvider;
  late LikesProvider likesProvider;

  late Set<String> likes2;

  @override
  void initState() {
    super.initState();

    clubProvider = Provider.of<NewsEventClubProvider>(context, listen: false);
    likesProvider = Provider.of<LikesProvider>(context, listen: false);
    likes2 = widget.likes;
  }

  void likePost(int like) {
    switch (widget.postType) {
      case 0:
        {
          if (like == 0) {
            likesProvider.likePost(widget.postId, userId, widget.postType).then((val) {
              setState(() {
                likes2 = Set<String>.from(val);
              });
            });
          } else {
            likesProvider.dislike(widget.postId, userId, widget.postType).then((val) {
              setState(() {
                likes2 = Set<String>.from(val);
              });
            });
          }
          return;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Widget liked = Icon(Icons.favorite, color: Colors.red);
    const disliked = Icon(Icons.favorite_outline);

    final Widget likeIcon = likes2.contains(userId) ? liked : disliked;

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
                    backgroundImage:
                        CachedNetworkImageProvider(widget.user.image??''),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // User name
                        widget.user.userName??'',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        timeAgo(widget.createdAt),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              PopupMenu(reportedId: widget.postId, reportedUser: widget.user, reportedContent: widget.caption,
               reportCollectionNameType: widget.postType, image: '', createdAt: widget.createdAt,
              ),
            ],
          ),
        ),
        // Caption
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            // Post caption
            widget.caption,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ),
        // Image or Video
        //CachedNetworkImage(placeholder: (context, url) => const Loader(), imageUrl: widget.imgUrl,),
        LikeableImage(
          imageUrl: widget.imgUrl,
          handleLike: likePost,
        ),
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
                onPressed: () {
                  likeIcon == disliked ? likePost(0) : likePost(1);
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.onSecondary),
                ),
                icon: likeIcon,
                iconSize: 28.0,
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return CommentModal(
                          postType: widget.postType, postId: widget.postId);
                    },
                    isScrollControlled: true, // Takes up the whole screen
                    isDismissible: true,
                  );
                },
                icon: const Icon(Icons.mode_comment_outlined),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.onSecondary),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            likeIcon == liked
                ? ('You ${likes2.length - 1 > 0 ? ' and ${likes2.length - 1} others ' : 'like this post'}')
                : '${likes2.length} likes',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
