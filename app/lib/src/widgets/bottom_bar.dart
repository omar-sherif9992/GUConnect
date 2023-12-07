import 'package:GUConnect/routes.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(context) {
    // check if user is admin
    bool isAdmin = false;

    // check which page is active
    bool isActive(String routeName) {
      return routeName == ModalRoute.of(context)!.settings.name;
    }

    final adminRoutes = [
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, CustomRoutes.admin);
        },
        icon: Icon(
          Icons.home_outlined,
          color: isActive(CustomRoutes.admin)
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onBackground,
          size: 28,
        ),
      ),
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, CustomRoutes.admin);
        },
        icon: Icon(
          Icons.receipt,
          color: isActive(CustomRoutes.adminReports)
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onBackground,
          size: 28,
        ),
      ),
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
                  Icons.confirmation_num_outlined,
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
          color: isActive(CustomRoutes.adminNotifications)
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onBackground,
          size: 28,
        ),
      ),
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, CustomRoutes.profile);
        },
        icon: Icon(
          Icons.person_outline,
          color: isActive(CustomRoutes.profile)
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onBackground,
          size: 28,
        ),
      ),
    ];

    final userRoutes = [
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, CustomRoutes.home);
        },
        icon: Icon(
          Icons.home_outlined,
          color: isActive(CustomRoutes.home)
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onBackground,
          size: 28,
        ),
      ),
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, CustomRoutes.confessions);
        },
        icon: Icon(
          Icons.people_outline_rounded,
          color: isActive(CustomRoutes.confessions)
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onBackground,
          size: 28,
        ),
      ),
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
          Navigator.pushNamed(context, CustomRoutes.notifications);
        },
        icon: Icon(
          Icons.notifications_outlined,
          color: isActive(CustomRoutes.notifications)
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onBackground,
          size: 28,
        ),
      ),
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, CustomRoutes.profile);
        },
        icon: Icon(
          Icons.person_outline,
          color: isActive(CustomRoutes.profile)
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onBackground,
          size: 28,
        ),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: isAdmin ? adminRoutes : userRoutes,
    );
  }
}
