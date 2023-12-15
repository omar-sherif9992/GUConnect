import 'dart:io';

import 'package:GUConnect/src/models/Course.dart';
import 'package:GUConnect/src/models/Staff.dart';
import 'package:GUConnect/src/providers/CourseProvider.dart';
import 'package:GUConnect/src/providers/StaffProvider.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/email_field.dart';
import 'package:GUConnect/src/widgets/input_field.dart';
import 'package:GUConnect/src/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
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
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  bool _isLoading = false;

  File? profileImageFile;
  String? profileImageUrl;

  void onPickImage(File pickedImage) {
    profileImageFile = pickedImage;
  }

  late StaffProvider staffProvider;
  late CourseProvider courseProvider;

  String dropdownvalue = StaffType.professor;

  final _formKey = GlobalKey<FormState>();

  final List<Course> _courses = [];
  List<String> selectedCourses = []; // To store the selected courses

  @override
  void initState() {
    super.initState();
    if (widget.staff != null) {
      _nameController.text = widget.staff!.fullName;
      _emailController.text = widget.staff!.email;
      _officeController.text = widget.staff!.officeLocation ?? '';
      dropdownvalue = widget.staff!.staffType;
      profileImageUrl = widget.staff!.image;
      _descriptionController.text = widget.staff!.description ?? '';
      _specialityController.text = widget.staff!.speciality ?? '';
      selectedCourses = widget.staff!.courses ?? [];
    }

    staffProvider = Provider.of<StaffProvider>(context, listen: false);

    courseProvider = Provider.of<CourseProvider>(context, listen: false);

    fetchCourses();
  }

  Future<void> fetchCourses() async {
    final tempCourses = await courseProvider.getCourses();

    setState(() {
      _courses.addAll(tempCourses);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _officeController.dispose();
    _descriptionController.dispose();
    _specialityController.dispose();
    super.dispose();
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 900,
              child: Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UserImagePicker(
                          onPickImage: onPickImage,
                          profileImageUrl: profileImageUrl),
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
                            return 'Please enter a valid office location ex: C7.201';
                          }
                          if (!RegExp(r'^[A-Z][0-9]\.[0-9]{3}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid office location ex: C7.201';
                          }

                          return null;
                        },
                      ),
                      InputField(
                        controller: _specialityController,
                        label: 'Speciality',
                        icon: Icons.work,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid speciality ex: Computer Science';
                          }

                          return null;
                        },
                      ),
                      InputField(
                        controller: _descriptionController,
                        label: 'Description',
                        icon: Icons.description,
                        keyboardType: TextInputType.streetAddress,
                        validator: (value) {
                          return null;
                        },
                      ),
                      MultiSelectDialogField(
                        selectedItemsTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        initialValue: _courses
                            .where((element) =>
                                selectedCourses.contains(element.courseName))
                            .toList(),
                        buttonText: const Text('Select Courses'),
                        checkColor: Theme.of(context).colorScheme.primary,
                        title: const Text('Select Courses'),
                        cancelText: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                        confirmText: const Text(
                          'Confirm',
                          style: TextStyle(color: Colors.black),
                        ),
                        searchable: true,
                        buttonIcon: const Icon(Icons.arrow_drop_down_circle),
                        selectedColor: Theme.of(context).colorScheme.primary,
                        items: _courses
                            .map((e) => MultiSelectItem(e, e.courseName))
                            .toList(),
                        listType: MultiSelectListType.CHIP,
                        onConfirm: (values) {
                          selectedCourses =
                              values.map((e) => e.courseName).toList();
                        },
                      ),

/*                       // I want to add a multiselect field for selecting the courses that the staff member is teaching in flutter
                      MultiSelect(
                        buttonBarColor: Theme.of(context).colorScheme.secondary,
                        checkBoxColor: Theme.of(context).colorScheme.primary,
                        hintTextColor: Theme.of(context).colorScheme.primary,
                    
                        searchBoxFillColor: Theme.of(context).colorScheme.primary,
                        titleText: 'Select Courses',
                        validator: (value) {
                          print(value);
                          if (value == null || value.isEmpty) {
                            return 'Please select at least one course';
                          }
                          return null;
                        },
                        dataSource: _courses
                            .map((course) => {
                                  'display': course.courseName +
                                      ': ' +
                                      course.description,
                                  'value': course.courseName
                                })
                            .toList(),
                        textField: 'display',
                        valueField: 'value',
                        filterable: true,
                        required: true,
                        value: selectedCourses,
                        onSaved: (value) {
                          setState(() {
                            selectedCourses = value;
                          });
                        },
                        selectIcon: Icons.arrow_drop_down_circle,
                        saveButtonColor: Theme.of(context).colorScheme.primary,
                        cancelButtonColor: Colors.grey,
                      ), */
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final Staff staff = Staff(
                                fullName: _nameController.text,
                                email: _emailController.text,
                                officeLocation: _officeController.text,
                                staffType: dropdownvalue,
                                description: _descriptionController.text,
                                speciality: _specialityController.text,
                                courses: selectedCourses,
                              );

                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                await staffProvider.setStaff(
                                  staff,
                                  profileImageFile,
                                );
                                Navigator.of(context).pop();
                              } catch (e) {
                                print(e);
                                setState(() {
                                  _isLoading = false;
                                });
                              }
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
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.3, 50),
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
        actions: [
          if (widget.staff != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final bool? confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text(
                        'Do you want to delete this staff member permanently?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );

                if (widget.staff != null && confirm == true) {
                  await staffProvider.deleteStaff(widget.staff!);

                  Navigator.of(context).pop({
                    'message': 'Staff deleted successfully',
                    'success': true,
                    'staff': widget.staff,
                  });
                }
              },
            )
        ],
      ),
      body: _buildForm(),
    );
  }
}
