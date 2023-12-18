
import 'dart:io';

import 'package:GUConnect/src/models/LostAndFound.dart';
import 'package:GUConnect/src/models/Usability.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/LostAndFoundProvider.dart';
import 'package:GUConnect/src/providers/UsabilityProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/screens/common/L&F/lostAndFound.dart';
import 'package:GUConnect/src/utils/uploadImageToStorage.dart';
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

  late UserProvider userProvider;
  late UsabilityProvider usabilityProvider;

  @override
  void initState()
  {
    super.initState();
    lostProvider = Provider.of<LostAndFoundProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    usabilityProvider = Provider.of<UsabilityProvider>(context, listen: false);
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
    usabilityProvider.logEvent(userProvider.user!.email ,'Remove_Image_Add_Lost_And_Found');
    setState(() {
      _selectedImage = null;
    });
  }

  bool isNumeric(String val) {
    // Use a regular expression to check if all characters are numeric
    if(val == '') {
      return true;
    }
    return RegExp(r'^[0-9]+$').hasMatch(val);
  }

  bool isCorrectNum(String val)
  {
    if(val == '')
    {
      return true;
    }
    
    if(val.length != 11 || val[0] != '0')
    {
      return false;
    }
    return true;
  }

  Future<void> _getImage() async {
    
  }


  Future _addPost(
      LostAndFoundProvider provider, String content, String contact, File img) async {
        
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

    final String? imageUrl =  await uploadImageToStorage(
              img, 'post_images', userProvider.user!.user_id! + DateTime.now().toString());

    final LostAndFound addedPost = LostAndFound(
        content: content,
        image: imageUrl??'',
        createdAt: DateTime.now(),
        sender: userProvider.user!,
        contact: contact,
        likes: {},
        comments: []);

    

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
                              UserImagePicker(backgroundImageUrl: 'data:image/png;base64,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',
                              onPickImage: (File pickedImage) { 
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
                    if (!isCorrectNum(value??'') || !isNumeric(value??'')) {
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
                    if (_formKey.currentState?.validate() ?? true) {
                      // Perform action when the user clicks the button
                      final String content = contentController.text;
                      final String contact = contactController.text;
                      _addPost(lostProvider, content, contact, _selectedImage ?? File(''));
                    }
                    usabilityProvider.logEvent(userProvider.user!.email ,'Add_Lost_And_Found_Post');
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