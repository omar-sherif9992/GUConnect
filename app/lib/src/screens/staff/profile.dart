import 'package:GUConnect/src/models/Staff.dart';
import 'package:GUConnect/src/providers/AcademicQuestionProvider.dart';
import 'package:GUConnect/src/providers/ConfessionProvider.dart';
import 'package:GUConnect/src/providers/LostAndFoundProvider.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/screens/common/RatingBar.dart';
import 'package:GUConnect/src/widgets/bottom_bar.dart';
import 'package:GUConnect/src/widgets/drawer.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class StuffProfile extends StatefulWidget {
  const StuffProfile({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StuffProfileState();
  }
}

class _StuffProfileState extends State<StuffProfile>
    with SingleTickerProviderStateMixin {
  late Staff? staff;
  late ConfessionProvider confessionProvider;
  late NewsEventClubProvider newsEventClubProvider;
  late LostAndFoundProvider lostAndFoundProvider;
  late AcademicQuestionProvider academicQuestionProvider;
  @override
  Widget build(BuildContext context) {
    // get user from router
    staff = Staff(
      fullName: "Abdelrahman",
      email: "abdelrahman.fekri@guc.edu.eg",
      staffType: "TA",
      bio:
          "Met professor in the hallway and he said hi to me. I'm so happy! :) ",
      description: "",
      speciality: "",
      officeLocation: "C7.203",
      courses: [
        'CSEN 201: Introduction to CS',
        'CSEN 301: Object Oriented Programming',
        'CSEN 401: Data Structures and Algorithms',
        'CSEN 501: Operating Systems',
        'CSEN 601: Computer Networks',
      ],
    );

    return Scaffold(
        bottomNavigationBar: const BottomBar(),
        drawer: const MainDrawer(),
        appBar: const CustomAppBar(title: 'Stuff Profile'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
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
                                  color: Colors.white, // White border color
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
                                  staff?.image ??
                                      'https://picsum.photos/200/300',
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 200,
                                    child: Text(
                                      ('${staff?.staffType ?? ''} ${staff?.fullName ?? ''}'),
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
                                          width: 60,
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            color: const Color.fromARGB(
                                                255, 242, 200, 147),
                                          ),
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            staff?.officeLocation ?? '',
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Container(
                                          width: 60,
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            color: const Color.fromARGB(
                                                255, 242, 200, 147),
                                          ),
                                          padding: const EdgeInsets.all(8.0),
                                          child: const Text(
                                            'Rating\n4.7',
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ])
                          ],
                        ),
                        Container(
                            margin: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      staff?.email ?? '',
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )),
                                SizedBox(
                                  width: 300,
                                  child: Text(
                                    staff?.bio ?? '',
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
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                    color: const Color.fromARGB(
                                                        255, 242, 200, 147),
                                                  ),
                                                  child: Text(
                                                    course,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ))
                                            .toList() ??
                                        [],
                                  ),
                                ),
                                // Rating Staff
                                const SizedBox(height: 30),
                                Text(
                                  'Rate ${staff?.staffType ?? ''} ${staff?.fullName ?? ''} : ',
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CRatingBar(rating: 5)
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
