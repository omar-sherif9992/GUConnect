// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:GUConnect/src/models/Course.dart';
import 'package:GUConnect/src/providers/CourseProvider.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/input_field.dart';
import 'package:GUConnect/src/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetCourseScreen extends StatefulWidget {
  final Course? course;
  const SetCourseScreen({super.key, this.course});

  @override
  State<SetCourseScreen> createState() => _SetCourseScreenState();
}

class _SetCourseScreenState extends State<SetCourseScreen> {
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;

  File? profileImageFile;
  String? profileImageUrl;

  void onPickImage(File pickedImage) {
    profileImageFile = pickedImage;
  }

  late CourseProvider courseProvider;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.course != null) {
      _courseCodeController.text = widget.course!.courseCode;
      _courseNameController.text = widget.course!.courseName;
      _descriptionController.text = widget.course!.description;
    }

    courseProvider = Provider.of<CourseProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _courseCodeController.dispose();
    _courseNameController.dispose();
    _descriptionController.dispose();
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
              height: 500,
              child: Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UserImagePicker(
                        onPickImage: onPickImage,
                        profileImageUrl: profileImageUrl,
                        backgroundImageUrl: 'assets/images/course.png',
                      ),
                      InputField(
                        controller: _courseCodeController,
                        label: 'Course Code',
                        icon: Icons.book,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter course code';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                      ),
                      InputField(
                        controller: _courseNameController,
                        label: 'Course Name',
                        icon: Icons.book,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter course name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
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
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final Course course = Course(
                                courseCode: _courseCodeController.text,
                                courseName: _courseNameController.text,
                                description: _descriptionController.text,
                              );

                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                await courseProvider.setCourse(
                                  course,
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
        title: widget.course == null ? 'Add Course' : 'Edit Course',
        isLogo: false,
        actions: [
          if (widget.course != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final bool? confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text(
                        'Do you want to delete this course permanently?'),
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

                if (widget.course != null && confirm == true) {
                  await courseProvider.deleteCourse(widget.course!);

                  Navigator.of(context).pop({
                    'message': 'Course deleted successfully',
                    'success': true,
                    'course': widget.course!,
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
