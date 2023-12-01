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

  List<Staff> proffs = [];
  List<Staff> proffsDisplay = [];

  List<Staff> tas = [];
  List<Staff> tasDisplay = [];

  bool _isLoading = false;

  late StaffProvider staffProvider;

  @override
  void initState() {
    super.initState();

    staffProvider = Provider.of<StaffProvider>(context, listen: false);

    staffProvider.addStaff(Staff(
      fullName: 'John Doe',
      email: 'abdo@gmail.com',
      rating: 2,
      courses: [],
      officeHours: [],
      reviews: [],
      staffType: StaffType.professor,
    ));
    staffProvider.addStaff(Staff(
      fullName: 'Mohy',
      email: 'mohy@gmail.com',
      rating: 5,
      courses: [],
      officeHours: [],
      reviews: [],
      staffType: StaffType.ta,
    ));

    fetchStaff(staffProvider).then((value) => {
          setState(() {
            _isLoading = false;
          })
        });

    _tabController = TabController(length: 2, vsync: this);
  }

  Future fetchStaff(
    StaffProvider staffProvider,
  ) async {
    setState(() {
      _isLoading = true;
    });

    staffProvider.getProffessors().then((value) => setState(() {
          proffs = value;
          proffsDisplay = value;
        }));

    staffProvider.getStaffs().then((value) => setState(() {
          tas = value;
          tasDisplay = value;
        }));
  }

  Future fetchProffs(
    StaffProvider staffProvider,
  ) async {
    setState(() {
      _isLoading = true;
    });

    staffProvider.getProffessors().then((value) => setState(() {
          proffs = value;
          proffsDisplay = value;
        }));
  }

  Future fetchTas(
    StaffProvider staffProvider,
  ) async {
    setState(() {
      _isLoading = true;
    });

    staffProvider.getStaffs().then((value) => setState(() {
          tas = value;
          tasDisplay = value;
        }));
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
                  await fetchProffs(staffProvider);
                  filterItems(_searchController.text);
                },
                child: ListView.builder(
                  itemCount: proffsDisplay.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return StaffTile(
                        staff: proffsDisplay[index],
                        staffType: StaffType.professor);
                  },
                ),
              );
  }

  Widget _buildTasTab() {
    print(tas.length);

    return _isLoading
        ? const Loader()
        : tasDisplay.isEmpty
            ? Center(
                child: Text(
                  'No tas found',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await fetchTas(staffProvider);
                  filterItems(_searchController.text);
                },
                child: ListView.builder(
                  itemCount: tasDisplay.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return StaffTile(
                        staff: tasDisplay[index], staffType: StaffType.ta);
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
          .where((element) =>
              (element.fullName).toLowerCase().contains(value.toLowerCase()))
          .toList());
      tasDisplay = [];
      tasDisplay.addAll(tas
          .where((element) =>
              (element.fullName).toLowerCase().contains(value.toLowerCase()))
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
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProfessorsTab(),
                  _buildTasTab(),
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
          tag: staff.email,
          child: CircleAvatar(
            backgroundImage: NetworkImage(staff.image ?? ''),
          ),
        ),
        title: Text('${staffTitle()} ${titleCase(staff.fullName)}'),
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
