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
      width: 80,
      height: 27,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: getStatusColor(),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Text(
        pendingStatus,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10.0,
        ),
      ),
    );
  }
}
