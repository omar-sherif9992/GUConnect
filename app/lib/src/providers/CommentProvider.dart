import 'package:GUConnect/src/models/Comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GUConnect/src/models/NewsEventClub.dart';
import 'package:flutter/foundation.dart';

class CommentProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String getCollectionName(int value)
  {
    switch (value) {
    case 0:
      return 'newsEventClubs';
    case 1:
      return 'lostAndFound';
    case 2:
      return '';
    case 3:
      return '';

    default:
      return 'Unknown';
  }
  }

  Future<List<Comment>> getPostComments(String postId, int postType) async
  {
    final String collectionName = getCollectionName(postType);

    try {

      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
      .collection(collectionName)
      .where('id', isEqualTo: postId)
      .get();

      if(querySnapshot.docs.isEmpty)
      {
        return [];
      }

      switch(postType)
      {
        case 0:
        //print(NewsEventClub.fromJson(querySnapshot.docs.first.data()).comments);
        return NewsEventClub.fromJson(querySnapshot.docs.first.data()).comments;
        //To Be Continued;
      }
      return [];
      


    } catch (e) { 
      return [];
    }

  }

  Future<List<Comment>> addComment(Comment comment, String postId) async {

    final String collectionName = getCollectionName(comment.postType);

    try {
      await _firestore.collection('comments').add(comment.toJson());

       final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection(collectionName)
      .where('id', isEqualTo: postId)
      .get();


      if(querySnapshot.docs.isNotEmpty)
      {
        querySnapshot.docs.first.reference.update({'comments': FieldValue.arrayUnion([comment.toJson()])});

      }
      
      return getPostComments(postId, comment.postType);

    } catch (e) {  
      return [];
    }
  }

  Future<bool> editComment(String commentId, String newContnent) async {

    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('comments')
      .where('id', isEqualTo: commentId)
      .get();

      if(querySnapshot.docs.isNotEmpty)
      {
        querySnapshot.docs.first.reference.update({'content': newContnent});
      }

      return true;
    } catch (e) {  
      return false;
    }
  }


  Future<bool> removeComment(Comment comment, String postId) async{
    final String collectionName = getCollectionName(comment.postType);

    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('comments')
      .where('id', isEqualTo: comment.id)
      .get();

      if(querySnapshot.docs.isNotEmpty)
      {
        querySnapshot.docs.first.reference.delete();
      }
      querySnapshot = await FirebaseFirestore.instance
      .collection(collectionName)
      .where('id', isEqualTo: postId)
      .get();

      if (querySnapshot.docs.isNotEmpty) {
  
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        final List<dynamic> commentsOfPost = documentSnapshot['comments'] ?? [];
        commentsOfPost.remove(comment);

        await FirebaseFirestore.instance.collection(collectionName).doc(documentSnapshot.id).update({
          'comments': FieldValue.arrayUnion(commentsOfPost),
        });
      }
      return true;
    }
    catch(e)
    {
      return false;
    }
  }

}