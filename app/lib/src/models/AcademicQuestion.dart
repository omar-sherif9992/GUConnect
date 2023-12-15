import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/Post.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents an academic question.
class AcademicQuestion extends Post {

  late Set<String> likes;
  late List<Comment> comments;

  AcademicQuestion({
    required super.content,
    required super.sender,
    required super.createdAt,
    required this.likes,
    required this.comments,
    super.image,
  });

  void uploadImage() {}

  factory AcademicQuestion.fromJson(Map<String, dynamic> json) {
    final academicQuestion = AcademicQuestion(
      content: json['content'] ?? '',
      sender: CustomUser.fromJson(json['sender'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      image: json['image'] ?? '',
      likes: Set<String>.from(json['likes']),
      comments: (json['comments'] as List<dynamic>? ?? [])
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))
        .toList()
    );
    academicQuestion.id = json['id'] ?? ''; // Include id with null check

    academicQuestion.comments = (json['comments'] as List<dynamic>? ?? [])
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))
        .toList();
    return academicQuestion;
  }

  // Override toJson method to include only necessary fields
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    // You can add additional fields specific to AcademicQuestion here
    json['likes'] = likes;
    json['comments'] = comments.map((c) => c.toJson()).toList();
    return json;
  }

  @override
  String toString() {
    return super.toString();
  }
}
