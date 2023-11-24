import 'package:GUConnect/src/models/User.dart';

class AcademicQuestion {
  late String content;
  late User user;
  late String image;

  AcademicQuestion(
      {required this.content, required this.user, required this.image});

  AcademicQuestion.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    user = User.fromJson(json['user']);
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['user'] = user.toJson();
    data['image'] = image;
    return data;
  }

  void uploadImage() {
    // TODO: implement uploadImage
  }

  String toString() {
    return 'content: $content, user: $user, image: $image';
  }
}
