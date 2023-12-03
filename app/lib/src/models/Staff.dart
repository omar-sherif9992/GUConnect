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
      return 'Stuff';
    }
  }

  static String getStaffTypeValue(String staffType) {
    if (staffType == 'professor') {
      return StaffType.professor;
    } else if (staffType == 'ta') {
      return StaffType.ta;
    } else {
      return 'Stuff';
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

class Rating {
  late String userEmail;
  late double rating;
  Rating({required this.userEmail, required this.rating});

  Rating.fromJson(Map<String, dynamic> json) {
    userEmail = json['userEmail'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userEmail'] = this.userEmail;
    data['rating'] = this.rating;
    return data;
  }
}

class Staff {
  late String fullName;
  late String? image;
  late String email;
  late String staffType;
  late String? officeLocation;
  // late List<OfficeHour> officeHours;
  late List<String> courses;
  late List<Rating> ratings;
  

  /// Constructs a User object with the specified [fullName],[image], [email], [password], [biograpghy], and [token].
  Staff({
    required this.fullName,
    this.image,
    required this.email,
    this.officeLocation,
    //required this.officeHours,
    required this.staffType,
  });

  /// Constructs a User object from a JSON map.
  Staff.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    image = json['image'];
    email = json['email'];
    officeLocation = json['officeLocation'];
    //officeHours = OfficeHour.fromJson(json['officeHours']) as List<OfficeHour>;
    staffType = StaffType.getStaffTypeValue(json['staffType']);
  }

  /// Converts the User object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['image'] = this.image;
    data['email'] = this.email;
    data['officeLocation'] = this.officeLocation;
    // data['officeHours'] = this.officeHours;
    data['staffType'] = StaffType.getStaffType(staffType);

    return data;
  }

  @override
  String toString() {
    return 'fullName: $fullName, email: $email, staffType: $staffType';
  }
}