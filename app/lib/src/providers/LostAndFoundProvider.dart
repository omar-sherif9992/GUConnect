import 'package:GUConnect/src/models/LostAndFound.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LostAndFoundProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> postItem(LostAndFound item) async {
    try {
      await _firestore.collection('lostAndFound').add(item.toJson());
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

    if(querySnapshot.docs.isNotEmpty)
    {
      await _firestore.collection('lostAndFound').doc(querySnapshot.docs.first.id)
      .delete();
    }
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
