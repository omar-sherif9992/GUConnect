import 'package:GUConnect/src/models/Post.dart';
import 'package:GUConnect/src/models/User.dart';

/// Represents an academic question.
class AcademicQuestion extends Post {
  AcademicQuestion({
    required super.content,
    required super.sender,
    required super.createdAt,
    required super.image,
  });

  void uploadImage() {}

  AcademicQuestion.fromJson(Map<String, dynamic> json)
      : super(
          content: json['content'],
          sender: CustomUser.fromJson(json['sender']),
          createdAt: DateTime.parse(json['createdAt']),
          image: json['image'],
        );
}
