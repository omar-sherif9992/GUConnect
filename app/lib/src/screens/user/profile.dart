import 'package:GUConnect/src/models/Post.dart';
import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/AcademicQuestionProvider.dart';
import 'package:GUConnect/src/providers/ConfessionProvider.dart';
import 'package:GUConnect/src/providers/LostAndFoundProvider.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/utils/titleCase.dart';
import 'package:GUConnect/src/widgets/bottom_bar.dart';
import 'package:GUConnect/src/widgets/drawer.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:GUConnect/src/widgets/post_widget.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late CustomUser user;
  late ConfessionProvider confessionProvider;
  late NewsEventClubProvider newsEventClubProvider;
  late LostAndFoundProvider lostAndFoundProvider;
  late AcademicQuestionProvider academicQuestionProvider;
  late UserProvider userProvider;
  late List<Object> clubPosts = [];
  late List<Object> lostPosts = [];
  late List<Object> academicPosts = [];
  late List<Object> confessions = [];
  late int postsCount = 0;
  @override
  Widget build(BuildContext context) {
    // function that gets user posts

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
                          margin: EdgeInsets.all(10),
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
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.network(
                              user?.image ?? 'https://picsum.photos/200/300',
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
                                  titleCase(user.fullName ?? ''),
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              // Text(

                              //   "EMS Prof",
                              //   style: TextStyle(
                              //     fontSize: 15.0,
                              //     fontWeight: FontWeight.w100,
                              //     color: Colors.grey,
                              //   ),
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (user.userType == 'staff')
                                    Container(
                                      width: 60,
                                      margin: const EdgeInsets.only(
                                          right: 10, top: 15),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        color:
                                            Color.fromARGB(255, 242, 200, 147),
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text(
                                        'C7\n203',
                                        style: TextStyle(
                                          fontSize: 13,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  Container(
                                    width: 60,
                                    margin: const EdgeInsets.only(
                                        right: 10, top: 15),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: const Color.fromARGB(
                                          255, 242, 200, 147),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '$postsCount\nPosts',
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  if (user.userType == 'staff')
                                    Container(
                                      width: 60,
                                      margin: const EdgeInsets.only(
                                          right: 10, top: 15),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        color: const Color.fromARGB(
                                            255, 242, 200, 147),
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text(
                                        'Rating\n4.7',
                                        style: TextStyle(
                                          fontSize: 13,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                ],
                              ),
                            ])
                      ],
                    ),
                    Text(user.biography ?? ''),
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
              _buildPosts(academicPosts),
              _buildPosts(lostPosts),
              _buildPosts(clubPosts),
              _buildPosts(confessions)
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildPosts(posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Post_Widget(posts[index]);
      },
    );
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
    } catch (e) {}
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

    user = userProvider.user!;
    fetchPosts(user.email);
    fetchConfessions(user.email);
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
