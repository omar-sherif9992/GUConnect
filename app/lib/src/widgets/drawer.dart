import 'package:GUConnect/routes.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  void onSelectScreen(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 10,
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/GUConnect-horizontal-Logo.png',
                  height: 100,
                  width: 220,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.remove_red_eye_outlined,
              size: 24,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Lost & Found',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              onSelectScreen(context, CustomRoutes.lostAndFound);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.remove_red_eye_outlined,
              size: 24,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'IMP Contacts',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              onSelectScreen(context, CustomRoutes.lostAndFound);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.search,
              size: 24,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Search',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              onSelectScreen(context, CustomRoutes.search);
            },
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.edit,
                    size: 24,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  title: Text(
                    'Edit Profile',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 24,
                        ),
                  ),
                  onTap: () {
                    onSelectScreen(context, CustomRoutes.profileEdit);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    size: 24,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  title: Text(
                    'Settings',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 24,
                        ),
                  ),
                  onTap: () {
                    onSelectScreen(context, CustomRoutes.settings);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
