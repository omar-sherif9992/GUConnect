import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a lost and found item.
class LostAndFound {
  late String id;
  late String content;
  late String image;
  late String contact;
  late DateTime createdAt;
  late CustomUser user;
  late Set<String> likes = <String>{};
  late List<Comment> comments = [];

  /// Constructs a [LostAndFound] object with the given [content], [image], [location], and [contact].
  LostAndFound({
    required this.content,
    required this.image,
    //required this.location,
    required this.contact,
    required this.createdAt,
    //required this.isFound,
    required this.user,
  }) : id = FirebaseFirestore.instance.collection('lostAndFound').doc().id;

  /// Constructs a [LostAndFound] object from a JSON [Map].
  LostAndFound.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    image = json['image'];
    contact = json['contact'];
    createdAt = DateTime.parse(json['createdAt']);
    user = CustomUser.fromJson(json['user']);
    if (json.containsKey('likes') && json['likes'] != null) {
      likes = Set<String>.from(json['likes']);
    } else {
      // Handle the case where 'likes' is not present or is null
      likes = Set<String>(); // or any other default value or error handling strategy
    }
    comments = ((json['comments'] as List<dynamic>).map( (e) => Comment.fromJson(e as Map<String, dynamic>)) ).toList();
    
  }

  /// Converts the [LostAndFound] object to a JSON [Map].
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, Object>{};
    data['id'] = id;
    data['content'] = content;
    data['image'] = image;
    data['contact'] = contact;
    data['createdAt'] = createdAt.toString();
    data['user'] = user.toJson();
    data['likes'] = likes;
    data['comments'] = comments.map((c)=> c.toJson()).toList();
    return data;
  }

  /// Uploads the image associated with the lost and found item.
  void uploadImage() {
    // TODO: implement uploadImage
  }

  @override
  String toString() {
    return 'content: $content, image: $image, contact: $contact, createdAt: $createdAt, user: $user';
  }
}
