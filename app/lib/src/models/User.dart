enum UserType { admin, student, stuff }

class User {
  late String name;
  late String email;
  late String password;
  late String token;
  late UserType userType;

  User(
      {required this.name,
      required this.email,
      required this.password,
      required this.token});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['token'] = this.token;
    return data;
  }

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
}
