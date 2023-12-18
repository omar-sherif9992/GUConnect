import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:mentionable_text_field/mentionable_text_field.dart';
import 'package:provider/provider.dart';

class MentionField extends StatefulWidget {
  MentionField({super.key, required this.callback, required this.users});

  final void Function(String) callback;

  final List<CustomUser> users;

  @override
  State<MentionField> createState() => _MentionFieldState();
}

class _MentionFieldState extends State<MentionField> {
  
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
       FlutterMentions(
         onMarkupChanged: (val){widget.callback(val);},
         suggestionPosition: SuggestionPosition.Top,
         maxLines: 5,
         minLines: 1,
         decoration: const InputDecoration(hintText: 'Would you like to mention somebody?'),
         mentions: [
           Mention(
               trigger: '@',
               style: const TextStyle(
                 color: Colors.amber,
               ),
               data: widget.users.map((e) => {
                 'id': e.user_id,
                 'display': e.userName??'',
                 'photo': e.image??''
               }).toList(),
               matchAll: false,
               suggestionBuilder: (data) {
                 return Container(
                   padding: const EdgeInsets.all(10.0),
                   child: Row(
                     children: <Widget>[
                       CircleAvatar(
                         backgroundImage: NetworkImage(
                           data['photo'],
                         ),
                       ),
                       const SizedBox(
                         width: 20.0,
                       ),
                       Text('@${data['display']}'),
                     ],
                   ),
                 );
               }),
         ],
       );
  }
}
