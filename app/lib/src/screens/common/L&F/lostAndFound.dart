

import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/providers/LostAndFoundProvider.dart';
import 'package:GUConnect/src/providers/UsabilityProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/bottom_bar.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:GUConnect/src/widgets/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:GUConnect/src/models/LostAndFound.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class LostAndFoundW extends StatefulWidget
{

  const LostAndFoundW({super.key});

  @override
  State<LostAndFoundW> createState() => _LostAndFoundState();
}

class _LostAndFoundState extends State<LostAndFoundW> {

  bool _isLoading = true;

  late LostAndFoundProvider lostFoundProvider;
  late UserProvider userProvider;
  late UsabilityProvider usabilityProvider;

  List<LostAndFound> posts = [];

  @override
  void initState() {
    super.initState();

    lostFoundProvider =
        Provider.of<LostAndFoundProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    usabilityProvider = Provider.of<UsabilityProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // When it comes back to view
    _isLoading = true;
    fetchPosts(lostFoundProvider).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future fetchPosts(LostAndFoundProvider provider) async {
    provider.getItems().then((value){
          setState(() {
            posts = value;
          });
        });
  }

  Future<void> _refresh() async {
    fetchPosts(lostFoundProvider);
    await Future.delayed(const Duration(seconds: 2));
  }




  @override
  Widget build(context)
  {
    final IconButton addPost = IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(CustomRoutes.addLostAndFound);
        usabilityProvider.logEvent(userProvider.user!.email,
            'Open_Add_Lost_And_Found_Screen');
      },
      icon: Icon(Icons.add_box_outlined,
          color: Theme.of(context).colorScheme.onBackground, size: 24),
    );

    return
    Scaffold(
      appBar: CustomAppBar(
        title: 'Lost and Found',
        isLogo: false,
        actions: [addPost],
      ),
      body:
     _isLoading? const Loader() 
    :
    RefreshIndicator.adaptive(
      onRefresh: _refresh,
      child:
      posts.isEmpty? 
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      'People are cautios right?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                          ),
                    ),
                  ),
                )
                :
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child:NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            usabilityProvider.logEvent(userProvider.user!.email,
                'Scroll_Up_Lost_And_Found_Screen'); 
          } else if (notification.direction == ScrollDirection.reverse) {
            usabilityProvider.logEvent(userProvider.user!.email,
                'Scroll_Down_Lost_And_Found_Screen');
          }
          return false; // Return false to allow the notification to continue to be dispatched.
        },
        child:  ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  PostW(
                                    post: posts[index],
                                    postType: 1,
                                    refresh: _refresh,
                                  ),
                                ],
                              );
                            }),
                    ))

                ],)

    ),
    bottomNavigationBar: const BottomBar(),
    );



  }
}