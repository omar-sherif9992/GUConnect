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
    final QuerySnapshot querySnapshot = await _firestore
        .collection('academicRelatedQuestions')
        .where('id', isEqualTo: id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await _firestore
          .collection('academicRelatedQuestions')
          .doc(querySnapshot.docs.first.id)
          .delete();
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

  Future<bool> updatePost(AcademicQuestion updatedPost, String initialId) async {
    try {
      final QuerySnapshot document = await _firestore
          .collection('academicRelatedQuestions')
          .where('id', isEqualTo: initialId)
          .get();

      if (document.docs.isNotEmpty) {
          await _firestore
              .collection('academicRelatedQuestions')
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
