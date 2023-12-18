import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/Usability.dart';
import 'package:GUConnect/src/providers/CommentProvider.dart';
import 'package:GUConnect/src/providers/UsabilityProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/widgets/edit_comment.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:GUConnect/src/widgets/report_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// This is the type used by the popup menu below.
enum SampleItem { Report, Edit, Delete }

class CommentPopupMenu extends StatefulWidget {
  final Comment comment;
  final int reportCollectionNameType;
  final String postId;

  final VoidCallback callback;
  const CommentPopupMenu({super.key, required this.comment, required this.reportCollectionNameType, required this.postId, required this.callback});

  @override
  State<CommentPopupMenu> createState() => _PopupMenuState();
}



class _PopupMenuState extends State<CommentPopupMenu> {
  SampleItem? selectedMenu;

  late UserProvider userProvider;
  late UsabilityProvider usabilityProvider;

  @override
  void initState()
  {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    usabilityProvider = Provider.of<UsabilityProvider>(context, listen: false);
  }

  void onDeleteConfirm() async
  {
    usabilityProvider.logEvent(userProvider.user!.email, 'Delete_Comment_Confirmed');
      showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Loader(),
              SizedBox(height: 16),
              Text('Deleting Comment...'),
            ],
          ),
        );
      },
    );

    await Provider.of<CommentProvider>(context, listen: false).removeComment(widget.comment, widget.postId);
    widget.callback();
    Navigator.of(context).pop();
    Navigator.of(context).pop();

  }

  void onDeleteCancel()
  {
    usabilityProvider.logEvent(userProvider.user!.email, 'Delete_Comment_Cancelled');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    
    final Widget deleteConfirmation = AlertDialog(
      title: const Text('Delete Comment'),
      content: const Text('Are you sure you want to delete this comment?'),
      actions: [
        TextButton(
          onPressed: onDeleteCancel,
          child: const Text('No'),
        ),
        TextButton(
          onPressed: onDeleteConfirm,
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
          child: const Text('Yes'),
        ),
      ],
    );

    return Column(
      children: [
        PopupMenuButton<SampleItem>(
          icon: const Icon(Icons.more_horiz),
          offset: const Offset(0, 40),
          initialValue: selectedMenu,
          // Callback that sets the selected popup menu item.
          onSelected: (SampleItem item) {
            // Open different dialogs based on the selected item
            if (item == SampleItem.Report) {

              showDialog(context: context, builder: 
              (BuildContext context) {
                return ReportModal( reportedId: widget.comment.id, reportedUser: widget.comment.commenter,
                   reportedContent: widget.comment.content, reportCollectionNameType: 4,
                    createdAt: widget.comment.createdAt, postId: widget.postId,
                );
              }
              );
             
            } else if (item == SampleItem.Edit) 
            {
              showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return EditCommentModal(originalComment: widget.comment, postType: widget.reportCollectionNameType, postId: widget.postId, callback: widget.callback);
                    },
                    isScrollControlled: true, // Takes up the whole screen
                    isDismissible: true,
                  );

            }
            else if (item == SampleItem.Delete)
            {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return deleteConfirmation;
                  },
                );
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
            customPopupMenuItem(SampleItem.Report, Icons.report, Colors.orange, 'Report'),
            if(userProvider.user!.user_id == widget.comment.commenter.user_id) 
              customPopupMenuItem(SampleItem.Edit, Icons.edit_note_rounded, Colors.orange, 'Edit'),
            if(userProvider.user!.user_id == widget.comment.commenter.user_id)
              customPopupMenuItem(SampleItem.Delete, Icons.delete_forever, Colors.red, 'Delete')
          ],
        ),
      ],
    );
  }

  PopupMenuItem<SampleItem> customPopupMenuItem(
      SampleItem value, IconData icon, Color color, String txt) {
    return PopupMenuItem<SampleItem>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8.0),
          Text(
            txt,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
