import 'package:GUConnect/src/models/Course.dart';
import 'package:GUConnect/src/models/Rating.dart';
import 'package:GUConnect/src/models/UserRating.dart';
import 'package:GUConnect/src/providers/RatingProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/widgets/RatingBar.dart';
import 'package:GUConnect/src/widgets/bottom_bar.dart';
import 'package:GUConnect/src/widgets/drawer.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseProfile extends StatefulWidget {
  const CourseProfile({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CourseProfileState();
  }
}

class _CourseProfileState extends State<CourseProfile>
    with SingleTickerProviderStateMixin {
  Course course = Course(
    courseCode: '',
    courseName: '',
    description: '',
  );
  bool _loading = false;

  Rating _courseRating = Rating(
    id: '',
    ratingSum: 0,
    ratingAverage: 0,
    ratingCount: 0,
  );
  late double _userRating = 0;

  RatingProvider? ratingProvider;
  UserProvider? userProvider;

  Future<void> getRating() async {
    ratingProvider!.getRating(course.courseCode).then((value) => setState(() {
          _courseRating = value;
        }));
  }

  Future<void> onRatingDeleted() async {
    ratingProvider!
        .deleteRating(course.courseCode, userProvider!.user!.user_id)
        .then((value) => setState(() {
              if (value != null) {
                _courseRating = value;
                _userRating = 0;
              }
            }));
  }

  Future<void> getUserRating() async {
    ratingProvider!
        .getUserRating(course.courseCode, userProvider!.user!.user_id)
        .then((value) => setState(() {
              _userRating = value.rating;
            }));
  }

  Future<void> onRatingSubmitted(double rating) async {
    final UserRating userRating = UserRating(
      userId: userProvider!.user!.user_id,
      rating: rating,
    );
    ratingProvider!.addRating(userRating, course.courseCode).then((value) {
      setState(() {
        _userRating = rating;
        _courseRating = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    ratingProvider = Provider.of<RatingProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    Future.delayed(
      Duration.zero,
      () async {
        ratingProvider = Provider.of<RatingProvider>(context, listen: false);
        userProvider = Provider.of<UserProvider>(context, listen: false);
        course = ModalRoute.of(context)!.settings.arguments as Course;
        await getRating();
        await getUserRating();
        setState(() {
          _loading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // get user from router
    return Scaffold(
        bottomNavigationBar: const BottomBar(),
        drawer: const MainDrawer(),
        appBar: const CustomAppBar(title: 'Course Profile'),
        body: SingleChildScrollView(
          child: _loading
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: const Loader(),
                )
              : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 20, bottom: 30, left: 10, right: 10),
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
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            Colors.white, // White border color
                                        width: 3.0,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        course.image ??
                                            'https://th.bing.com/th/id/R.fc7b660d1b6021d08f4a29c8b79e512f?rik=dsJBajttEnte3A&pid=ImgRaw&r=0',
                                        width: 100.0,
                                        height: 100.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 200,
                                          child: Text(
                                            ('${course.courseName}'),
                                            overflow: TextOverflow.clip,
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                  width: 60,
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                    color: const Color.fromARGB(
                                                        255, 242, 200, 147),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    _courseRating.ratingAverage
                                                        .toStringAsFixed(1),
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )),
                                            ],
                                          ),
                                        )
                                      ])
                                ],
                              ),
                              Container(
                                  margin: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Description : ',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: 300,
                                        child: Text(
                                          course.description,
                                          overflow: TextOverflow.clip,
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            letterSpacing: 1.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      SizedBox(
                                          width: 300,
                                          child: Text(
                                            'Rate ${course.courseName} : ',
                                            style: const TextStyle(
                                              fontSize: 15.0,
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )),
                                      const SizedBox(height: 10),
                                      CRatingBar(
                                        rating: _userRating,
                                        onRatingSubmit: onRatingSubmitted,
                                        onRatingDelete: onRatingDeleted,
                                      )
                                    ],
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ));
  }
}
