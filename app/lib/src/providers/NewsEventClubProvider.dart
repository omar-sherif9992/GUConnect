import 'package:GUConnect/src/services/notification_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GUConnect/src/models/NewsEventClub.dart';
import 'package:flutter/foundation.dart';

class NewsEventClubProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  NewsEventClubProvider(FirebaseFirestore firestore) : _firestore = firestore;
  Future<bool> postContent(NewsEventClub post) async {
    try {
      await _firestore
          .collection('newsEventClubs')
          .doc(post.id)
          .set(post.toJson());
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
    try {
      final QuerySnapshot document = await _firestore
          .collection('newsEventClubs')
          .where('id', isEqualTo: newsEventClub.id)
          .get();

      if (document.docs.isNotEmpty) {
        await _firestore
            .collection('newsEventClubs')
            .doc(document.docs.first.id)
            .update({'approvalStatus': 'approved'});

       await  FirebaseNotification.sendPostApprovalNotification(
            newsEventClub.sender.fullName ?? 'User',
            newsEventClub.sender.token ?? '',
            newsEventClub.id,
            'News Event Club Accepted',
            'Admin');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> disapprovePost(NewsEventClub newsEventClub) async {
    try {
      final QuerySnapshot document = await _firestore
          .collection('newsEventClubs')
          .where('id', isEqualTo: newsEventClub.id)
          .get();

      if (document.docs.isNotEmpty) {
        await _firestore
            .collection('newsEventClubs')
            .doc(document.docs.first.id)
            .update({'approvalStatus': 'disapproved'});

            
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePost(String postId) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('newsEventClubs')
        .where('id', isEqualTo: postId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await _firestore
          .collection('newsEventClubs')
          .doc(querySnapshot.docs.first.id)
          .delete();
    }
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

  Future<List<NewsEventClub>> getMyPosts(String email) async {
    final List<NewsEventClub> posts = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('newsEventClubs')
        .where('sender.email', isEqualTo: email)
        .get();
    querySnapshot.docs.forEach((doc) {
      posts.add(NewsEventClub.fromJson(doc.data()));
    });
    return posts;
  }

  Future<bool> updatePost(NewsEventClub updatedPost, String initialId) async {
    try {
      final QuerySnapshot document = await _firestore
          .collection('newsEventClubs')
          .where('id', isEqualTo: initialId)
          .get();

      if (document.docs.isNotEmpty) {
          await _firestore
              .collection('newsEventClubs')
              .doc(document.docs.first.id)
              .update(updatedPost.toJson());
          return true;
      }
      return true;
    } catch (e) {
      print('Error updating post: $e');
      return false;
    }
  }

}
