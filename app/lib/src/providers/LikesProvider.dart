import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LikesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  LikesProvider(FirebaseFirestore firestore) : _firestore = firestore;
  String getCollectionName(int value) {
    switch (value) {
      case 0:
        return 'newsEventClubs';
      case 1:
        return 'lostAndFound';
      case 2:
        return 'academicRelatedQuestions';
      case 3:
        return 'confessions';

      default:
        return 'Unknown';
    }
  }

  Future<List<dynamic>> likePost(
      String postId, String userId, int postType) async {
    final String collection = getCollectionName(postType);
    final QuerySnapshot querySnapshot = await _firestore
        .collection(collection)
        .where('id', isEqualTo: postId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

      final List<dynamic> likesOfPost = documentSnapshot['likes'] ?? [];
      likesOfPost.add(userId);

      await FirebaseFirestore.instance
          .collection(collection)
          .doc(documentSnapshot.id)
          .update({
        'likes': FieldValue.arrayUnion([userId]),
      });

      return likesOfPost;
    }
    return [];
  }

  Future<List<dynamic>> dislike(
      String postId, String userId, int postType) async {
    final String collection = getCollectionName(postType);
    final QuerySnapshot querySnapshot = await _firestore
        .collection(collection)
        .where('id', isEqualTo: postId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

      final List<dynamic> likesOfPost = documentSnapshot['likes'] ?? [];

      likesOfPost.remove(userId);

      await FirebaseFirestore.instance
          .collection(collection)
          .doc(documentSnapshot.id)
          .update({
        'likes': likesOfPost,
      });

      return likesOfPost;
    }
    return [];
  }
}
