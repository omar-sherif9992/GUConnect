import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAuthenticated;

  final String title;

  final List<Widget> actions;

  const CustomAppBar(
      {super.key,
      required this.title,
      required this.actions,
      required this.isAuthenticated});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(title),
      actions: <Widget>[
        ...actions,
        if (isAuthenticated == false)
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
      ],
    );
  }
}
