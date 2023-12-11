import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/models/Post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a lost and found item.
class LostAndFound extends Post {
  late String contact;

  /// Constructs a [LostAndFound] object with the given [content], [image], [location], and [contact].
  LostAndFound({
    String? id,
    required this.contact,
    required super.content,
    required super.createdAt,
    required super.image,
    required super.sender,
  }) {
    this.id = FirebaseFirestore.instance.collection('lostAndFound').doc().id;
    }  

  LostAndFound.fromJson(Map<String, dynamic> json)
      : super(
          content: json['content'],
          sender: CustomUser.fromJson(json['sender']),
          createdAt: DateTime.parse(json['createdAt']),
          image: json['image'],
        ) {
    id = json['id'];
    contact = json['contact'];
    comments = ((json['comments'] as List<dynamic>)
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))).toList();
  }

  /// Converts the [LostAndFound] object to a JSON [Map].
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['id'] = id;
    data['contact'] = contact;
    data['comments'] = comments.map((c) => c.toJson()).toList();
    return data;
  }

  void uploadImage() {}

  @override
  String toString() {
    return '${super.toString()} contact: $contact';
  }
}
