import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:GUConnect/src/models/Post.dart';

class PostProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPost(Post post) async {
    await _firestore.collection('posts').add(post.toJson());
  }

  Future<void> deletePost(String id) async {
    await _firestore.collection('posts').doc(id).delete();
  }

  Future<List<Post>> getPosts() async {
    final List<Post> posts = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('posts').get();
    querySnapshot.docs.forEach((doc) {
      posts.add(Post.fromJson(doc.data()));
    });
    return posts;
  }
}
