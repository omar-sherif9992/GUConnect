import 'package:GUConnect/src/models/NewsEventClub.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/screens/admin/request_post_screen.dart';
import 'package:GUConnect/src/utils/titleCase.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/bottom_bar.dart';
import 'package:GUConnect/src/widgets/drawer.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendingsScreen extends StatefulWidget {
  const PendingsScreen({super.key});

  @override
  State<PendingsScreen> createState() => _PendingsScreenState();
}

class _PendingsScreenState extends State<PendingsScreen> {
  
  List<NewsEventClub> posts = [];
  List<NewsEventClub> postsDisplay = [];

  late final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  late NewsEventClubProvider newsEventClubProvider;

  String _selectFilter = 'All';

  @override
  void initState() {
    super.initState();

    newsEventClubProvider =
        Provider.of<NewsEventClubProvider>(context, listen: false);

/*     newsEventClubProvider.postContent(NewsEventClub(
        content: 'I hate you',
        poster: CustomUser(
          fullName: 'Ahmed',
          email: 'omar@student.guc.edu.eg',
          password: '',
          userName: 'omar.kaa',

        ),

        image:
            'https://upload.wikimedia.org/wikipedia/en/thumb/7/71/MaxPayneMP3.jpg/235px-MaxPayneMP3.jpg',
        reason: 'I love life',
        createdAt: DateTime.now())); */

    fetchItems();
  }

  Future fetchItems() async {
    setState(() {
      _isLoading = true;
    });

    newsEventClubProvider
        .getRequestedApprovalPosts()
        .then((value) => setState(() {
              posts = value;
              postsDisplay = value;
              _isLoading = false;
            }));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void filterItems(String value) {
    value = value.trim().toLowerCase();
    String tempSelectFilter = _selectFilter.toLowerCase();
    setState(() {
      _searchController.text = value;

      postsDisplay = [];
      postsDisplay.addAll(posts
          .where((element) =>
              ((element.poster.fullName ?? '').toLowerCase().contains(value) &&
                  (element.poster.userType == tempSelectFilter ||
                      tempSelectFilter == 'all')))
          .toList());
    });
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

  Widget _buildSelectFilter() {
    /* return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: _selectFilter,
        elevation: 16,
        onChanged: (String? newValue) {
          setState(() {
            _selectFilter = newValue!;
          });

          filterItems(_searchController.text);
        },
        items: <String>['All', 'Stuff', 'Student']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(fontSize: 20),
            ),
          );
        }).toList(),
      ),
    ); */

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Expanded(
        child: ToggleButtons(
          direction: Axis.horizontal,
          borderRadius: BorderRadius.circular(10),
          borderWidth: 2,
          key: const PageStorageKey('pending_posts_select_filter'),
          onPressed: (int index) {
            setState(() {
              _selectFilter = ['All', 'Stuff', 'Student'][index];
            });

            filterItems(_searchController.text);
          },
          isSelected: [
            _selectFilter == 'All',
            _selectFilter == 'Stuff',
            _selectFilter == 'Student',
          ],
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'All',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Stuff',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Student',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPosts() {
    return _isLoading
        ? const Loader()
        : posts.isEmpty
            ? Center(
                child: Text(
                'No requested posts found',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary),
              ))
            : RefreshIndicator(
                onRefresh: () async {
                  fetchItems();
                  filterItems(_searchController.text);
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: ListView.builder(
                  itemCount: postsDisplay.length,
                  key: const PageStorageKey('pending_posts'),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(postsDisplay[index].id),
                      onDismissed: (direction) {
                        if (direction.index == 2) {
                          newsEventClubProvider
                              .approvePost(postsDisplay[index]);
                        } else if (direction.index == 3) {
                          newsEventClubProvider
                              .disapprovePost(postsDisplay[index]);
                        }
                        setState(() {
                          postsDisplay.removeAt(index);
                        });
                      },
                      background: Container(
                        color: Colors.red,
                        child: const Icon(Icons.disabled_by_default),
                      ),
                      secondaryBackground: Container(
                        color: Colors.green,
                        child: const Icon(Icons.check),
                      ),
                      child: PostTile(
                        user: postsDisplay[index].poster,
                        post: postsDisplay[index],
                        onTap: (NewsEventClub post, bool decision) async {
                          if (decision) {
                            await newsEventClubProvider
                                .approvePost(postsDisplay[index]);
                          } else {
                            await newsEventClubProvider
                                .disapprovePost(postsDisplay[index]);
                          }
                          setState(() {
                            posts.removeWhere((element) =>
                                element.id == postsDisplay[index].id);
                          });
                        },
                      ),
                    );
                  },
                ),
              );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      drawer: const MainDrawer(),
        appBar: const CustomAppBar(
          title: 'Pending Posts',
          isLogo: false,
        ),
        body: Column(
          children: [
            _buildSearchBar(),
            _buildSelectFilter(),
            Expanded(
              child: _buildPosts(),
            ),
          ],
        ));
  }
}

class PostTile extends StatelessWidget {
  final NewsEventClub post;
  final CustomUser user;
  final Function(NewsEventClub, bool) onTap;

  const PostTile(
      {required this.user, super.key, required this.post, required this.onTap});

  String userTitle() {
    String title = '';
    if (user.userType == UserType.student) {
      title = '(Stud)';
    } else if (user.userType == UserType.stuff) {
      title = '(Stuff)';
    } else if (user.userType == UserType.admin) {
      title = '(Admin)';
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
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              foregroundImage: user.image == null || user.image == ''
                  ? NetworkImage(user.image ?? '')
                  : null,
              backgroundImage: const AssetImage('assets/images/user.png'),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titleCase(user.fullName ?? ''),
            ),
            Text(
              userTitle(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Text(user.email),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            final bool decision = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RequestPostScreen(
                  post: post,
                ),
                maintainState: false,
              ),
            );
            if (decision == null) return;

            onTap(post, decision);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(decision ? 'Post Approved' : 'Post Disapproved'),
              ),
            );
          },
        ),
      ),
    );
  }
}
