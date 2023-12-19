import 'package:GUConnect/src/models/AcademicQuestion.dart';
import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/models/LostAndFound.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GUConnect/src/models/NewsEventClub.dart';
import 'package:flutter/foundation.dart';

class CommentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  CommentProvider(FirebaseFirestore firestore) : _firestore = firestore;

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

  Future<List<Comment>> getPostComments(String postId, int postType) async {
    final String collectionName = getCollectionName(postType);

    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(collectionName)
              .where('id', isEqualTo: postId)
              .get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      switch (postType) {
        case 0:
          //print(NewsEventClub.fromJson(querySnapshot.docs.first.data()).comments);
          return NewsEventClub.fromJson(querySnapshot.docs.first.data())
              .comments;
        //To Be Continued;
        case 1:
          //print(NewsEventClub.fromJson(querySnapshot.docs.first.data()).comments);
          return LostAndFound.fromJson(querySnapshot.docs.first.data())
              .comments;
        case 2:
          //print(NewsEventClub.fromJson(querySnapshot.docs.first.data()).comments);
          return AcademicQuestion.fromJson(querySnapshot.docs.first.data())
              .comments;
        case 3:
          //print(NewsEventClub.fromJson(querySnapshot.docs.first.data()).comments);
          return Confession.fromJson(querySnapshot.docs.first.data()).comments;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Comment>> addComment(Comment comment, String postId) async {
    final String collectionName = getCollectionName(comment.postType);

    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('id', isEqualTo: postId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update({
          'comments': FieldValue.arrayUnion([comment.toJson()])
        });
      }
      return getPostComments(postId, comment.postType);
    } catch (e) {
      return [];
    }
  }

  Future<bool> editComment(String commentId, String newContnent, String postId, int postType) async {
    final String collectionName = getCollectionName(postType);
    try {

      final querySnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('id', isEqualTo: postId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        final List<dynamic> commentsOfPost = documentSnapshot['comments'] ?? [];
        final int indexToUpdate = commentsOfPost.indexWhere((comment) => comment['id'] == commentId);

            // Check if the commentId was found in the list
        if (indexToUpdate != -1) {
          // Update the comment at the found index
          commentsOfPost[indexToUpdate]['content'] = newContnent;
        }

        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(documentSnapshot.id)
            .update({
          'comments': commentsOfPost,
        });
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeComment(Comment comment, String postId) async {
    final String collectionName = getCollectionName(comment.postType);

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('id', isEqualTo: postId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        final List<dynamic> commentsOfPost = documentSnapshot['comments'] ?? [];
        commentsOfPost.removeWhere((commentt) => commentt['id'] == comment.id);

        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(documentSnapshot.id)
            .update({
          'comments': commentsOfPost,
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

}
