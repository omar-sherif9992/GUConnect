import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/NewsEventClub.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/widgets/bottom_bar.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:GUConnect/src/widgets/post.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClubsAndEvents extends StatefulWidget {
  const ClubsAndEvents({super.key});

  @override
  State<ClubsAndEvents> createState() => _ClubsAndEventsState();
}

class _ClubsAndEventsState extends State<ClubsAndEvents> {
  final CustomUser posterPerson = CustomUser(
      email: 'hussein.ebrahim@student.guc.edu.eg',
      password: 'Don Ciristiane Ronaldo',
      image:
          'https://images.mubicdn.net/images/cast_member/25100/cache-2388-1688754259/image-w856.jpg',
      userName: 'HusseinYasser',
      fullName: 'omar');

  late NewsEventClubProvider clubPostProvider;

  List<NewsEventClub> posts = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    clubPostProvider =
        Provider.of<NewsEventClubProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // When it comes back to view
    _isLoading = true;
    fetchPosts(clubPostProvider).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future fetchPosts(NewsEventClubProvider provider) async {
    provider.getApprovedPosts().then((value) => {
          setState(() {
            posts = value;
            posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          })
        });
  }

  Future<void> _refresh() async {
    await fetchPosts(clubPostProvider);
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(context) {
    final IconButton addPost = IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(CustomRoutes.addClubPost);
      },
      icon: Icon(Icons.add_box_outlined,
          color: Theme.of(context).colorScheme.onBackground, size: 24),
    );

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: CustomAppBar(
        title: '',
        actions: [addPost],
      ),
      body: _isLoading
          ? const Loader()
          : posts.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RefreshIndicator.adaptive(
                        onRefresh: _refresh,
                        child: ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  PostW(
                                    post:posts[index],
                                    postType: 0,
                                    refresh: _refresh,
                                  ),
                                ],
                              );
                            }),
                      ),
                    )
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      "Looks like it's a quiet day here. Why not break the silence with a new post?",
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

  @override
  void dispose() {
    super.dispose();
  }
}
