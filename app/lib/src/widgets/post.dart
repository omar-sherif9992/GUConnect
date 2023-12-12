import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/providers/LikesProvider.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/utils/dates.dart';
import 'package:GUConnect/src/widgets/comments_modal.dart';
import 'package:GUConnect/src/widgets/likable_image.dart';
import 'package:GUConnect/src/widgets/popup_menue_button.dart';
import 'package:GUConnect/src/widgets/status_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostW extends StatefulWidget {
  final String content;

  final String image;

  final String username;

  final String userImage;

  Set<String> likes;

  final List<Comment> comments;

  final DateTime createdAt;

  final int postType;

  final String postId;
  final String pendingStatus;

  PostW({
    super.key,
    required this.postId,
    required this.content,
    required this.image,
    required this.userImage,
    required this.username,
    required this.likes,
    required this.comments,
    required this.createdAt,
    required this.postType, // 0 -> NewsEvents and Clubs , 1 - L&F , 2 - Academic, 3 - Confessions
    this.pendingStatus = '',
  });

  @override
  State<PostW> createState() => _PostWState();
}

class _PostWState extends State<PostW> {
  late NewsEventClubProvider clubProvider;
  late LikesProvider likesProvider;
  late UserProvider userProvider;

  late Set<String> likes2;

  @override
  void initState() {
    super.initState();

    clubProvider = Provider.of<NewsEventClubProvider>(context, listen: false);
    likesProvider = Provider.of<LikesProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    likes2 = widget.likes;
  }

  void likePost(int like) {
    if (like == 0) {
      likesProvider
          .likePost(
              widget.postId, userProvider.user!.user_id ?? '', widget.postType)
          .then((val) {
        setState(() {
          likes2 = Set<String>.from(val);
        });
      });
    } else {
      likesProvider
          .dislike(
              widget.postId, userProvider.user!.user_id ?? '', widget.postType)
          .then((val) {
        setState(() {
          likes2 = Set<String>.from(val);
        });
      });
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    const Widget liked = Icon(Icons.favorite, color: Colors.red);
    const disliked = Icon(Icons.favorite_outline);

    final Widget likeIcon =
        likes2.contains(userProvider.user!.user_id ?? '') ? liked : disliked;

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
                        CachedNetworkImageProvider(widget.userImage),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // User name
                        widget.username,
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
              if (widget.pendingStatus != '')
                StatusIndicator(pendingStatus: widget.pendingStatus)
              else
                Container(),
              const PopupMenu(),
            ],
          ),
        ),
        // Caption
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            // Post caption
            widget.content,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ),
        // Image or Video
        //CachedNetworkImage(placeholder: (context, url) => const Loader(), imageUrl: widget.imgUrl,),
        if (widget.image != '')
          LikeableImage(
            imageUrl: widget.image,
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
