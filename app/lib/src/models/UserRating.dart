import 'package:cloud_firestore/cloud_firestore.dart';

class UserRating {
  String? id;
  late String userId;
  late double rating;
  String? comment;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  UserRating({
    this.id,
    required this.userId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  UserRating.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    rating = json['rating'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
  }
}
