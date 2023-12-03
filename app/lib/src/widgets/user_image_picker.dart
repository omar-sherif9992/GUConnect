import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  String? profileImageUrl;

  UserImagePicker({super.key, required this.onPickImage, this.profileImageUrl});

  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      pickedImageFile = File(pickedImage.path);
    });

    widget.onPickImage(File(pickedImage.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: _pickImage,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: const AssetImage('assets/images/user.png'),
                  onBackgroundImageError: (exception, stackTrace) =>
                      const AssetImage('assets/images/user.png'),
                  foregroundImage: (pickedImageFile != null)
                      ? FileImage(pickedImageFile!)
                      : (widget.profileImageUrl != null &&
                              widget.profileImageUrl!.isNotEmpty)
                          ? NetworkImage(widget.profileImageUrl!)
                              as ImageProvider<Object>?
                          : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: Icon(
                      Icons.camera_alt,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
