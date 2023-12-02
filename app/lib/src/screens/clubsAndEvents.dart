import 'package:GUConnect/src/widgets/bottom_bar.dart';
import 'package:GUConnect/src/widgets/post.dart';
import 'package:GUConnect/src/dummy_data/posts.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/drawer.dart';
import 'package:flutter/material.dart';


class ClubsAndEvents extends StatelessWidget{

  const ClubsAndEvents({super.key});

  final String username = 'HusseinYasser';
  final String userImg = 'https://img.a.transfermarkt.technology/portrait/big/13902-1618409313.jpg?lm=1';

  @override
  Widget build(context)
  {
    
    final IconButton addPost = IconButton(
      onPressed: (){},
      icon: Icon(Icons.add_box_outlined,
        color: Theme.of(context).colorScheme.onBackground,
        size: 24),
      );

    return Scaffold(
      drawer: const MainDrawer(),
      appBar:  CustomAppBar(
        title: '',
        actions: [
          addPost
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(height: 20,),
                    PostW(
                      caption: posts[index].text,
                      imgUrl: posts[index].imageUrl ?? '',
                      username: username,
                      userImage: userImg,
                      likes: 500,
                      comments: posts[index].comments,
                    ),
                  ],
                );
                }
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}