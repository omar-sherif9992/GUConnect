// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/UsabilityProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/widgets/input_field.dart';
import 'package:GUConnect/src/widgets/password_field.dart';
import 'package:GUConnect/src/widgets/phone_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileEditForm extends StatefulWidget {
  final File? profileImageFile;

  const ProfileEditForm({
    super.key,
    this.profileImageFile,
  });

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController fullNameController = TextEditingController();

  // final TextEditingController userNameController = TextEditingController();

  final TextEditingController bioController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late UsabilityProvider usabilityProvider;

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    //usernameController.dispose();
    fullNameController.dispose();
    bioController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  void initState()
  {
    super.initState();
    usabilityProvider =
        Provider.of<UsabilityProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    

    if (userProvider.user == null) {
      Navigator.of(context).popAndPushNamed('/login');
    }

    final CustomUser user = userProvider.user as CustomUser;

    fullNameController.text = user.fullName ?? '';
    // userNameController.text = user.userName ?? '';
    bioController.text = user.biography ?? '';
    phoneController.text = user.phoneNumber ?? '';
    passwordController.text = user.password;

    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InputField(
                controller: fullNameController,
                label: 'Full Name',
                icon: Icons.person,
                validator: (value) {
                  // name should contain only letters and spaces and should not contain @ symbol validate it

                  if (value == null || value.isEmpty) {
                    return 'Enter your full name';
                  } else if (value.contains('@')) {
                    return 'Full name cannot contain @';
                  } else if (value!.contains(RegExp(r'[0-9]'))) {
                    return 'Full name cannot contain numbers';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.name,
              ),
              /*      InputField(
                controller: userNameController,
                label: 'User Name',
                icon: Icons.person,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your user name';
                  } else if (value.contains(' ')) {
                    return 'User name cannot contain spaces';
                  } else if (value.contains('@')) {
                    return 'User name cannot contain @';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.name,
              ), */
              PhoneInputField(
                controller: phoneController,
              ),
              InputField(
                controller: bioController,
                label: 'Bio',
                icon: Icons.person,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter a bio';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.multiline,
              ),
              PasswordField(
                passwordController: passwordController,
                hintText: 'Password',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter a password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  } else {
                    return null;
                  }
                },
              ),

              // edit button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                        onPressed: () async {
                          await usabilityProvider.logEvent(
                              userProvider.user!.email, 'Edit Profile');
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                            setState(() {
                              _isLoading = true;
                            });

                            await userProvider.updateProfile(
                                CustomUser.edit(
                                    fullName: fullNameController.text,
                                    phoneNumber: phoneController.text,
                                    biography: bioController.text),
                                widget.profileImageFile);

                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Profile Updated'),
                              ),
                            );
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onSecondary,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          // size 30% of screen width
                          minimumSize:
                              Size(MediaQuery.of(context).size.width * 0.3, 50),
                          alignment: Alignment.center,
                        ),
                        child: const Text('Edit Profile')),
                ],
              ),
            ],
          ),
        ));
  }
}
