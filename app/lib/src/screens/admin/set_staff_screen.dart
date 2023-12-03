import 'dart:io';

import 'package:GUConnect/src/models/Staff.dart';
import 'package:GUConnect/src/providers/StaffProvider.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/email_field.dart';
import 'package:GUConnect/src/widgets/input_field.dart';
import 'package:GUConnect/src/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetStaffScreen extends StatefulWidget {
  final Staff? staff;
  const SetStaffScreen({super.key, this.staff});

  @override
  State<SetStaffScreen> createState() => _SetStaffScreenState();
}

class _SetStaffScreenState extends State<SetStaffScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _officeController = TextEditingController();

  File? profileImageFile;
  String? profileImageUrl;

  void onPickImage(File pickedImage) {
    profileImageFile = pickedImage;
  }

  late StaffProvider staffProvider;

  String dropdownvalue = StaffType.professor;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.staff != null) {
      _nameController.text = widget.staff!.fullName;
      _emailController.text = widget.staff!.email;
      _officeController.text = widget.staff!.officeLocation ?? '';
      dropdownvalue = widget.staff!.staffType;
      profileImageUrl = widget.staff!.image;
    }

    staffProvider = Provider.of<StaffProvider>(context, listen: false);
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 500,
              child: Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UserImagePicker(
                          onPickImage: onPickImage,
                          profileImageUrl: profileImageUrl),
                      InputField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter full name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                      ),
                      EmailField(
                        emailController: _emailController,
                      ),
                      InputField(
                        controller: _officeController,
                        label: 'Office Location',
                        icon: Icons.location_on,
                        keyboardType: TextInputType.streetAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an office location';
                          }
                          return null;
                        },
                      ),
                      DropdownButton(
                        value: dropdownvalue,

                        icon: const Icon(Icons.keyboard_arrow_down),
                        iconSize: 24,
                        borderRadius: BorderRadius.circular(10),
                        alignment: Alignment.centerLeft,
                        hint: const Text('Select Staff Type'),

                        items: [StaffType.professor, StaffType.ta]
                            .map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final Staff staff = Staff(
                              fullName: _nameController.text,
                              email: _emailController.text,
                              officeLocation: _officeController.text,
                              staffType: dropdownvalue,
                            );

                            await staffProvider.setStaff(
                              staff,
                              profileImageFile,
                            );
                            Navigator.of(context).pop();
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
                        child: const Text('Submit'),
                      )
                    ]),
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.staff == null ? 'Add Staff' : 'Edit Staff',
        isLogo: false,
      ),
      body: _buildForm(),
    );
  }
}
