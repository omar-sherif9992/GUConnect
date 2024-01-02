import 'package:GUConnect/src/models/Rating.dart';
import 'package:GUConnect/src/models/Staff.dart';
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

class StuffProfile extends StatefulWidget {
  const StuffProfile({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StuffProfileState();
  }
}

class _StuffProfileState extends State<StuffProfile>
    with SingleTickerProviderStateMixin {
  late Staff staff;
  late bool _loading;

  late Rating _staffRating;
  late double _userRating = 0;

  RatingProvider? ratingProvider;
  UserProvider? userProvider;

  Future<void> getRating() async {
    ratingProvider!.getRating(staff.email).then((value) => setState(() {
          _staffRating = value;
        }));
  }

  Future<void> onRatingDeleted() async {
    ratingProvider!
        .deleteRating(staff.email, userProvider!.user!.user_id)
        .then((value) => setState(() {
              if (value != null) {
                _staffRating = value;
                _userRating = 0;
              }
            }));
  }

  Future<void> getUserRating() async {
    ratingProvider!
        .getUserRating(staff.email, userProvider!.user!.user_id)
        .then((value) => setState(() {
              _userRating = value.rating;
            }));
  }

  Future<void> onRatingSubmitted(double rating) async {
    final UserRating userRating = UserRating(
      userId: userProvider!.user!.user_id,
      rating: rating,
    );
    ratingProvider!.addRating(userRating, staff.email).then((value) {
      setState(() {
        _userRating = rating;
        _staffRating = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    staff = Staff(
        fullName: '',
        email: '',
        staffType: '',
        description: '',
        speciality: '',
        courses: []);
    _staffRating = Rating(
      id: staff.email,
      ratingSum: 0,
      ratingAverage: 0,
      ratingCount: 0,
    );
    setState(() {
      _loading = true;
    });
    Future.delayed(
      Duration.zero,
      () async {
        ratingProvider = Provider.of<RatingProvider>(context, listen: false);
        userProvider = Provider.of<UserProvider>(context, listen: false);
        staff = ModalRoute.of(context)!.settings.arguments as Staff;
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
        appBar: const CustomAppBar(title: 'Staff Profile'),
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
                                        staff.image ??
                                            'https://picsum.photos/200/300',
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
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.5,
                                          child: Text(
                                            ('${staff.staffType} ${staff.fullName}'),
                                            overflow: TextOverflow.clip,
                                            style: const TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
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
                                                width: 80,
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
                                                  staff.officeLocation ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
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
                                                    _staffRating.ratingAverage
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
                                      Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            staff.email,
                                            style: const TextStyle(
                                              fontSize: 15.0,
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        child: Text(
                                          staff.bio ?? '',
                                          overflow: TextOverflow.clip,
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            letterSpacing: 1.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      const Text(
                                        'Courses: ',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        width: 300,
                                        child: Wrap(
                                          spacing: 10.0,
                                          runSpacing: 10.0,
                                          children: staff?.courses
                                                  ?.map((course) => Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0),
                                                          color: const Color
                                                              .fromARGB(255,
                                                              242, 200, 147),
                                                        ),
                                                        child: Text(
                                                          course,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ))
                                                  .toList() ??
                                              [],
                                        ),
                                      ),
                                      // Rating Staff
                                      const SizedBox(height: 30),
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.8,
                                        child: 
                                          Text(
                                          'Rate ${staff.staffType} ${staff.fullName} : ',
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            letterSpacing: 1.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                
                                      ),
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
