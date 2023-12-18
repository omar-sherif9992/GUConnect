import 'dart:io';

import 'package:GUConnect/src/models/Course.dart';
import 'package:GUConnect/src/utils/uploadImageToStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CourseProvider extends ChangeNotifier {
  final coursesRef =
      FirebaseFirestore.instance.collection('courses').withConverter<Course>(
            fromFirestore: (snapshot, _) => Course.fromJson(snapshot.data()!),
            toFirestore: (course, _) => course.toJson(),
          );

  Future<List<Course>> searchCourse(String name) async {
    final List<Course> courses = [];
    final QuerySnapshot<Course> querySnapshot =
        await coursesRef.where('courseName', isEqualTo: name).get();

    querySnapshot.docs.forEach((doc) {
      courses.add(doc.data());
    });
    return courses;
  }

  Future<List<Course>> getCourses() async {
    final List<Course> courses = [];
    final QuerySnapshot<Course> querySnapshot =
        await coursesRef.orderBy('courseName', descending: false).get();

    querySnapshot.docs.forEach((doc) {
      courses.add(doc.data());
    });
    return courses;
  }

  Future<void> setCourse(Course course, File? profileImageFile) async {
    try {
      if (profileImageFile != null) {
        final String? imageUrl = await uploadImageToStorage(
            profileImageFile, 'course_images', course.courseName);
        if (imageUrl != null) course.image = imageUrl;
      }
      await coursesRef.doc(course.courseCode).set(course);
      notifyListeners();
    } catch (e) {
      print("Error setting course");
      print(e);
    }
  }

  Future<void> deleteCourse(Course course) async {
    try {
      await coursesRef.doc(course.courseName).delete();
      notifyListeners();
    } catch (e) {
      print("Error deleting course");
      print(e);
    }
  }
}
