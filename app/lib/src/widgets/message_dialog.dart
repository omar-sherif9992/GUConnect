import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  const MessageDialog(
      {super.key,
      required this.title,
      required this.message,
      this.onApprove,
      this.onCancel});

  final String title;
  final String message;
  final Function? onApprove;
  final Function? onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      semanticLabel: title,
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(message),
          ],
        ),
      ),
      actions: <Widget>[
        if (onCancel != null)
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              onCancel!();
              //Navigator.of(context).pop();
            },
          ),
        if (onApprove != null)
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              onApprove!();
              //Navigator.of(context).pop();
            },
          ),
      ],
    );
  }
}
