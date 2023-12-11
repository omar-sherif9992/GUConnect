import 'dart:io';

import 'package:GUConnect/src/models/AcademicQuestion.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/AcademicQuestionProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/screens/common/clubsAndEvents.dart';
import 'package:GUConnect/src/utils/uploadImageToStorage.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddAcademicPost extends StatefulWidget {
  const AddAcademicPost({super.key});

  @override
  State<AddAcademicPost> createState() => _AddAcademicPostState();
}

class _AddAcademicPostState extends State<AddAcademicPost> {

  late UserProvider userProvider;
  final TextEditingController contentController = TextEditingController();
  File? _selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AcademicQuestionProvider academicProvider;

  @override
  void initState() {
    super.initState();

    academicProvider =
        Provider.of<AcademicQuestionProvider>(context, listen: false);

    userProvider =
        Provider.of<UserProvider>(context, listen: false);
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
  }

  double calculateAspectRatio() {
    if (_selectedImage == null) {
      return 100.0; // Default aspect ratio
    }

    final image = Image.file(_selectedImage!);
    return MediaQuery.of(context).size.width /
        (image.width ?? 1.0 / (image.height ?? 1.0));
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future _addPost(
      AcademicQuestionProvider provider, String content, File img) async {

      showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Loader(),
              SizedBox(height: 16),
              Text('Uploading post...'),
            ],
          ),
        );
      },
    );
    
        final String? imageUrl = await uploadImageToStorage(
              img, 'post_images', userProvider.user!.user_id! + DateTime.now().toString());

    final CustomUser posterPerson = CustomUser(
        email: 'hussein.ebrahim@student.guc.edu.eg',
        password: 'Don Ciristiane Ronaldo',
        image:
            'https://images.mubicdn.net/images/cast_member/25100/cache-2388-1688754259/image-w856.jpg',
        userName: 'Mr Milad Ghantous',
        fullName: 'omar');

    final AcademicQuestion addedPost = AcademicQuestion(
        content: content,
        image: imageUrl??'',
        createdAt: DateTime.now(),
        sender: userProvider.user??posterPerson,);

    

    provider.askQuestion(addedPost).then((value) => {
          Navigator.pop(context),
          if (value)
            {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClubsAndEvents(),
                ),
              )
            }
          else
            {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content:
                        const Text('Failed to upload post. Please try again.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              )
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    final double containerHeight = calculateAspectRatio();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask Question'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Post:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the post content';
                    }
                    return null;
                  },
                  controller: contentController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'What is on your mind .....',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _getImage,
                  child: Container(
                    height: containerHeight,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _selectedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload,
                                  size: 50,
                                  color: Theme.of(context).colorScheme.primary),
                              const SizedBox(height: 8),
                              Text('Upload an Image',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                            ],
                          )
                        : Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(_selectedImage!,
                                    fit: BoxFit.cover),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.black),
                                onPressed: _removeImage,
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Perform action when the user clicks the button
                      final String content = contentController.text;
                      _addPost(academicProvider, content, _selectedImage??File(''));
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.onSecondary),
                  ),
                  child: const Text('Add Post',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
