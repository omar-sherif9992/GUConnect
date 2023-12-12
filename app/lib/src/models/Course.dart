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

class Course {
  late String courseName;
  late String? image;
  late List<Rating> ratings;
  late String description;

  /// Constructs a Staff object with the specified [fullName],[image], [email], [password], [description], and [speciality].
  Course({
    required this.courseName,
    this.image,
    required this.description,
  });

  /// Constructs a User object from a JSON map.
  Course.fromJson(Map<String, dynamic> json) {
    courseName = json['courseName'];
    image = json['image'];
    description = json['description'];
    ratings = (json['ratings'] as List<dynamic>)
        .map((e) => Rating.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Converts the User object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseName'] = this.courseName;
    data['image'] = this.image;
    data['description'] = this.description;
    data['ratings'] = this.ratings.map((e) => e.toJson()).toList();

    return data;
  }

  @override
  String toString() {
    return 'courseName: $courseName, image: $image, description: $description, ratings: ${ratings.map((e) => e.toString())}';
  }
}
