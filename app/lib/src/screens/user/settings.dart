import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/widgets/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Settings'),
      ),
      body: Column(
        children: [
          SwitchListTile.adaptive(
            value: true,
            onChanged: (isChecked) {},
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
          InkWell(
            onTap: () {
              showAdaptiveDialog(
                  context: context,
                  anchorPoint: const Offset(0.0, 0.0),
                  builder: (context) {
                    return MessageDialog(
                      title: 'Logout',
                      message: 'Are you sure you want to logout?',
                      onApprove: ()async {
                        await userProvider.logout();
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(CustomRoutes.login);
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
        ],
      ),
    );
  }
}
