import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/User.dart';

class Post {
  late String content;
  late CustomUser sender;
  late DateTime createdAt;
  late String id;
  late String image;
  late Set<String> likes;
  late List<Comment> comments;

  Post({
    required this.content,
    required this.sender,
    required this.createdAt,
    this.image = '',
  }) {
    id = sender.email + createdAt.toString();
    likes = {};
    comments = [];
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      content: json['content'] ?? '',
      sender: CustomUser.fromJson(json['sender'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      image: json['image'] ?? '',
    )..id = json['id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'sender': sender.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'id': id,
      'image': image,
      'likes': likes.toList(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return ' id: $id content: $content, sender: $sender, createdAt: $createdAt, image: $image likes: $likes';
  }
}
