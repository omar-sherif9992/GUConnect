/// Represents the type of a user in the application.

enum UserType {
  admin,
  student,
  professor,
  ta,
  stuff,
}

/// Represents a user in the application.
class CustomUser {
  late String id;
  late String? fullName;
  late String? userName;
  late String? phoneNumber;
  late String? image;
  late String email;
  late String password;
  late String? biography;
  late UserType userType;

  /// Constructs a User object with the specified [fullName],[image], [email], [password], [biograpghy], and [token].
  CustomUser({
    required this.id,
    this.fullName,
    this.userName,
    this.image,
    required this.email,
    required this.password,
    this.biography,
    this.phoneNumber,
  }) {
    this.userType = getUserType();
  }
  CustomUser.dummy(
      {required this.id,
      required this.fullName,
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
  }

  /// Converts the User object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['userName'] = this.userName;
    data['phoneNumber'] = this.phoneNumber;
    data['image'] = this.image;
    data['email'] = this.email;
    data['password'] = this.password;
    data['biography'] = this.biography;
    return data;
  }

  UserType getUserType() {
    String split = this.email.split('@')[1];
    split = split.split('.')[0];
    split = split.toLowerCase();
    if (split == 'student') {
      return UserType.student;
    } else if (split == 'gucconnect') {
      return UserType.admin;
    } else {
      return UserType.stuff;
    }
  }

  @override
  String toString() {
    return 'fullName: $fullName, email: $email, password: $password';
  }
}
