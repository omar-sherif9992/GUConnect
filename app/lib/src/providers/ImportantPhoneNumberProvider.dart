import 'package:GUConnect/src/models/ImportantPhoneNumber.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ImportantPhoneNumberProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  Future<List<ImportantPhoneNumber>> searchNumber(String name) async {
    final List<ImportantPhoneNumber> numbers = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('importantPhoneNumbers')
        .where('name', isEqualTo: name)
        .get();
    querySnapshot.docs.forEach((doc) {
      numbers.add(ImportantPhoneNumber.fromJson(doc.data()));
    });
    return numbers;
  }

  Future<List<ImportantPhoneNumber>> getNumbers() async {
    final List<ImportantPhoneNumber> numbers = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('importantPhoneNumbers').get();
    querySnapshot.docs.forEach((doc) {
      numbers.add(ImportantPhoneNumber.fromJson(doc.data()));
    });
    return numbers;
  }

  Future<void> addNumber(ImportantPhoneNumber number) async {
    await _firestore
        .collection('importantPhoneNumbers')
        .doc(number.title)
        .set(number.toJson());
    notifyListeners();
  }
}
