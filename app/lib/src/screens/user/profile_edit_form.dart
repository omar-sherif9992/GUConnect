import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/user_provider.dart';
import 'package:GUConnect/src/widgets/email_field.dart';
import 'package:GUConnect/src/widgets/input_field.dart';
import 'package:GUConnect/src/widgets/password_field.dart';
import 'package:GUConnect/src/widgets/phone_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileEditForm extends StatelessWidget {
  final TextEditingController emailController =
      TextEditingController(text: 'omar');
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late final CustomUser user;

  ProfileEditForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    if (userProvider.user == null) {
      Navigator.of(context).popAndPushNamed('/login');
    }

    user = userProvider.user as CustomUser;

    fullNameController.text = user.fullName ?? '';
    userNameController.text = user.userName ?? '';
    emailController.text = user.email;
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
                  if (value!.isEmpty) {
                    return 'Enter your full name';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.name,
              ),
              EmailField(emailController: emailController),
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
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );

                          await userProvider.updateProfile(
                              fullName: fullNameController.text,
                              userName: userNameController.text,
                              phoneNumber: phoneController.text,
                              biography: bioController.text);

                          await userProvider.updateEmail(emailController.text);

                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
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
