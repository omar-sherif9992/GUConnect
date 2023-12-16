import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents the type of a user in the application.

class UserType {
  static String admin = 'admin';
  static String student = 'student';
  static String staff = 'staff';

  static String getUserType(String staffType) {
    if (staffType == UserType.student) {
      return 'student';
    } else if (staffType == UserType.admin) {
      return 'admin';
    } else {
      return 'staff';
    }
  }

  static String getUserTypeValue(String userType) {
    if (userType == 'student') {
      return UserType.student;
    } else if (userType == 'staff') {
      return UserType.staff;
    } else if (userType == 'admin') {
      return UserType.admin;
    } else {
      return 'staff';
    }
  }
}

/// Represents a user in the application.
class CustomUser {
  late String? fullName;
  late String? userName;
  late String? phoneNumber;
  late String? image;
  late String email; // acts as the user's id
  late String password;
  late String? biography;
  late String userType;
  late String user_id;
  late String? token;

  /// Constructs a User object with the specified [fullName],[image], [email], [password], [biograpghy], and [token].
  CustomUser(
      {required this.fullName,
      required this.userName,
      this.image,
      required this.email,
      required this.password,
      this.biography,
      this.phoneNumber,
      String userId = ''}) {
    userType = getUserType();
    token = '';
    user_id = (userId == '') ? userName ?? "${DateTime.now()}" : userId;
  }
  CustomUser.edit({
    this.fullName,
    this.userName,
    this.biography,
    this.phoneNumber,
  });
  CustomUser.dummy(
      {required this.fullName,
      required this.userName,
      required this.image,
      required this.email,
      required this.password,
      required this.biography,
      required this.userType});

  /// Constructs a User object from a JSON map.
  CustomUser.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    userName = json['userName'];
    phoneNumber = json['phoneNumber'];
    image = json['image'];
    email = json['email'];
    biography = json['biography'];
    password = json['password'];
    userType = json['userType'] == 'admin'
        ? UserType.admin
        : json['userType'] == 'student'
            ? UserType.student
            : UserType.staff;
    user_id = json['user_id'];
    token = json['token'];
  }

  /// Converts the User object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['userName'] = this.userName;
    data['phoneNumber'] = this.phoneNumber;
    data['image'] = this.image;
    data['email'] = this.email;
    data['password'] = this.password;
    data['biography'] = this.biography;
    data['userType'] = this.userType.toString();
    data['user_id'] = this.user_id;
    data['token'] = this.token;
    return data;
  }

  String getUserType() {
    try {
      String split = this.email.split('@')[1];
      split = split.split('.')[0];
      split = split.toLowerCase();
      if (split == 'student') {
        return UserType.student;
      } else if (split == 'gucconnect') {
        return UserType.admin;
      } else {
        return UserType.staff;
      }
    } catch (e) {
      return UserType.staff;
    }
  }

  updateToken(String token) async {
    this.token = token;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(this.user_id)
        .update({'token': token});
  }

  @override
  String toString() {
    return 'fullName: $fullName, email: $email, password: $password, token: $token';
  }
}
