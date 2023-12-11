import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/screens/common/about.dart';
import 'package:GUConnect/src/widgets/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //bool _isDarkMode = false;
  bool _isNotification = true;
  var prefs;

  Future<void> getSwitchStates() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotification = prefs.getBool('_isNotification') ?? false;
    });
  }

  Future<void> updateIsNotificationinPref(val) async {
    prefs.setBool('_isNotification', val);
  }

  @override
  void initState() {
    super.initState();
    getSwitchStates();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              'About Us',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            subtitle: Text(
              'Learn more about us',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AboutScreen(),
                    maintainState: false,
                  ),
                );
              },
            ),
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          SwitchListTile.adaptive(
            value: _isNotification,
            onChanged: (isChecked) async {
              print(isChecked);

              await updateIsNotificationinPref(!_isNotification);
              setState(() {
                _isNotification = !_isNotification;
              });
            },
            title: Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            subtitle: Text(
              'Receive notifications about new events and updates',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            activeColor: Theme.of(context).colorScheme.primary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ),
          /*   SwitchListTile.adaptive(
            value: _isDarkMode,
            onChanged: (isChecked) {
              setState(() {
                _isDarkMode = isChecked;
              });
              // change theme to dark
            },
            title: Text(
              'Dark Mode',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            subtitle: Text(
              'Enable dark mode',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            activeColor: Theme.of(context).colorScheme.primary,
            contentPadding: const EdgeInsets.only(left: 34, right: 22),
          ), */
          const Divider(
            height: 0,
            thickness: 1,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    showAdaptiveDialog(
                        context: context,
                        anchorPoint: const Offset(0.0, 0.0),
                        builder: (context) {
                          return MessageDialog(
                            title: 'Logout',
                            message: 'Are you sure you want to logout?',
                            onApprove: () async {
                              await userProvider.logout();
                              Navigator.of(context)
                                  .popAndPushNamed(CustomRoutes.login);
                            },
                            onCancel: () {},
                          );
                        });
                  },
                  child: ListTile(
                    title: Text(
                      'Logout',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                    subtitle: Text(
                      'Logout from your account',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                    contentPadding: const EdgeInsets.only(left: 34, right: 22),
                  ),
                ),
                if (userProvider.user!.userType != UserType.admin)
                  InkWell(
                    onTap: () {
                      showAdaptiveDialog(
                          context: context,
                          anchorPoint: const Offset(0.0, 0.0),
                          builder: (context) {
                            return MessageDialog(
                              title: 'Delete Account',
                              message:
                                  'Are you sure you want to delete your account permenantly?',
                              onApprove: () async {
                                await userProvider.logout();
                                Navigator.of(context)
                                    .popAndPushNamed(CustomRoutes.login);
                              },
                              onCancel: () {},
                            );
                          });
                    },
                    child: ListTile(
                      title: Text(
                        'Delete Account',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                      subtitle: Text(
                        'Delete your account permenantly',
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                      ),
                      contentPadding:
                          const EdgeInsets.only(left: 34, right: 22),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
