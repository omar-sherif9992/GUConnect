import 'package:GUConnect/src/models/User.dart';

class Post {
  late String content;
  late CustomUser sender;
  late DateTime createdAt;
  late String id;
  late String image;
  late Set<String> likes;

  Post({
    required this.content,
    required this.sender,
    required this.createdAt,
    required this.image,
  }) {
    id = sender.email + createdAt.toString();
    likes = {};
  }

  Post.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    sender = CustomUser.fromJson(json['sender']);
    createdAt = DateTime.parse(json['createdAt']);
    image = json['image'];
    likes = Set<String>.from(json['likes']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['sender'] = sender.toJson();
    data['createdAt'] = createdAt.toString();
    data['image'] = image;
    data['likes'] = likes;
    return data;
  }

  @override
  String toString() {
    return 'content: $content, sender: $sender, createdAt: $createdAt, image: $image likes: $likes';
  }
}
