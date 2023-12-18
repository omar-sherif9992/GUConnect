import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/models/LostAndFound.dart';
import 'package:GUConnect/src/models/Post.dart';
import 'package:GUConnect/src/providers/LikesProvider.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/providers/UsabilityProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/services/notification_api.dart';
import 'package:GUConnect/src/utils/dates.dart';
import 'package:GUConnect/src/widgets/comments_modal.dart';
import 'package:GUConnect/src/widgets/likable_image.dart';
import 'package:GUConnect/src/widgets/popup_menue_button.dart';
import 'package:GUConnect/src/widgets/status_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';

class PostW extends StatefulWidget {
  final Post post;

  final int postType;

  final String pendingStatus;

  VoidCallback? refresh;

  PostW({
    super.key,
    required this.post,
    required this.postType, // 0 -> NewsEvents and Clubs , 1 - L&F , 2 - Academic, 3 - Confessions
    this.pendingStatus = '',
    this.refresh,
  });

  @override
  State<PostW> createState() => _PostWState();
}

class _PostWState extends State<PostW> {
  late NewsEventClubProvider clubProvider;
  late LikesProvider likesProvider;
  late UserProvider userProvider;
  late UsabilityProvider usabilityProvider;

  late Set<String> likes2;

  @override
  void initState() {
    super.initState();

    clubProvider = Provider.of<NewsEventClubProvider>(context, listen: false);
    likesProvider = Provider.of<LikesProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    usabilityProvider = Provider.of<UsabilityProvider>(context, listen: false);
    likes2 = widget.post.likes;
  }

  Future<void> likePost(int like) async {
    if (like == 0) {
      await likesProvider
          .likePost(
              widget.post.id, userProvider.user!.user_id ?? '', widget.postType)
          .then((val) {
        setState(() {
          likes2 = Set<String>.from(val);
        });
      });

      if (userProvider.user!.user_id != widget.post.sender.user_id) {
        await FirebaseNotification.sendLikeNotification(
          widget.post.sender.fullName ?? '',
          widget.post.sender.token ?? '',
          widget.post.id,
          widget.postType == 0
              ? 'NewsEventClub'
              : widget.postType == 1
                  ? 'LostAndFound'
                  : widget.postType == 2
                      ? 'Academic'
                      : 'Confession',
          userProvider.user!.userName ?? '',
        );
      }
    } else {
      await likesProvider
          .dislike(
              widget.post.id, userProvider.user!.user_id ?? '', widget.postType)
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
                    backgroundImage: CachedNetworkImageProvider(
                        widget.post.sender.image ?? ''),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(CustomRoutes.profile,
                                  arguments: {'user': widget.post.sender});
                            },
                            child: Text(
                              // User name
                              widget.post.sender.userName ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onBackground,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8,),
                          if (widget.pendingStatus != '')
                            StatusIndicator(pendingStatus: widget.pendingStatus)
                          else
                            Container(),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        timeAgo(widget.post.createdAt),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              
              PopupMenu(
                post: widget.post,
                reportCollectionNameType: widget.postType,
              ),
            ],
          ),
        ),
        // Caption
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // Post caption
                widget.post.content,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              const SizedBox(height: 10),
              if (widget.post is Confession)
                Row(
                  children: (widget.post as Confession)
                      .mentionedPeople!
                      .map((e) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  CustomRoutes.profile,
                                  arguments: {'user': e});
                            },
                            child: Text(
                              '@${e.mentionLabel}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ))
                      .toList(),
                ),
              if (widget.post is LostAndFound &&
                  (widget.post as LostAndFound).contact != '')
                Row(
                  children: [
                    Text(
                      'Contact   ',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600),
                    ),
                    Text((widget.post as LostAndFound).contact ?? ''),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                        child: Icon(Icons.phone,
                            color: Theme.of(context).colorScheme.primary),
                        onTap: () async {
                          await FlutterPhoneDirectCaller.callNumber(
                              (widget.post as LostAndFound).contact ?? '');
                        }),
                  ],
                ),
            ],
          ),
        ),
        // Image or Video
        //CachedNetworkImage(placeholder: (context, url) => const Loader(), imageUrl: widget.imgUrl,),
        if (widget.post.image != '')
          LikeableImage(
            imageUrl: widget.post.image,
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
                  usabilityProvider.logEvent(
                      userProvider.user!.email,
                      likeIcon == disliked
                          ? 'Liking_Post'
                          : 'Disliking_Post'); // Analytics
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
                          postType: widget.postType, postId: widget.post.id);
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
