import 'package:GUConnect/src/models/Rating.dart';

/// Represents the type of a user in the application.

class StaffType {
  static String professor = 'professor';
  static String ta = 'ta';

  static String getStaffType(String staffType) {
    if (staffType == StaffType.professor) {
      return 'professor';
    } else if (staffType == StaffType.ta) {
      return 'ta';
    } else {
      return 'Staff';
    }
  }

  static String getStaffTypeValue(String staffType) {
    if (staffType == 'professor') {
      return StaffType.professor;
    } else if (staffType == 'ta') {
      return StaffType.ta;
    } else {
      return 'Staff';
    }
  }
}

/* class OfficeHour {
  late String day;
  late String from;
  late String to;
  OfficeHour({required this.day, required this.from, required this.to});

  OfficeHour.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
} */

class Staff {
  late String id;
  late String fullName;
  late String? image;
  late String email;
  late String staffType;
  late String? officeLocation;
  late String? bio;
  // late List<OfficeHour> officeHours;
  late List<String> courses;
  late List<Rating> ratings;

  late String description;
  late String speciality;

  /// Constructs a Staff object with the specified [fullName],[image], [email], [password], [description], and [speciality].
  Staff({
    required this.fullName,
    this.image,
    required this.email,
    this.officeLocation,
    //required this.officeHours,
    required this.staffType,
    this.bio,
    required this.description,
    required this.speciality,
    required this.courses,
  });

  /// Constructs a User object from a JSON map.
  Staff.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    image = json['image'];
    email = json['email'];
    description = json['description'];
    speciality = json['speciality'];
    officeLocation = json['officeLocation'];
    //officeHours = OfficeHour.fromJson(json['officeHours']) as List<OfficeHour>;
    staffType = StaffType.getStaffTypeValue(json['staffType']);
    bio = json['bio'];
    courses = List<String>.from(json['courses']);
  }

  /// Converts the User object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['image'] = this.image;
    data['email'] = this.email;
    data['officeLocation'] = this.officeLocation;
    // data['officeHours'] = this.officeHours;
    data['description'] = this.description;
    data['speciality'] = this.speciality;
    data['staffType'] = StaffType.getStaffType(staffType);
    data['bio'] = bio;
    data['courses'] = courses;

    return data;
  }

  @override
  String toString() {
    return 'fullName: $fullName, email: $email, staffType: $staffType';
  }
}
