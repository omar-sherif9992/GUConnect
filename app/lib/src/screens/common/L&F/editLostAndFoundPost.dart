import 'dart:io';

import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/LostAndFound.dart';
import 'package:GUConnect/src/models/NewsEventClub.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/CommentProvider.dart';
import 'package:GUConnect/src/providers/LostAndFoundProvider.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/utils/uploadImageToStorage.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditLFPost extends StatefulWidget {
  final LostAndFound initialPost;

  const EditLFPost({Key? key, required this.initialPost}) : super(key: key);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditLFPost> {
  late UserProvider userProvider;
  final TextEditingController contentController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  File? _selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late LostAndFoundProvider lostProvider;
  late CommentProvider commentProvider;

  @override
  void initState() {
    super.initState();

    lostProvider = Provider.of<LostAndFoundProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    commentProvider = Provider.of<CommentProvider>(context, listen: false);
    // Initialize form fields with initial values for editing
    contentController.text = widget.initialPost.content;
    contactController.text = widget.initialPost.contact;
    // You can set _selectedImage here if needed
    _selectedImage = widget.initialPost.image==''? null:File(widget.initialPost.image);
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

  Future<void> _updatePost(
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
              Text('Updating post...'),
            ],
          ),
        );
      },
    );

    // Perform the update logic here
    // Use widget.initialPost.id or any other identifier to update the correct post
    final String? imageUrl = await uploadImageToStorage(
              img, 'post_images', userProvider.user!.user_id! + DateTime.now().toString());
    final List<Comment> com = await commentProvider.getPostComments(widget.initialPost.id, 1);
    final LostAndFound updatedPost = LostAndFound(contact: contact, content: content, createdAt: widget.initialPost.createdAt, image: imageUrl??'', sender: widget.initialPost.sender,
    likes: widget.initialPost.likes, comments: com);
    provider.updatePost(
      updatedPost, widget.initialPost.id).then((success)
    { 
      if (success) {
      Navigator.pop(context);
    } else {
      // Handle update failure
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to update post. Please try again.'),
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

  bool isCorrectNum(String val)
  {
    if(val.length != 12 || val[0] != '0')
    {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final double containerHeight = calculateAspectRatio();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
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
                      _updatePost(lostProvider, content, contact, _selectedImage ?? File(''));
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.onSecondary),
                  ),
                  child: const Text('Edit Post',
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
