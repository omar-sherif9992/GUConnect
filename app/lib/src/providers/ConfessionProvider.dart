import 'package:GUConnect/src/models/Confession.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ConfessionProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  ConfessionProvider(FirebaseFirestore firestore) : _firestore = firestore;

  Future<bool> addConfession(Confession confession) async {
   
      await _firestore
          .collection('confessions')
          .doc(confession.id)
          .set(confession.toJson());
      return true;

    
  }

  Future<void> deleteConfession(String id) async {
    await _firestore.collection('confessions').doc(id).delete();
  }

  Future<List<Confession>> getConfessions() async {
    final List<Confession> confessions = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('confessions').get();
    querySnapshot.docs.forEach((doc) {
      confessions.add(Confession.fromJson(doc.data()));
    });
    return confessions;
  }

  Future<List<Confession>> getMyConfessions(String email) async {
    final List<Confession> confessions = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('confessions')
        .where('sender.email', isEqualTo: email)
        .get();
    querySnapshot.docs.forEach((doc) {
      confessions.add(Confession.fromJson(doc.data()));
    });
    return confessions;
  }
}
