import 'package:GUConnect/src/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  late String id;
  late String content;
  late CustomUser commenter;
  late DateTime createdAt;
  late int postType;

  Comment({
    required this.content,
    required this.commenter,
    required this.createdAt,
    required this.postType,
  }) {
    id = createdAt.toString() + commenter.email;
  }

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    createdAt = DateTime.parse(json['createdAt']);
    postType = json['postType'];
    commenter = json['commenter'] != null
        ? CustomUser.fromJson(json['commenter'] as Map<String, dynamic>)
        : CustomUser(
            email: 'bla', password: 'bla', fullName: 'om', userName: 'ss');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['createdAt'] = createdAt.toString();
    data['commenter'] = commenter.toJson();
    data['postType'] = postType;
    return data;
  }

  @override
  String toString() {
    return 'content: $content, createdAt: ${createdAt.toString()}, commenter: ${commenter.toString()}, postType: $postType';
  }
}
