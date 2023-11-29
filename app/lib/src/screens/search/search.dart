import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/dummy_data/user.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/utils/titleCase.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<CustomUser> users = dummy_users;
  final List<CustomUser> usersDisplay = dummy_users;
  final bool _isLoading = false;

  @override
  void initState() {
    // TODO: request users

    super.initState();
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
            usersDisplay.clear();
            usersDisplay.addAll(users
                .where((element) => (element.fullName ?? '')
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList());
          });
        },
      ),
    );
  }

  Widget _buildProfessorsTab() {
    final List<CustomUser> professors = usersDisplay
        .where((element) => element.userType == UserType.professor)
        .toList();

    return _isLoading
        ? Loader()
        : professors.isEmpty
            ? Center(
                child: Text(
                'No professors found',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary),
              ))
            : RefreshIndicator(
                onRefresh: () async {
                  // TODO: request users
                },
                child: ListView.builder(
                  itemCount: professors.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: UserTile(
                          user: professors[index],
                          userType: UserType.professor),
                    );
                  },
                ),
              );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '',
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Profs'),
                Tab(text: 'TAs'),
                Tab(text: 'Places'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProfessorsTab(),
                  Center(child: Text('Tab 2 content')),
                  Center(child: Text('Tab 3 content')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final CustomUser user;
  final UserType userType;

  const UserTile({required this.user, super.key, required this.userType});

  String userTitle() {
    String title = '';
    if (user.userType == UserType.professor) {
      title = 'Prof.';
    } else if (user.userType == UserType.ta) {
      title = 'Dr.';
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          ListTile(
            leading: Hero(
              tag: user.id,
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.image ?? ''),
              ),
            ),
            title: Text('${userTitle()} ${titleCase(user.fullName ?? '')}'),
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
                  .pushNamed(CustomRoutes.profile, arguments: user);
            },
          ),
          const Divider(
            thickness: 1.1,
          ),
        ],
      ),
    );
  }
}
