import 'dart:io';

import 'package:GUConnect/src/providers/user_provider.dart';
import 'package:GUConnect/src/screens/user/profile_edit_form.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/user_image_picker.dart';
import 'package:GUConnect/themes/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  File? profileImage;

  void onPickImage(File pickedImage) {
    setState(() {
      profileImage = pickedImage;
    });
  }



  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    if (userProvider.user == null) {
      Navigator.of(context).popAndPushNamed('/login');
    }
    profileImage = userProvider.user?.image as File?;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Edit Profile',
        isAuthenticated: true,
        isLogo: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const SizedBox(
              height: Sizes.medium,
            ),
            const SizedBox(
              height: Sizes.medium,
            ),
            UserImagePicker(
                onPickImage: onPickImage, pickedImageFile: profileImage),
            const SizedBox(
              height: Sizes.medium,
            ),
            SizedBox(
                height: 500, child: ProfileEditForm(user: userProvider.user!)),
          ],
        ),
      ),
    );
  }
}
