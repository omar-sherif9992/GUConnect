import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/ConfessionProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/screens/common/confessions/confessions.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddConfessionsPost extends StatefulWidget {
  const AddConfessionsPost({super.key});

  @override
  State<AddConfessionsPost> createState() => _AddConfessionsPostState();
}

class _AddConfessionsPostState extends State<AddConfessionsPost> {
  late UserProvider userProvider;
  final TextEditingController contentController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late ConfessionProvider confessionsProvider;
  bool _isAnonymous = true;

  @override
  void initState() {
    super.initState();

    confessionsProvider =
        Provider.of<ConfessionProvider>(context, listen: false);

    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  Future _addPost(ConfessionProvider provider, String content) async {
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
              Text('Uploading Confession...'),
            ],
          ),
        );
      },
    );

    final CustomUser anonymous = CustomUser(
        email: 'anynonymous@gmail.com',
        password: '12345678',
        image:
            'https://images.mubicdn.net/images/cast_member/25100/cache-2388-1688754259/image-w856.jpg',
        userName: 'Anonymous',
        fullName: 'Anonymous');

    final Confession addedPost = Confession(
      isAnonymous: _isAnonymous,
      content: content,
      createdAt: DateTime.now(),
      sender: _isAnonymous ? anonymous : userProvider.user ?? anonymous,
    );

    provider.addConfession(addedPost).then((value) => {
          Navigator.pop(context),
          if (value)
            {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Confessions(),
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
                    content: const Text(
                        'Failed to upload confession. Please try again.'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Confession'),
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
                  'Confession:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the confession content';
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
                const SizedBox(
                  height: 24,
                ),
                // check box
                Row(
                  children: [
                    Checkbox(
                      value: _isAnonymous,
                      onChanged: (value) {
                        setState(() {
                          _isAnonymous = value ?? false;
                        });
                      },
                    ),
                    const Text(
                      'post anonymously',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Perform action when the user clicks the button
                      final String content = contentController.text;
                      _addPost(confessionsProvider, content);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.onSecondary),
                  ),
                  child: const Text('Add Confession',
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
