// ignore_for_file: use_build_context_synchronously

import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/Course.dart';
import 'package:GUConnect/src/models/Staff.dart';
import 'package:GUConnect/src/providers/CourseProvider.dart';
import 'package:GUConnect/src/providers/StaffProvider.dart';
import 'package:GUConnect/src/screens/admin/set_course_screen.dart';
import 'package:GUConnect/src/screens/admin/set_staff_screen.dart';
import 'package:GUConnect/src/utils/titleCase.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchCourseScreen extends StatefulWidget {
  const SearchCourseScreen({super.key});

  @override
  State<SearchCourseScreen> createState() => _SearchCourseScreenState();
}

class _SearchCourseScreenState extends State<SearchCourseScreen> {
  List<Course> courses = [];
  List<Course> coursesDisplay = [];

  bool _isLoading = false;

  late CourseProvider courseProvider;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    courseProvider = Provider.of<CourseProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    fetchCourses(courseProvider)
        .then((value) => {
              setState(() {
                _isLoading = false;
              })
            })
        .catchError((error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future fetchCourses(
    CourseProvider courseProvider,
  ) async {
    setState(() {
      _isLoading = true;
    });

    final List<Course> coursesList = await courseProvider.getCourses();

    setState(() {
      courses = coursesList;
      coursesDisplay = coursesList;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
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

  Widget _buildCourses() {
    return _isLoading
        ? const Loader()
        : coursesDisplay.isEmpty
            ? Center(
                child: Text(
                'No courses found',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.secondary),
              ))
            : RefreshIndicator.adaptive(
                onRefresh: () async {
                  await fetchCourses(courseProvider);
                },
                child: ListView.builder(
                  key: const PageStorageKey('courses_admin_search'),
                  itemCount: coursesDisplay.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return CourseTile(
                      course: coursesDisplay[index],
                    );
                  },
                ),
              );
  }

  void filterItems(String value) {
    value = value.trim().toLowerCase();
    setState(() {
      _searchController.text = value;

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const SetStaffScreen(),
              maintainState: false,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: CustomAppBar(
        title: 'Search Courses',
        isLogo: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const SetStaffScreen(),
                    maintainState: false),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCourses(),
        ],
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
            backgroundImage: NetworkImage(course.image ?? ''),
          ),
        ),
        title: Text(titleCase(course.courseName)),
        subtitle: Text(course.description),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SetCourseScreen(course: course)));
          },
        ),
      ),
    );
  }
}
