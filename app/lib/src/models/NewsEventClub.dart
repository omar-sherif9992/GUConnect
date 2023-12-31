import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/Post.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/**
NewsEventClub	- Content
- Image
- Approval status	- Post content
- Request approval
- Get all events , posts
*/

class NewsEventClub extends Post {
  //late CustomUser poster;
  late String approvalStatus = 'requested';
  late String reason;
  late Set<String> likes;
  late List<Comment> comments;

/*   NewsEventClub(Future fetchItems, {
    String? id,
    required this.content,
    required this.poster,
    required this.image,
    required this.createdAt,
    required this.reason,
  }): id = FirebaseFirestore.instance.collection('newsEventClubs').doc().id;
*/

  NewsEventClub({
    String? id,
    //required this.poster,
    required this.reason,
    required super.content,
    required super.sender,
    required super.createdAt,
    super.image,
    required this.comments,
    required this.likes
  });

  NewsEventClub.fromJson(Map<String, dynamic> json)
      : super(
          content: json['content'],
          sender: CustomUser.fromJson(json['sender']),
          createdAt: DateTime.parse(json['createdAt']),
          image: json['image'],
        ) {
    id = json['id'];
    approvalStatus = json['approvalStatus'];
    reason = json['reason'];
    comments = ((json['comments'] as List<dynamic>)
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))).toList();
    likes = Set<String>.from(json['likes']);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['id'] = id;
    data['approvalStatus'] = approvalStatus;
    data['reason'] = reason;
    data['comments'] = comments.map((c) => c.toJson()).toList();
    data['likes'] = likes;
    return data;
  }

  @override
  String toString() {
    return '${super.toString()} approvalStatus: $approvalStatus reason: $reason';
  }
}
