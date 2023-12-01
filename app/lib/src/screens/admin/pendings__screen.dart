import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/AcademicQuestion.dart';
import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/models/LostAndFound.dart';
import 'package:GUConnect/src/providers/AcademicQuestionProvider.dart';
import 'package:GUConnect/src/providers/LostAndFoundProvider.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
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
  final List<LostAndFound> lostAndFoundPosts = [];
  List<Confession> confessionPostsDisplay = [];
  List<AcademicQuestion> academicPostsDisplay = [];
  List<LostAndFound> lostAndFoundPostsDisplay = [];
  late TabController _tabController;
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    //confessionPosts = Provider.of<ConfessionProvider>(context, listen: false).confessions;
    //academicPosts = Provider.of<AcademicQuestionProvider>(context, listen: false).academicQuestions;
    // lostAndFoundPosts = Provider.of<LostAndFoundProvider>(context, listen: false).lostAndFounds;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            confessionPostsDisplay = [];
            confessionPostsDisplay.addAll(confessionPosts
                .where((element) => (element.sender.fullName ?? '')
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList());

            academicPostsDisplay = [];

            academicPostsDisplay.addAll(academicPosts
                .where((element) => (element.user.fullName ?? '')
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList());

            lostAndFoundPostsDisplay = [];

            lostAndFoundPostsDisplay.addAll(lostAndFoundPosts
                .where((element) => (element.user.fullName ?? '')
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList());
          });
        },
      ),
    );
  }

  Widget _buildLostAndFounds() {
    return ListView.builder(
      itemCount: lostAndFoundPosts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Post'),
          subtitle: Text('Post'),
          trailing: IconButton(
            icon: Icon(Icons.check),
            onPressed: () {},
          ),
        );
      },
    );
  }

  Widget _buildAcademicPosts() {
    return ListView.builder(
      itemCount: academicPosts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Post'),
          subtitle: Text('Post'),
          trailing: IconButton(
            icon: Icon(Icons.check),
            onPressed: () {},
          ),
        );
      },
    );
  }

  Widget _buildConfessionPosts() {
    return ListView.builder(
      itemCount: confessionPosts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Confession Post'),
          subtitle: Text('Confession Post'),
          trailing: IconButton(
            icon: Icon(Icons.check),
            onPressed: () {},
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Pending Posts',
        isLogo: false,
      ),
      body: Column(children: [
        Expanded(
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: const TabBar(
                tabs: [
                  Tab(text: 'Lost & Found'),
                  Tab(text: 'Academic'),
                  Tab(text: 'Confession'),
                ],
              ),
              body: Column(
                children: [
                  _buildSearchBar(),
                  TabBarView(
                    children: [
                      _buildLostAndFounds(),
                      _buildAcademicPosts(),
                      _buildConfessionPosts(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

/* class PostTile extends StatelessWidget {
  const PostTile({super.key});

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
          tag: user.id,
          child: CircleAvatar(
            backgroundImage: NetworkImage(user.image ?? ''),
          ),
        ),
        title: Text(''),
        subtitle: Text(user.biography ?? ''),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(CustomRoutes.profile, arguments: user);
          },
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamed(CustomRoutes, arguments: user);
        },
      ),
    );
  }
} */
