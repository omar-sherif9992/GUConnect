import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/ConfessionProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/screens/common/confessions/confessions.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:GUConnect/src/widgets/mention_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
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

  String mentionsValue = '';

  List<CustomUser> users = [];

  

  @override
  void initState() {
    super.initState();

    confessionsProvider =
        Provider.of<ConfessionProvider>(context, listen: false);

    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.getUsers().then((val){
      setState(() {
        for(int i = 0; i < val.length; ++i)
      {
        users.add(val[i].data() as CustomUser);
      }
      });
       }); 
  }

  Future _addPost(ConfessionProvider provider, String content, List<CustomUser> mentionedUsers) async {
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
      mentionedPeople: mentionedUsers,
      comments: [],
      likes: {}
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

  void mentionCallback(String val)
  {
      mentionsValue = val;
  }

  List<String> extractIdsFromMentions(String input) {
    final RegExp exp = RegExp(r'@\[__([^\]]+)__\]\(__[^\)]+__\)');
    final Iterable<RegExpMatch> matches = exp.allMatches(input);

    return matches.map((match) => match.group(1)!).toList();
  }

  List<CustomUser> filterUsersByMentionedIds(List<CustomUser> users, List<String> mentionedIds) {
    return users.where((user) => mentionedIds.contains(user.user_id)).toList();
  }

  void processMentions()
  {

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
          child: Portal(
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
                  MentionField(callback: mentionCallback, users: users),
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
                        final List<CustomUser> mentionedUsers = filterUsersByMentionedIds(users, extractIdsFromMentions(mentionsValue));
                        _addPost(confessionsProvider, content, mentionedUsers);
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
      ),
    );
  }
}
