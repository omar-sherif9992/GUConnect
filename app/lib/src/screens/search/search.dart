import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/dummy_data/user.dart';
import 'package:GUConnect/src/models/Staff.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/StaffProvider.dart';
import 'package:GUConnect/src/utils/titleCase.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late final TextEditingController _searchController = TextEditingController();

  final List<Staff> proffs = [];
  List<Staff> proffsDisplay = [];

  final List<Staff> tas = [];
  List<Staff> tasDisplay = [];

  final bool _isLoading = false;

  late StaffProvider staffProvider;

  @override
  void initState() {
    // TODO: request users

    staffProvider = Provider.of<StaffProvider>(context, listen: false);

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
            filterItems(value);
          });
        },
        controller: _searchController,
      ),
    );
  }

  Widget _buildProfessorsTab() {
    return _isLoading
        ? const Loader()
        : proffsDisplay.isEmpty
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
                  await staffProvider.getProffessors();

                },
                child: ListView.builder(
                  itemCount: proffsDisplay.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return StaffTile(
                        staff: proffsDisplay[index], staffType: StaffType.professor);
                  },
                ),
              );
  }  Widget _buildTasTab() {
    return _isLoading
        ? const Loader()
        : tasDisplay.isEmpty
            ? Center(
                child: Text(
                'No tas found',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary),
              ))
            : RefreshIndicator(
                onRefresh: () async {
                  await staffProvider.getTas();
                  
                },
                child: ListView.builder(
                  itemCount: tasDisplay.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return StaffTile(
                        staff: tasDisplay[index], staffType: StaffType.professor);
                  },
                ),
              );
  }

  void filterItems(String value) {
    value = value.trim().toLowerCase();
    setState(() {
      _searchController.text = value;

      proffsDisplay = [];
      proffsDisplay.addAll(proffs
          .where((element) => (element.fullName ?? '')
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList());
      tasDisplay = [];
      tasDisplay.addAll(tas
          .where((element) => (element.fullName ?? '')
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList());
    });
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

class StaffTile extends StatelessWidget {
  final Staff staff;
  final StaffType staffType;

  const StaffTile({required this.staff, super.key, required this.staffType});

  String staffTitle() {
    String title = '';
    if (staff.staffType == StaffType.professor) {
      title = 'Prof.';
    } else if (staff.staffType == StaffType.ta) {
      title = 'Dr.';
    }
    return title;
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
          tag: staff.id,
          child: CircleAvatar(
            backgroundImage: NetworkImage(staff.image ?? ''),
          ),
        ),
        title: Text('${staffTitle()} ${titleCase(staff.fullName ?? '')}'),
        subtitle: Text(staff.email),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(CustomRoutes.profile, arguments: staff);
          },
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamed(CustomRoutes.profile, arguments: staff);
        },
      ),
    );
  }
}
