import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/Usability.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/UsabilityProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/services/notification_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  void onSelectScreen(BuildContext context, String routeName) {
    UsabilityProvider usabilityProvider =
        Provider.of<UsabilityProvider>(context, listen: false);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    usabilityProvider.logEvent(
        userProvider.user!.email, 'Navigate_To_$routeName');
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    if (userProvider.user == null) {
      Navigator.of(context).popAndPushNamed('/login');
    }

    final CustomUser user = userProvider.user as CustomUser;
    // check if user is admin
    final bool isAdmin = user.userType == UserType.admin;

    final endCommonRoutes = Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ListTile(
            leading: Icon(
              Icons.edit,
              size: 20,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Edit Profile',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 20,
                  ),
            ),
            onTap: () {
              onSelectScreen(context, CustomRoutes.profileEdit);
            },
          ),
          /*   ListTile(
            title: Text(
              'Test Notifications',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () async {
              // await FirebaseNotification.sendLikeNotification(
              //     "Abdelrahman Fekri",
              //     FirebaseNotification.token!,
              //     "postId",
              //     "postType",
              //     "likerName");
              // await FirebaseNotification.sendPostApprovalNotification(
              //     "Abdelrahman Fekri",
              //     FirebaseNotification.token!,
              //     "postId",
              //     "postType",
              //     "approverName");
              // await FirebaseNotification.sendTagNotification("taggedUserName",
              //     FirebaseNotification.token!, "confessionId", "taggerName");
              // await FirebaseNotification.sendNotification(
              //     FirebaseNotification.token!, "Title", "Body");
            },
          ), */
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 20,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 20,
                  ),
            ),
            onTap: () {
              onSelectScreen(context, CustomRoutes.settings);
            },
          ),
        ],
      ),
    );
    final commonRoutes = [
      ListTile(
        leading: Icon(
          Icons.remove_red_eye_outlined,
          size: 20,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          'Lost & Found',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 20,
              ),
        ),
        onTap: () {
          onSelectScreen(context, CustomRoutes.lostAndFound);
        },
      ),
      ListTile(
        leading: Icon(
          Icons.contact_emergency,
          size: 20,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          'IMP Contacts',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 20,
              ),
        ),
        onTap: () {
          onSelectScreen(context, CustomRoutes.impPhoneNumber);
        },
      ),
      ListTile(
        leading: Icon(
          // office icon
          Icons.location_on_outlined,
          size: 20,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          'Offices and Outlets',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 20,
                
              ),
        ),
        onTap: () {
          onSelectScreen(context, CustomRoutes.officesAndOutlets);
        },
      ),
    ];

    final userRoutes = [
      ...commonRoutes,
      ListTile(
        leading: Icon(
          Icons.search,
          size: 20,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          'Search',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 20,
              ),
        ),
        onTap: () {
          onSelectScreen(context, CustomRoutes.search);
        },
      ),
      endCommonRoutes
    ];
    final adminRoutes = [
      ...commonRoutes,
      ListTile(
        leading: Icon(
          // office icon
          Icons.people_alt_outlined,
          size: 20,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          'Confessions',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 20,
              ),
        ),
        onTap: () {
          onSelectScreen(context, CustomRoutes.confessions);
        },
      ),
      ListTile(
        leading: Icon(
          Icons.person_search,
          size: 20,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          'Search Staff',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 20,
              ),
        ),
        onTap: () {
          onSelectScreen(context, CustomRoutes.adminStaff);
        },
      ),
      ListTile(
        leading: Icon(
          Icons.book,
          size: 20,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          'Search Courses',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 20,
              ),
        ),
        onTap: () {
          onSelectScreen(context, CustomRoutes.adminCourse);
        },
      ),
      endCommonRoutes
    ];

    final routes = isAdmin ? adminRoutes : userRoutes;

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
          ...routes
        ],
      ),
    );
  }
}
