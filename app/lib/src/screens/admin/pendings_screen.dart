import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/AcademicQuestion.dart';
import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/models/LostAndFound.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/LostAndFoundProvider.dart';
import 'package:GUConnect/src/utils/titleCase.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendingsScreen extends StatefulWidget {
  PendingsScreen({super.key});

  @override
  State<PendingsScreen> createState() => _PendingsScreenState();
}

class _PendingsScreenState extends State<PendingsScreen>
    with SingleTickerProviderStateMixin {
  final List<Confession> confessionPosts = [];
  final List<AcademicQuestion> academicPosts = [];
  List<LostAndFound> lostAndFoundPosts = [];
  List<Confession> confessionPostsDisplay = [];
  List<AcademicQuestion> academicPostsDisplay = [];
  List<LostAndFound> lostAndFoundPostsDisplay = [];
  late TabController _tabController;

  late final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  late LostAndFoundProvider lostAndFoundPostsProvider;

  @override
  void initState() {
    super.initState();

    //confessionPosts = Provider.of<ConfessionProvider>(context, listen: false).confessions;
    //academicPosts = Provider.of<AcademicQuestionProvider>(context, listen: false).academicQuestions;
    lostAndFoundPostsProvider =
        Provider.of<LostAndFoundProvider>(context, listen: false);

    lostAndFoundPostsProvider.postItem(LostAndFound(
      user: CustomUser(
        fullName: 'John Doe',
        email: ' ooo@gmail.com',
        userType: UserType.student,
        password: '',
        image: '',
        
      ),
      location: 'location',
      createdAt: DateTime.now(),
      content: '',
      contact: '',
      image: '',
      isFound: false,
    ));

    fetchItems().then((value) => {
          setState(() {
            _isLoading = false;
          })
        });

    _tabController = TabController(length: 3, vsync: this);
  }

  Future fetchItems() async {
    setState(() {
      _isLoading = true;
    });

    lostAndFoundPostsProvider.getItems().then((value) => setState(() {
          lostAndFoundPosts = value;
          lostAndFoundPostsDisplay = value;
        }));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void filterItems(String value) {
    value = value.trim().toLowerCase();
    setState(() {
      _searchController.text = value;

      lostAndFoundPostsDisplay = [];
      lostAndFoundPostsDisplay.addAll(lostAndFoundPosts
          .where((element) =>
              (element.user.fullName ?? '').toLowerCase().contains(value))
          .toList());

      academicPostsDisplay = [];
      academicPostsDisplay.addAll(academicPosts
          .where((element) =>
              (element.user.fullName ?? '').toLowerCase().contains(value))
          .toList());
    });

    confessionPostsDisplay = [];
    confessionPostsDisplay.addAll(confessionPosts
        .where((element) =>
            (element.sender.fullName ?? '').toLowerCase().contains(value))
        .toList());
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          setState(() {
            filterItems(value);
          });
        },
      ),
    );
  }

  Widget _buildLostAndFounds() {
    return _isLoading
        ? const Loader()
        : lostAndFoundPostsDisplay.isEmpty
            ? Center(
                child: Text(
                'No lost and founds found',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary),
              ))
            : RefreshIndicator(
                onRefresh: () async {
                  filterItems(_searchController.text);
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: ListView.builder(
                  itemCount: lostAndFoundPostsDisplay.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return UserTile(
                      user: lostAndFoundPostsDisplay[index].user,
                      createdAt: lostAndFoundPostsDisplay[index].createdAt,
                      onNavigate: () {
                        Navigator.of(context).pushNamed(
                            CustomRoutes.lostAndFoundDetail,
                            arguments: lostAndFoundPostsDisplay[index]);
                      },
                    );
                  },
                ),
              );
  }

  Widget _buildAcademicPosts() {
    return _isLoading
        ? const Loader()
        : academicPostsDisplay.isEmpty
            ? Center(
                child: Text(
                'No academic posts found',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary),
              ))
            : RefreshIndicator(
                onRefresh: () async {
                  filterItems(_searchController.text);
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: ListView.builder(
                  itemCount: academicPostsDisplay.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return UserTile(
                      user: academicPostsDisplay[index].user,
                      createdAt: academicPostsDisplay[index].createdAt,
                      onNavigate: () {
                        Navigator.of(context).pushNamed(
                            CustomRoutes.adminAcademicQuestionsDetail,
                            arguments: academicPostsDisplay[index]);
                      },
                    );
                  },
                ),
              );
  }

  Widget _buildConfessionPosts() {
    return _isLoading
        ? const Loader()
        : confessionPostsDisplay.isEmpty
            ? Center(
                child: Text(
                'No confession posts found',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary),
              ))
            : RefreshIndicator(
                onRefresh: () async {
                  filterItems(_searchController.text);
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: ListView.builder(
                  itemCount: confessionPostsDisplay.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return UserTile(
                      user: confessionPostsDisplay[index].sender,
                      createdAt: confessionPostsDisplay[index].createdAt,
                      onNavigate: () {
                        Navigator.of(context).pushNamed(
                            CustomRoutes.adminConfessionsDetail,
                            arguments: confessionPostsDisplay[index]);
                      },
                    );
                  },
                ),
              );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Pending Posts',
          isLogo: false,
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Confessions'),
                Tab(text: 'Academic'),
                Tab(text: 'Lost & Found'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildConfessionPosts(),
                  _buildAcademicPosts(),
                  _buildLostAndFounds(),
                ],
              ),
            ),
          ],
        ));
  }
}

class UserTile extends StatelessWidget {
  final CustomUser user;

  final Function onNavigate;

  final DateTime createdAt;

  const UserTile(
      {required this.user,
      super.key,
      required this.onNavigate,
      required this.createdAt});

  String userTitle() {
    String title = '';
    if (user.userType == UserType.professor) {
      title = 'Prof.';
    } else if (user.userType == UserType.ta) {
      title = 'Dr.';
    } else if (user.userType == UserType.student) {
      title = 'Student';
    }
    return title;
  }

  // format date function
  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        leading: Hero(
          tag: user.email,
          child: CircleAvatar(
            foregroundImage: user.image == null || user.image == ''
                ? NetworkImage(user.image ?? '')
                : null,
                backgroundImage: const AssetImage('assets/images/user.png'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
        title: Text('${userTitle()} ${titleCase(user.fullName ?? '')}'),
        subtitle: Text(
          '${user.email} \n ${formatDate(createdAt)}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(CustomRoutes.profile, arguments: user);
          },
        ),
        onTap: () {
          onNavigate();
        },
      ),
    );
  }
}
