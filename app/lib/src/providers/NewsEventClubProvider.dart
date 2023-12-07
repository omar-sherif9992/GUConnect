import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GUConnect/src/models/NewsEventClub.dart';
import 'package:flutter/foundation.dart';

class NewsEventClubProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> postContent(NewsEventClub post) async {
    try {
      await _firestore.collection('newsEventClubs').add(post.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> requestApproval(String postId) async {
    await _firestore
        .collection('newsEventClubs')
        .doc(postId)
        .update({'approvalStatus': 'requested'});
  }

  Future<void> approvePost(NewsEventClub newsEventClub) async {
    print(newsEventClub.id);
    try {
      await _firestore
          .collection('newsEventClubs')
          .doc(newsEventClub.id)
          .update({'approvalStatus': 'approved'});
    } catch (e) {
      print(e);
    }
  }

  Future<void> disapprovePost(NewsEventClub newsEventClub) async {
    try {
      print(newsEventClub.id);
      await _firestore
          .collection('newsEventClubs')
          .doc(newsEventClub.id)
          .update({'approvalStatus': 'disapproved'});
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePost(String postId) async {
    await _firestore.collection('newsEventClubs').doc(postId).delete();
  }

  Future<List<NewsEventClub>> getPosts() async {
    final List<NewsEventClub> posts = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('newsEventClubs').get();
    querySnapshot.docs.forEach((doc) {
      posts.add(NewsEventClub.fromJson(doc.data()));
    });
    return posts;
  }

  Future<List<NewsEventClub>> getApprovedPosts() async {
    final List<NewsEventClub> posts = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('newsEventClubs')
        .where('approvalStatus', isEqualTo: 'approved')
        .get();
    querySnapshot.docs.forEach((doc) {
      posts.add(NewsEventClub.fromJson(doc.data()));
    });
    return posts;
  }

  Future<List<NewsEventClub>> getRequestedApprovalPosts() async {
    final List<NewsEventClub> posts = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('newsEventClubs')
        .where('approvalStatus', isEqualTo: 'requested')
        .get();
    querySnapshot.docs.forEach((doc) {
      posts.add(NewsEventClub.fromJson(doc.data()));
    });
    return posts;
  }

  Future<List<dynamic>> likePost(String postId, String userId) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('newsEventClubs')
        .where('id', isEqualTo: postId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

      final List<dynamic> likesOfPost = documentSnapshot['likes'] ?? [];
      likesOfPost.add(userId);

      await FirebaseFirestore.instance
          .collection('newsEventClubs')
          .doc(documentSnapshot.id)
          .update({
        'likes': FieldValue.arrayUnion([userId]),
      });

      return likesOfPost;
    }
    return [];
  }

  Future<List<dynamic>> dislike(String postId, String userId) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('newsEventClubs')
        .where('id', isEqualTo: postId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

      final List<dynamic> likesOfPost = documentSnapshot['likes'] ?? [];

      likesOfPost.remove(userId);

      await FirebaseFirestore.instance
          .collection('newsEventClubs')
          .doc(documentSnapshot.id)
          .update({
        'likes': likesOfPost,
      });

      return likesOfPost;
    }
    return [];
  }
}
