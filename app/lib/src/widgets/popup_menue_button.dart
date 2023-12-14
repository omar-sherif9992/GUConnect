import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/widgets/report_modal.dart';
import 'package:flutter/material.dart';

// This is the type used by the popup menu below.
enum SampleItem { Report, Edit, Delete }

class PopupMenu extends StatefulWidget {
  final String reportedId;
  final CustomUser reportedUser;
  final String reportedContent;
  final int reportCollectionNameType;
  final DateTime createdAt;
  final String image;
  const PopupMenu({super.key, required this.reportedId, required this.reportedUser, required this.reportedContent, required this.reportCollectionNameType,
   required this.image, required this.createdAt});

  @override
  State<PopupMenu> createState() => _PopupMenuState();
}



class _PopupMenuState extends State<PopupMenu> {
  SampleItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
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
                  image: widget.image, reportedId: widget.reportedId, reportedUser: widget.reportedUser,
                   reportedContent: widget.reportedContent, reportCollectionNameType: widget.reportCollectionNameType,
                    createdAt: widget.createdAt
                );
              }
              );
             
            } else if (item == SampleItem.Edit) 
            {
              //What are you goind to do here???
             
              

              
            }
            else if (item == SampleItem.Delete)
            {

            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
            customPopupMenuItem(SampleItem.Report, Icons.report, Colors.orange, 'Report'),
            customPopupMenuItem(SampleItem.Edit, Icons.edit_note_rounded, Colors.orange, 'Edit'),
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


  void _submitReport()
  {

  }
}
