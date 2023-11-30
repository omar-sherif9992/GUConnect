import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GUConnect/src/models/NewsEventClub.dart';

class NewsEventClubProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> postContent(NewsEventClub post) async {
    try {
      await _firestore.collection('newsEventClubs').add(post.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> requestApproval(String postId) async {
    await _firestore
        .collection('newsEventClubs')
        .doc(postId)
        .update({'approvalStatus': 'requested'});
  }

  Future<void> approvePost(String postId) async {
    await _firestore
        .collection('newsEventClubs')
        .doc(postId)
        .update({'approvalStatus': 'approved'});
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
}
