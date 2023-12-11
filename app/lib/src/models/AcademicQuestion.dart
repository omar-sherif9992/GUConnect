import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/Post.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents an academic question.
class AcademicQuestion extends Post {
  AcademicQuestion({
    String? id,
    required super.content,
    required super.sender,
    required super.createdAt,
    required super.image,
  }){
    this.id = FirebaseFirestore.instance.collection('academicRelatedQuestions').doc().id; 
  }

  void uploadImage() {}

  AcademicQuestion.fromJson(Map<String, dynamic> json)
      : super(
          content: json['content'],
          sender: CustomUser.fromJson(json['sender']),
          createdAt: DateTime.parse(json['createdAt']),
          image: json['image'],
        ) {
    id = json['id'];
    comments = ((json['comments'] as List<dynamic>)
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))).toList();
  }

   @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['id'] = id;
    data['comments'] = comments.map((c) => c.toJson()).toList();
    return data;
  }

}
