import 'package:GUConnect/src/models/ImportantEmail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ImportantEmailProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final importantEmailsRef = FirebaseFirestore.instance
      .collection('importantEmails')
      .withConverter<ImportantEmail>(
        fromFirestore: (snapshot, _) =>
            ImportantEmail.fromJson(snapshot.data()!),
        toFirestore: (importantEmail, _) => importantEmail.toJson(),
      );


  Future<List<ImportantEmail>> searchEmail(String name) async {
    final List<ImportantEmail> emails = [];
    final QuerySnapshot<ImportantEmail> querySnapshot =
        await importantEmailsRef.where('name', isEqualTo: name).get();

    querySnapshot.docs.forEach((doc) {
      emails.add(doc.data());
    });
    return emails;
  }

  Future<List<ImportantEmail>> getEmails() async {
    final List<ImportantEmail> emails = [];
    final QuerySnapshot<ImportantEmail> querySnapshot =
        await importantEmailsRef.get();
    querySnapshot.docs.forEach((doc) {
      emails.add(doc.data());
    });
    return emails;
  }

  Future<void> addEmail(ImportantEmail email) async {
    await importantEmailsRef.doc(email.title).set(email);
    notifyListeners();
  }
}
