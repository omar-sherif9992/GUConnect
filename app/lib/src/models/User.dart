/// Represents the type of a user in the application.
enum UserType {
  admin,
  student,
  stuff,
}

/// Represents a user in the application.
class User {
  late String name;
  late String email;
  late String password;
  late String token;
  late UserType userType;

  /// Constructs a User object with the specified [name], [email], [password], and [token].
  User({
    required this.name,
    required this.email,
    required this.password,
    required this.token,
  });

  /// Constructs a User object from a JSON map.
  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    token = json['token'];
  }

  /// Converts the User object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['token'] = this.token;
    return data;
  }

  /// Sets the user type based on the provided [userType] string.
  void setUserType(String userType) {
    switch (userType) {
      case 'admin':
        this.userType = UserType.admin;
        break;
      case 'student':
        this.userType = UserType.student;
        break;
      case 'stuff':
        this.userType = UserType.stuff;
        break;
      default:
        this.userType = UserType.student;
    }
  }

  @override
  String toString() {
    return 'name: $name, email: $email, password: $password, token: $token';
  }
}
