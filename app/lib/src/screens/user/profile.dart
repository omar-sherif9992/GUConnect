import 'dart:developer';

import 'package:GUConnect/src/models/AcademicQuestion.dart';
import 'package:GUConnect/src/models/LostAndFound.dart';
import 'package:GUConnect/src/models/NewsEventClub.dart';
import 'package:GUConnect/src/models/Post.dart';
import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/AcademicQuestionProvider.dart';
import 'package:GUConnect/src/providers/ConfessionProvider.dart';
import 'package:GUConnect/src/providers/LostAndFoundProvider.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/providers/UsabilityProvider.dart';
import 'package:GUConnect/src/utils/titleCase.dart';
import 'package:GUConnect/src/widgets/bottom_bar.dart';
import 'package:GUConnect/src/widgets/drawer.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:GUConnect/src/widgets/post.dart';
import 'package:flutter/material.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key, required this.user});

  CustomUser user;

  @override
  State<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  //late CustomUser user;
  late ConfessionProvider confessionProvider;
  late NewsEventClubProvider newsEventClubProvider;
  late LostAndFoundProvider lostAndFoundProvider;
  late AcademicQuestionProvider academicQuestionProvider;
  late UserProvider userProvider;
  late List<Post> clubPosts = [];
  late List<Post> lostPosts = [];
  late List<Post> academicPosts = [];
  late List<Post> confessions = [];
  late int postsCount = 0;

  late bool _isLoading = false;

  late UsabilityProvider usabilityProvider;

  String userTitle(CustomUser user) {
    String title = '';
    if (user.userType == UserType.student) {
      title = '(Student)';
    } else if (user.userType == UserType.staff) {
      title = '(Staff)';
    } else if (user.userType == UserType.admin) {
      title = '(Admin)';
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      drawer: const MainDrawer(),
      appBar: const CustomAppBar(title: 'Profile'),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 110.0,
                          height: 110.0,
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white, // White border color
                              width: 3.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: widget.user.image != null &&
                                    widget.user.image!.isNotEmpty
                                ? Image.network(
                                    widget.user.image ?? 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/user.png',
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 200,
                                child: Text(
                                  titleCase(widget.user.fullName ?? ''),
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(
                                  userTitle(widget.user),
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(
                                  "@${titleCase(widget.user.userName ?? '')} ",
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    margin: const EdgeInsets.only(
                                        right: 10, top: 15, left: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: const Color.fromARGB(
                                          255, 242, 200, 147),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${postsCount + confessions.length}\nPosts',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),                
                                ],
                              ),
                            ])
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8),
                      child: Text(
                        widget.user.biography ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(Icons.book),
                child: Text(
                  'Academic',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Tab(
                icon: Icon(Icons.shopping_basket),
                child: Text(
                  'L&F',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Tab(
                icon: Icon(Icons.group),
                child: Text(
                  'Club Posts',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Tab(
                  icon: Icon(Icons.message),
                  child: Text(
                    'Confessions',
                    style: TextStyle(fontSize: 10),
                  )),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: const Divider(
              color: Colors.grey,
              thickness: 1.0,
              height: 2.0,
            ),
          ),
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [
              _buildPosts(academicPosts, 'Academic Questions'),
              _buildPosts(lostPosts, 'Lost and Founds Items'),
              _buildPosts(clubPosts, 'Club Posts'),
              _buildPosts(confessions, 'Confession Posts')
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildPosts(List<Post> posts, String name) {
    return _isLoading
        ? const Loader()
        : posts.isEmpty
            ? Center(
                child: Text(
                  'No $name Found',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              )
            : RefreshIndicator.adaptive(
                onRefresh: () async {
                  await fetchAll();
                },
                child: NotificationListener<UserScrollNotification>(
                  onNotification: (notification) {
                    if (notification.direction == ScrollDirection.forward) {
                      usabilityProvider.logEvent(userProvider.user!.email,
                          'Scrolling_Up_In_Profile_Posts');
                    } else if (notification.direction ==
                        ScrollDirection.reverse) {
                      usabilityProvider.logEvent(userProvider.user!.email,
                          'Scrolling_Down_In_Profile_Posts');
                    }
                    return false; // Return false to allow the notification to continue to be dispatched.
                  },
                  child: ListView.builder(
                    itemCount: posts.length,
                    scrollDirection: Axis.vertical,
                    key: PageStorageKey('profile_posts$name'),
                    itemBuilder: (context, index) {
                      String pendingStatus = "";
                      if (posts[index] is NewsEventClub) {
                        pendingStatus =
                            (posts[index] as NewsEventClub).approvalStatus;
                      }

                      return Column(
                        children: [
                          PostW(
                            post: posts[index],
                            postType: getPostType(posts[index]),
                            pendingStatus: pendingStatus,
                          ),
                          const SizedBox(height: 40,),
                        ],
                      );
                    },
                  ),
              ));
  }

  Future<void> fetchPosts(
    String email,
  ) async {
    try {
      final List<Post> newsEventClub =
          (await newsEventClubProvider.getMyPosts(email)).cast<Post>();
      final List<Post> lostAndFound =
          (await lostAndFoundProvider.getMyItems(email)).cast<Post>();
      final List<Post> academicQuestions =
          (await academicQuestionProvider.getMyQuestions(email)).cast<Post>();
      newsEventClub.sort((a, b) =>
          (a as dynamic).createdAt.compareTo((b as dynamic).createdAt));
      lostAndFound.sort((a, b) =>
          (a as dynamic).createdAt.compareTo((b as dynamic).createdAt));
      academicQuestions.sort((a, b) =>
          (a as dynamic).createdAt.compareTo((b as dynamic).createdAt));
      setState(() {
        clubPosts = newsEventClub;
        lostPosts = lostAndFound;
        academicPosts = academicQuestions;
        postsCount = clubPosts.length + lostPosts.length + academicPosts.length;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchConfessions(
    String email,
  ) async {
    try {
      final List<Confession> c =
          await confessionProvider.getMyConfessions(email);
      setState(() {
        confessions = c;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    confessionProvider =
        Provider.of<ConfessionProvider>(context, listen: false);
    newsEventClubProvider =
        Provider.of<NewsEventClubProvider>(context, listen: false);
    lostAndFoundProvider =
        Provider.of<LostAndFoundProvider>(context, listen: false);
    academicQuestionProvider =
        Provider.of<AcademicQuestionProvider>(context, listen: false);
    usabilityProvider = Provider.of<UsabilityProvider>(context, listen: false);

    //user = userProvider.user!;
    fetchAll();

    log(widget.user.email);
  }

  Future<void> fetchAll() async {
    setState(() {
      _isLoading = true;
    });

    await fetchPosts(widget.user.email);
    await fetchConfessions(widget.user.email);
    setState(() {
      _isLoading = false;
    });
  }

  getPostType(Post post) {
    if (post is NewsEventClub) {
      return 0;
    } else if (post is LostAndFound) {
      return 1;
    } else if (post is AcademicQuestion) {
      return 2;
    } else if (post is Confession) {
      return 3;
    }
  }
}

class ClickableIcon extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final VoidCallback onTap;

  const ClickableIcon(this.icon, this.labelText, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20.0,
              color: Colors.black,
            ),
            const SizedBox(height: 8.0),
            Text(
              labelText,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
