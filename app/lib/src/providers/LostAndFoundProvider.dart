import 'package:GUConnect/src/models/LostAndFound.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LostAndFoundProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> postItem(LostAndFound Item) async {
    await _firestore.collection('lostAndFound').add(Item.toJson());
  }

  Future<void> uploadImage(String itemId, String imageUrl) async {
    await _firestore
        .collection('lostAndFound')
        .doc(itemId)
        .update({'image': imageUrl});
  }

  Future<void> deleteItem(String itemId) async {
    await _firestore.collection('lostAndFound').doc(itemId).delete();
  }

  Future<List<LostAndFound>> getItems() async {
    final List<LostAndFound> items = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('lostAndFound')
        .orderBy('createdAt', descending: true)
        .get();
    querySnapshot.docs.forEach((doc) {
      items.add(LostAndFound.fromJson(doc.data()));
    });
    return items;
  }
}
