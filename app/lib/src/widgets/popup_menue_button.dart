import 'package:GUConnect/routes.dart';
import 'package:flutter/material.dart';

// This is the type used by the popup menu below.
enum SampleItem { itemOne, itemTwo }

class PopupMenu extends StatefulWidget {
  const PopupMenu({super.key});

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
          initialValue: selectedMenu,
          // Callback that sets the selected popup menu item.
          onSelected: (SampleItem item) {
            setState(() {
              selectedMenu = item;
            });

            // Open different dialogs based on the selected item
            if (item == SampleItem.itemOne) {
              _showShareDialog(context);
            } else if (item == SampleItem.itemTwo) {
              _showReportDialog(context);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
            /*const PopupMenuItem<SampleItem>(
              value: SampleItem.itemOne,
              child: Text('Share'),
            ),*/
            const PopupMenuItem<SampleItem>(
              value: SampleItem.itemTwo,
              child: Text('Report'),
            ),
          ],
        ),
      ],
    );
  }

  // Function to show the Share dialog
  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog.adaptive(
        title: const Text('Share '),
        content: const Text('This is the Share dialog content.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Close', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  // Function to show the Report dialog
  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report'),
          content: const Text('Are you sure you want to report this content.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'No',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(CustomRoutes.report, arguments: {
                  'type': 'post',
                  'id': '1',
                });
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
