import 'package:GUConnect/src/models/Rating.dart';

class Course {
  late String courseCode;
  late String courseName;
  late String? image;
  late List<Rating> ratings;
  late String description;

  /// Constructs a Course object with the specified [fullName],[image], [email], [password], [description], and [speciality].
  Course({
    required this.courseCode,
    required this.courseName,
    this.image,
    required this.description,
  }) {
    ratings = [];
  }

  /// Constructs a User object from a JSON map.
  Course.fromJson(Map<String, dynamic> json) {
    courseName = json['courseName'];
    image = json['image'];
    description = json['description'];
    courseCode = json['courseCode'];
    ratings = (json['ratings'] as List<dynamic>)
        .map((e) => Rating.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Converts the User object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseCode'] = this.courseCode;
    data['courseName'] = this.courseName;
    data['image'] = this.image;
    data['description'] = this.description;
    data['ratings'] = this.ratings.map((e) => e.toJson()).toList();

    return data;
  }

  @override
  String toString() {
    return 'courseCode: $courseCode, courseName: $courseName, image: $image, description: $description, ratings: ${ratings.map((e) => e.toString())}';
  }
}
