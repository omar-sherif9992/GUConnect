import 'package:GUConnect/src/models/User.dart';

/**
NewsEventClub	- Content
- Image
- Approval status	- Post content
- Request approval
- Get all events , posts
*/

class NewsEventClub {
  late String id = '1';
  late CustomUser poster;
  late String content;
  late String image;
  late String approvalStatus = 'approved';
  late DateTime createdAt;

  NewsEventClub({
    required this.content,
    required this.poster,
    required this.image,
    required this.createdAt,
  });

  NewsEventClub.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    image = json['image'];
    approvalStatus = json['approvalStatus'];
    createdAt = DateTime.parse(json['createdAt']);
    poster = CustomUser.fromJson((json['poster'] as Map<String, dynamic>));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['image'] = image;
    data['approvalStatus'] = approvalStatus;
    data['createdAt'] = createdAt.toString();
    data['poster'] = poster.toJson();
    return data;
  }

  @override
  String toString() {
    return 'content: $content, image: $image, approvalStatus: $approvalStatus , createdAt: ${createdAt.toString()}, poster: ${poster.toString()}';
  }
}
