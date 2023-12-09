
import 'dart:io';

import 'package:GUConnect/src/models/LostAndFound.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/LostAndFoundProvider.dart';
import 'package:GUConnect/src/screens/lostAndFound.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:GUConnect/src/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddLostAndFoundPost extends StatefulWidget
{

  const AddLostAndFoundPost({super.key});

  @override
  State<AddLostAndFoundPost> createState() => _AddLostAndFoundPostState();
}

class _AddLostAndFoundPostState extends State<AddLostAndFoundPost> {
  final TextEditingController contentController = TextEditingController();

  final TextEditingController contactController = TextEditingController();

  File? _selectedImage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late LostAndFoundProvider lostProvider;

  @override
  void initState()
  {
    super.initState();
    lostProvider = Provider.of<LostAndFoundProvider>(context, listen: false);
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

  bool isCorrectNum(String val)
  {
    if(val.length != 12 || val[0] != '0')
    {
      return false;
    }
    return true;
  }

  Future<void> _getImage() async {
    
  }


  Future _addPost(
      LostAndFoundProvider provider, String content, String contact) async {
    const String imgUrl =
        'https://www.logodesignlove.com/wp-content/uploads/2012/08/microsoft-logo-02.jpeg';
    final CustomUser posterPerson = CustomUser(
        email: 'hussein.ebrahim@student.guc.edu.eg',
        password: 'Don Ciristiane Ronaldo',
        image:
            'https://images.mubicdn.net/images/cast_member/25100/cache-2388-1688754259/image-w856.jpg',
        userName: 'Mr Milad Ghantous', fullName: 'omar');

    final LostAndFound addedPost = LostAndFound(
        content: content,
        image: imgUrl,
        createdAt: DateTime.now(),
        user: posterPerson,
        contact: contact);

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

    provider.postItem(addedPost).then((value) {
          Navigator.pop(context);
          if (value)
            {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LostAndFoundW(),
                ),
              );
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
              );
            }
        });
  }

  @override
  Widget build(context)
  {
    final double containerHeight = calculateAspectRatio();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
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
                  'Content:',
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
                    hintText: 'What have you found .....',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
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
                              UserImagePicker(onPickImage: (File pickedImage) { 
      setState(() {
        _selectedImage = File(pickedImage.path);
    });
     },),
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
                Text(
                  'Your Contact:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || isCorrectNum(value)) {
                      return 'Please enter valid contact phone number';
                    }
                    return null;
                  },
                  controller: contactController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Contact phone number ...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Perform action when the user clicks the button
                      final String content = contentController.text;
                      final String contact = contactController.text;
                      _addPost(lostProvider, content, contact);
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