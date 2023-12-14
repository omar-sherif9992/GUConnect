import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GUConnect/src/models/AcademicQuestion.dart';
import 'package:flutter/foundation.dart';

class AcademicQuestionProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  AcademicQuestionProvider(FirebaseFirestore firestore)
      : _firestore = firestore;

  Future<bool> askQuestion(AcademicQuestion question) async {
    await _firestore
        .collection('academicRelatedQuestions')
        .doc(question.id)
        .set(question.toJson());
    ;
    return true;
  }

  Future<void> uploadImage(String id, String imageUrl) async {
    await _firestore
        .collection('academicRelatedQuestions')
        .doc(id)
        .update({'image': imageUrl});
  }

  Future<void> rateProfessor(String id, int rating) async {
    await _firestore
        .collection('academicRelatedQuestions')
        .doc(id)
        .update({'rating': rating});
  }

  Future<void> deleteQuestion(String id) async {
    try {
      await _firestore.collection('academicRelatedQuestions').doc(id).delete();
    } catch (e) {
      print("Error deleting question: $e");
      // Handle the error as needed
    }
  }

  Future<List<AcademicQuestion>> getQuestions() async {
    final List<AcademicQuestion> questions = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('academicRelatedQuestions').get();
    querySnapshot.docs.forEach((doc) {
      questions.add(AcademicQuestion.fromJson(doc.data()));
    });
    return questions;
  }

  Future<List<AcademicQuestion>> getMyQuestions(String email) async {
    print("email " + email);
    final List<AcademicQuestion> questions = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('academicRelatedQuestions')
        .where('sender.email', isEqualTo: email)
        .get();
    querySnapshot.docs.forEach((doc) {
      questions.add(AcademicQuestion.fromJson(doc.data()));
    });
    return questions;
  }
}
