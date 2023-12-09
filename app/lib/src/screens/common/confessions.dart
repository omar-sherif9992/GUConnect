import 'package:GUConnect/src/dummy_data/posts.dart';
import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/providers/ConfessionProvider.dart';
import 'package:GUConnect/src/widgets/bottom_bar.dart';
import 'package:GUConnect/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:GUConnect/src/widgets/post_widget.dart';

class Confessions extends StatefulWidget {
  const Confessions({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ConfessionsState();
  }
}

class _ConfessionsState extends State<Confessions>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Confession> confessions = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: Text('Confessions'),
      ),
      body: Column(
        children: [
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [_buildPosts(posts)],
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

  Future fetchConfessions(ConfessionProvider provider) async {
    provider.getConfessions().then((value) => {
          setState(() {
            confessions = value;
            confessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          })
        });
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }
}

class ClickableIcon extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final VoidCallback onTap;

  ClickableIcon(this.icon, this.labelText, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20.0,
              color: Colors.black,
            ),
            SizedBox(height: 8.0),
            Text(
              labelText,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
