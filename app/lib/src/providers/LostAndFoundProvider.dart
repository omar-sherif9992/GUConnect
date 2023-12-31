import 'package:GUConnect/src/models/LostAndFound.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LostAndFoundProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  LostAndFoundProvider(FirebaseFirestore firestore) : _firestore = firestore;
  Future<bool> postItem(LostAndFound item) async {
    try {
      await _firestore
          .collection('lostAndFound')
          .doc(item.id)
          .set(item.toJson());
      return true;
    } catch (e) {
      print('Problem Happened ' + e.toString());
      return false;
    }
  }

  Future<void> uploadImage(String itemId, String imageUrl) async {
    await _firestore
        .collection('lostAndFound')
        .doc(itemId)
        .update({'image': imageUrl});
  }

  Future<void> deleteItem(String itemId) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('lostAndFound')
        .where('id', isEqualTo: itemId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await _firestore
          .collection('lostAndFound')
          .doc(querySnapshot.docs.first.id)
          .delete();
    }
  }

  Future<LostAndFound> getItemById(String id) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('lostAndFound')
        .where('id', isEqualTo: id)
        .get();
    return LostAndFound.fromJson(querySnapshot.docs.first.data());
  }

  Future<List<LostAndFound>> getItems() async {
    final List<LostAndFound> items = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('lostAndFound')
        .orderBy('createdAt', descending: true)
        .get();
    for (var doc in querySnapshot.docs) {
      items.add(LostAndFound.fromJson(doc.data()));
    }
    return items;
  }

  Future<List<LostAndFound>> getMyItems(String email) async {
    final List<LostAndFound> items = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('lostAndFound')
        .where('sender.email', isEqualTo: email)
        .orderBy('createdAt', descending: true)
        .get();
    querySnapshot.docs.forEach((doc) {
      items.add(LostAndFound.fromJson(doc.data()));
    });
    return items;
  }

  Future<bool> updatePost(LostAndFound updatedPost, String initialId) async {
    try {
      final QuerySnapshot document = await _firestore
          .collection('lostAndFound')
          .where('id', isEqualTo: initialId)
          .get();

      if (document.docs.isNotEmpty) {
          await _firestore
              .collection('lostAndFound')
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
