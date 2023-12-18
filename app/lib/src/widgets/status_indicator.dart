import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final String pendingStatus;

  StatusIndicator({required this.pendingStatus});

  Color getStatusColor() {
    switch (pendingStatus.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'requested':
        return Colors.blue;
      case 'disapproved':
        return Colors.red;
      default:
        return Colors.grey; // Default color for unknown status
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: getStatusColor(),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        pendingStatus,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      ),
    );
  }
}
