import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mentionable_text_field/mentionable_text_field.dart';
import 'package:provider/provider.dart';

class MentionField extends StatefulWidget {
  const MentionField({super.key});

  @override
  State<MentionField> createState() => _MentionFieldState();
}

class _MentionFieldState extends State<MentionField> {
  List<Mentionable> _mentionableUsers = [];
  late void Function(Mentionable mentionable) _onSelectMention;
  late UserProvider userProvider;

  @override
  void initState()
  {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen:false);
  }

  final CustomUser posterPerson = CustomUser(
      email: 'hussein.ebrahim@student.guc.edu.eg',
      password: 'Don Ciristiane Ronaldo',
      image:
          'https://images.mubicdn.net/images/cast_member/25100/cache-2388-1688754259/image-w856.jpg',
      fullName: 'Mr Milad Ghantous',
      userName: 'Milad Ghantous');

  String content = '';

  @override
  Widget build(context) {
    return 
       SingleChildScrollView(
         child: Column(
          children: [
            if(_mentionableUsers.isNotEmpty)
              SizedBox(
                height: 150,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final mentionable = _mentionableUsers[index];
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(mentionable.mentionLabel),
                      onTap: () => _onSelectMention(mentionable),
                    );
                  },
                  itemCount: _mentionableUsers.length,
                ),
              ),
            Row(
              children: [
                CircleAvatar(
                    // User profile picture
                    radius: 15,
                    // Replace with your image URL
                    backgroundImage: CachedNetworkImageProvider(
                        userProvider.user?.image??''),
                  ),
                  const SizedBox(width: 10,),
                SizedBox(
                  width: 285,
                  child: MentionableTextField(
                    onControllerReady: (value) {
                      _onSelectMention = value.pickMentionable;
                    },
                    maxLines: 1,
                    onSubmitted: print,
                    mentionables: [posterPerson, posterPerson, posterPerson],
                    onMentionablesChanged: (mentionableUsers) => setState(() {
                      _mentionableUsers = mentionableUsers;
                    }),
                    decoration: const InputDecoration(hintText: 'Type something ...'),
                    mentionStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.send, color: Theme.of(context).colorScheme.primary,),
              ],
            ),
            
          ],
               ),
       );
  }
}
