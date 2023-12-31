import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/providers/ConfessionProvider.dart';
import 'package:GUConnect/src/providers/UsabilityProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/widgets/bottom_bar.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:GUConnect/src/widgets/post.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class Confessions extends StatefulWidget {
  Confessions({super.key});
  bool _isLoading = false;

  @override
  State<Confessions> createState() => _ConfessionsState();
}

class _ConfessionsState extends State<Confessions> {
  late ConfessionProvider confessionsProvider;

  late List<Confession> posts;

  late UsabilityProvider usabilityProvider;
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    confessionsProvider =
        Provider.of<ConfessionProvider>(context, listen: false);

    userProvider = Provider.of<UserProvider>(context, listen: false);

    usabilityProvider = Provider.of<UsabilityProvider>(context, listen: false);
    posts = [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // When it comes back to view
    setState(() {
      widget._isLoading = true;
    });
    fetchPosts(confessionsProvider).then((_) {
      setState(() {
        widget._isLoading = false;
      });
    });
  }

  Future fetchPosts(ConfessionProvider provider) async {
    provider.getConfessions().then((value) => {
          setState(() {
            posts = value;
            posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          })
        });
  }

  Future<void> _refresh() async {
    fetchPosts(confessionsProvider);
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(context) {
    final IconButton addPost = IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(CustomRoutes.addConfessions);
        usabilityProvider.logEvent(
            userProvider.user!.email, 'Open_Add_Confessions_Screen');
      },
      icon: Icon(Icons.add_box_outlined,
          color: Theme.of(context).colorScheme.onBackground, size: 24),
    );
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: CustomAppBar(
        title: 'Confessions',
        actions: [addPost],
      ),
      body: widget._isLoading
          ? const Loader()
          : posts.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: RefreshIndicator(
                      onRefresh: _refresh,
                      child: NotificationListener<UserScrollNotification>(
                        onNotification: (notification) {
                          if (notification.direction ==
                              ScrollDirection.forward) {
                            usabilityProvider.logEvent(userProvider.user!.email,
                                'Scroll_Up_Confessions_Screen');
                          } else if (notification.direction ==
                              ScrollDirection.reverse) {
                            usabilityProvider.logEvent(userProvider.user!.email,
                                'Scroll_Down_Confessions_Screen');
                          }
                          return false; // Return false to allow the notification to continue to be dispatched.
                        },
                        child: ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  PostW(
                                    post: posts[index],
                                    postType: 3,
                                    refresh: _refresh,
                                  ),
                                ],
                              );
                            }),
                      ),
                    ))
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      'Looks like Confessions these days.?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                          ),
                    ),
                  ),
                ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
