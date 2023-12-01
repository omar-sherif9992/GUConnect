/// Represents the type of a user in the application.

enum StaffType {
  professor,
  ta,
}

class OfficeHour {
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
}

class Staff {
  late String fullName;
  late String? image;
  late String email;
  late StaffType staffType;
  late String? officeLocation;
  late List<OfficeHour> officeHours;
  late double rating;
  late List<String> reviews;
  late List<String> courses;

  /// Constructs a User object with the specified [fullName],[image], [email], [password], [biograpghy], and [token].
  Staff({
    required this.fullName,
    this.image,
    required this.email,
    this.officeLocation,
    required this.rating,
    required this.courses,
    required this.officeHours,
    required this.reviews,
    required this.staffType,
  });

  /// Constructs a User object from a JSON map.
  Staff.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    image = json['image'];
    email = json['email'];
    officeLocation = json['officeLocation'];
    rating = json['rating'];
    courses = json['courses'];
    officeHours = OfficeHour.fromJson(json['officeHours']) as List<OfficeHour>;
    reviews = json['reviews'];
    staffType = json['staffType'];
  }

  /// Converts the User object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['image'] = this.image;
    data['email'] = this.email;
    data['officeLocation'] = this.officeLocation;
    data['rating'] = this.rating;
    data['courses'] = this.courses;
    data['officeHours'] = this.officeHours;
    data['reviews'] = this.reviews;
    data['staffType'] = this.staffType;

    return data;
  }

  @override
  String toString() {
    return 'fullName: $fullName, email: $email, officeLocation: $officeLocation, rating: $rating, courses: $courses, officeHours: $officeHours, reviews: $reviews, staffType: $staffType';
  }
}
