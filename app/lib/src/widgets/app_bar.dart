import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final List<Widget> actions;
  final bool isLogo;

  const CustomAppBar(
      {super.key,
      required this.title,
      this.isLogo = true,
      this.actions = const []});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      title: isLogo
          ? Center(
              child: Image.asset(
                alignment: Alignment.center,
                'assets/images/logo-icon.png',
                height: 30,
                fit: BoxFit.fitHeight,
              ),
            )
          : Text(title),
      actions: <Widget>[
        ...actions,
      ],
    );
  }
}
