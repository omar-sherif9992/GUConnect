import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/**
NewsEventClub	- Content
- Image
- Approval status	- Post content
- Request approval
- Get all events , posts
*/

class NewsEventClub {
  late String id;
  late CustomUser poster;
  late String content;
  late String image;
  late String approvalStatus = 'requested';
  late DateTime createdAt;
  late String reason;
  late Set<String> likes = {};
  late List<Comment> comments = [];

/*   NewsEventClub(Future fetchItems, {
    String? id,
    required this.content,
    required this.poster,
    required this.image,
    required this.createdAt,
    required this.reason,
  }): id = FirebaseFirestore.instance.collection('newsEventClubs').doc().id;
 */

  NewsEventClub( {
    required this.content,
    required this.poster,
    required this.image,
    required this.createdAt,
    required this.reason,
  }): id = FirebaseFirestore.instance.collection('newsEventClubs').doc().id;

  NewsEventClub.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    image = json['image'];
    approvalStatus = json['approvalStatus'];
    createdAt = DateTime.parse(json['createdAt']);
    poster = CustomUser.fromJson((json['poster'] as Map<String, dynamic>));
    reason = json['reason'];
    comments = ((json['comments'] as List<dynamic>).map( (e) => Comment.fromJson(e as Map<String, dynamic>)) ).toList();
    likes = Set<String>.from(json['likes']);
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['image'] = image;
    data['approvalStatus'] = approvalStatus;
    data['createdAt'] = createdAt.toString();
    data['poster'] = poster.toJson();
    data['reason'] = reason;
    data['comments'] = comments.map((c)=> c.toJson()).toList();
    data['likes'] = likes;
    return data;
  }

  @override
  String toString() {
    return 'content: $content, image: $image, approvalStatus: $approvalStatus , createdAt: ${createdAt.toString()}, poster: ${poster.toString()}, reason: $reason, comments: ${comments.map((e) => (c)=>c.toString())}';
  }
}
