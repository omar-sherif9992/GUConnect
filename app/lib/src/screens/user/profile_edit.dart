import 'dart:io';

import 'package:GUConnect/src/screens/user/profile_edit_form.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/email_field.dart';
import 'package:GUConnect/src/widgets/user_image_picker.dart';
import 'package:GUConnect/themes/sizes.dart';
import 'package:flutter/material.dart';

class ProfileEdit extends StatelessWidget {
  const ProfileEdit({super.key});
  void onPickImage(File pickedImage) {}

  @override
  Widget build(BuildContext context) {
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
            UserImagePicker(onPickImage: onPickImage),
            const SizedBox(
              height: Sizes.medium,
            ),
            SizedBox(height: 500, child: ProfileEditForm()),
          ],
        ),
      ),
    );
  }
}
