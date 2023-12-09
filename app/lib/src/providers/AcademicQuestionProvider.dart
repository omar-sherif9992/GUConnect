import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GUConnect/src/models/AcademicQuestion.dart';
import 'package:flutter/foundation.dart';

class AcademicQuestionProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> askQuestion(AcademicQuestion question) async {
    await _firestore.collection('academicQuestions').add(question.toJson());
  }

  Future<void> uploadImage(String id, String imageUrl) async {
    await _firestore
        .collection('academicQuestions')
        .doc(id)
        .update({'image': imageUrl});
  }

  Future<void> rateProfessor(String id, int rating) async {
    await _firestore
        .collection('academicQuestions')
        .doc(id)
        .update({'rating': rating});
  }

  Future<void> deleteQuestion(String id) async {
    await _firestore.collection('academicQuestions').doc(id).delete();
  }

  Future<List<AcademicQuestion>> getQuestions() async {
    final List<AcademicQuestion> questions = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('academicQuestions').get();
    querySnapshot.docs.forEach((doc) {
      questions.add(AcademicQuestion.fromJson(doc.data()));
    });
    return questions;
  }

  Future<List<AcademicQuestion>> getMyQuestions(String email) async {
    final List<AcademicQuestion> questions = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('academicQuestions')
        .where('user.email', isEqualTo: email)
        .get();
    querySnapshot.docs.forEach((doc) {
      questions.add(AcademicQuestion.fromJson(doc.data()));
    });
    return questions;
  }
}
