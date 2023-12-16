import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/Course.dart';
import 'package:GUConnect/src/models/Staff.dart';
import 'package:GUConnect/src/providers/CourseProvider.dart';
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
  List<Course> courses = [];
  List<Course> coursesDisplay = [];

  List<Staff> tas = [];
  List<Staff> tasDisplay = [];

  bool _isLoading = false;

  late StaffProvider staffProvider;
  late CourseProvider courseProvider;

  @override
  void initState() {
    super.initState();

    staffProvider = Provider.of<StaffProvider>(context, listen: false);
    courseProvider = Provider.of<CourseProvider>(context, listen: false);

    fetchAll(staffProvider, courseProvider).then((value) => {
          setState(() {
            _isLoading = false;
          })
        });

    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  Future fetchAll(
    StaffProvider staffProvider,
    CourseProvider courseProvider,
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
    courseProvider.getCourses().then((value) => setState(() {
          courses = value;
          coursesDisplay = value;
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

    staffProvider.getTas().then((value) => setState(() {
          tas = value;
          tasDisplay = value;
        }));
  }

  Future fetchCourses(
    CourseProvider courseProvider,
  ) async {
    setState(() {
      _isLoading = true;
    });

    courseProvider.getCourses().then((value) => setState(() {
          courses = value;
          coursesDisplay = value;
        }));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();

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
            : RefreshIndicator.adaptive(
                onRefresh: () async {
                  await fetchProffs(staffProvider);
                  filterItems(_searchController.text);

                  setState(() {
                    _isLoading = false;
                  });
                },
                child: ListView.builder(
                  key: const PageStorageKey('profs_user'),
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
            : RefreshIndicator.adaptive(
                onRefresh: () async {
                  await fetchTas(staffProvider);
                  filterItems(_searchController.text);
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: ListView.builder(
                  key: const PageStorageKey('tas_user'),
                  itemCount: tasDisplay.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return StaffTile(
                        staff: tasDisplay[index], staffType: StaffType.ta);
                  },
                ),
              );
  }

  Widget _buildCoursesTab() {
    return _isLoading
        ? const Loader()
        : tasDisplay.isEmpty
            ? Center(
                child: Text(
                  'No Courses found',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              )
            : RefreshIndicator.adaptive(
                onRefresh: () async {
                  await fetchCourses(courseProvider);
                  filterItems(_searchController.text);
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: ListView.builder(
                  key: const PageStorageKey('courses_user'),
                  itemCount: coursesDisplay.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return CourseTile(course: coursesDisplay[index]);
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
          .where((element) => (element.fullName).toLowerCase().contains(value))
          .toList());
      tasDisplay = [];
      tasDisplay.addAll(tas
          .where((element) => (element.fullName).toLowerCase().contains(value))
          .toList());

      coursesDisplay = [];
      coursesDisplay.addAll(courses
          .where(
              (element) => (element.courseName).toLowerCase().contains(value))
          .toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Search',
        isLogo: false,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Profs'),
              Tab(text: 'TAs'),
              Tab(text: 'Courses'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProfessorsTab(),
                _buildTasTab(),
                _buildCoursesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StaffTile extends StatelessWidget {
  final Staff staff;
  final String staffType;

  const StaffTile({required this.staff, super.key, required this.staffType});

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
            backgroundImage: staff.image != null
                ? NetworkImage(staff.image ?? '')
                : const AssetImage('assets/images/user.png')
                    as ImageProvider<Object>?,
          ),
        ),
        title: Text(titleCase(staff.fullName)),
        subtitle: Text(staff.email),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(CustomRoutes.staff, arguments: staff);
          },
        ),
      ),
    );
  }
}

class CourseTile extends StatelessWidget {
  final Course course;

  const CourseTile({required this.course, super.key});

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
          tag: course.courseName,
          child: CircleAvatar(
            backgroundImage: course.image != null
                ? NetworkImage(course.image ?? '')
                : const AssetImage('assets/images/course.png')
                    as ImageProvider<Object>?,
          ),
        ),
        title: Text(
            '${titleCase(course.courseCode)}:${titleCase(course.courseName)}'),
        subtitle: Text(course.description),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(CustomRoutes.course, arguments: course);
          },
        ),
      ),
    );
  }
}
