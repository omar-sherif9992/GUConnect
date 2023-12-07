import 'package:GUConnect/routes.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AdminBottomBar extends StatelessWidget {
  const AdminBottomBar({super.key});

  @override
  Widget build(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, CustomRoutes.admin);
          },
          icon: Icon(
            Icons.home_outlined,
            color: Theme.of(context).colorScheme.onBackground,
            size: 28,
          ),
        ), // Your home icon or any other icon
        Transform.translate(
          offset: const Offset(
              0, -17), // Adjust the Y offset to shift the diamond icon up
          child: Transform.rotate(
            angle: pi / 4,
            child: Container(
              height: 55,
              width: 67,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Theme.of(context).colorScheme.primary,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    const Color.fromARGB(255, 244, 200, 133),
                  ],
                ),
              ),
              child: Transform.rotate(
                  angle: -pi / 4,
                  child: Icon(
                    Icons.search_outlined,
                    color: Theme.of(context).colorScheme.onSecondary,
                    size: 32,
                  )),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, CustomRoutes.adminNotifications);
          },
          icon: Icon(
            Icons.notifications_outlined,
            color: Theme.of(context).colorScheme.onBackground,
            size: 28,
          ),
        ),
        // Another icon in the bottom bar
      ],
    );
  }
}
