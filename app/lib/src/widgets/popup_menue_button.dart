import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/AcademicQuestion.dart';
import 'package:GUConnect/src/models/LostAndFound.dart';
import 'package:GUConnect/src/models/NewsEventClub.dart';
import 'package:GUConnect/src/models/Post.dart';
import 'package:GUConnect/src/providers/AcademicQuestionProvider.dart';
import 'package:GUConnect/src/providers/LostAndFoundProvider.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/screens/common/AcademicRelated/editAcademicPost.dart';
import 'package:GUConnect/src/screens/common/L&F/editLostAndFoundPost.dart';
import 'package:GUConnect/src/screens/common/newsEvents/editPostClubs.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:GUConnect/src/widgets/report_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// This is the type used by the popup menu below.
enum SampleItem { Report, Edit, Delete }

class PopupMenu extends StatefulWidget {
  final Post post;
  final int reportCollectionNameType;
  const PopupMenu({super.key, required this.post, required this.reportCollectionNameType});

  @override
  State<PopupMenu> createState() => _PopupMenuState();
}



class _PopupMenuState extends State<PopupMenu> {
  SampleItem? selectedMenu;

  late UserProvider userProvider;

  @override
  void initState()
  {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  void onDeleteConfirm() async
  {
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
              Text('Deleting Post...'),
            ],
          ),
        );
      },
    );
      switch(widget.reportCollectionNameType)
      {
        case 0:
        Provider.of<NewsEventClubProvider>(context, listen: false).deletePost(widget.post.id).then((v){
          Navigator.of(context).pop();   
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(CustomRoutes.clubsAndEvents);
        });return;
        case 1:
        Provider.of<LostAndFoundProvider>(context, listen: false).deleteItem(widget.post.id).then((v){
          Navigator.of(context).pop();   
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(CustomRoutes.lostAndFound);
        });return;
        case 2:
        Provider.of<AcademicQuestionProvider>(context, listen: false).deleteQuestion(widget.post.id).then((v){
          
          Navigator.of(context).pop();   
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(CustomRoutes.academicRelatedQuestions);
        });return;
      }
      
        
  }

  void onDeleteCancel()
  {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    
    final Widget deleteConfirmation = AlertDialog(
      title: const Text('Delete Post'),
      content: const Text('Are you sure you want to delete this post?'),
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
                return ReportModal(
                  image: widget.post.image, reportedId: widget.post.id, reportedUser: widget.post.sender,
                   reportedContent: widget.post.content, reportCollectionNameType: widget.reportCollectionNameType,
                    createdAt: widget.post.createdAt
                );
              }
              );
             
            } else if (item == SampleItem.Edit) 
            {
              //What are you goind to do here???
              switch(widget.reportCollectionNameType){
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPostClub(initialPost: widget.post as NewsEventClub),
                    ),
                  ); return;

                case 1: 
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditLFPost(initialPost: widget.post as LostAndFound),
                    ),
                  ); return;
                case 2: 
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditAcademicPost(initialPost: widget.post as AcademicQuestion),
                    ),
                  ); return;
                //go here for the confession as well
              }
              

              
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
            if(userProvider.user!.user_id == widget.post.sender.user_id) 
              customPopupMenuItem(SampleItem.Edit, Icons.edit_note_rounded, Colors.orange, 'Edit'),
            if(userProvider.user!.user_id == widget.post.sender.user_id)
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
