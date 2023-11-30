import 'package:GUConnect/src/models/User.dart';

/// Represents an academic question.
class AcademicQuestion {
  late String? id;
  late String content;
  late CustomUser user;
  late String image;
  late DateTime createdAt;

  /// Constructs an [AcademicQuestion] object with the given [content], [user], and [image].
  AcademicQuestion(
      {required this.content,
      required this.user,
      required this.image,
      required this.createdAt});

  /// Constructs an [AcademicQuestion] object from a JSON map.
  AcademicQuestion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    user = CustomUser.fromJson(json['user']);
    image = json['image'];
    createdAt = DateTime.parse(json['createdAt']);
  }

  /// Converts the [AcademicQuestion] object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['user'] = user.toJson();
    data['image'] = image;
    data['createdAt'] = createdAt.toString();
    return data;
  }

  /// Uploads the image associated with the question.
  void uploadImage() {
    // TODO: implement uploadImage
  }

  @override
  String toString() {
    return 'content: $content, user: $user, image: $image';
  }
}
