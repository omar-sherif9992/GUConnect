import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GUConnect/src/models/Reports.dart';
import 'package:flutter/foundation.dart';

class ReportsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  ReportsProvider(FirebaseFirestore firestore) : _firestore = firestore;

  Future<bool> reportContent(Report report) async {
    try {
      await _firestore
          .collection('reports')
          .doc(report.id)
          .set(report.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> approveReport(Report report) async {
    try {
      final QuerySnapshot document = await _firestore
          .collection('reports')
          .where('id', isEqualTo: report.id)
          .get();

      if (document.docs.isNotEmpty) {
        await _firestore
            .collection('reports')
            .doc(document.docs.first.id)
            .delete();
        if (report.reportType == 'comment') {
          try {
            await _firestore
                .collection('comments')
                .doc(report.reportedContentId)
                .delete();
          } catch (e) {
            print(e); // comment already deleted from another report
          }
        } else if (report.reportType == 'confession') {
          try {
            await _firestore
                .collection('confessions')
                .doc(report.reportedContentId)
                .delete();
          } catch (e) {
            print(e); // confession already deleted from another report
          }
        }else if(report.reportType=='lostAndFound'){
          try {
            await _firestore
                .collection('lostAndFound')
                .doc(report.reportedContentId)
                .delete();
          } catch (e) {
            print(e); // confession already deleted from another report
          }
        }else if(report.reportType=='newsEventClubs'){
          try {
            await _firestore
                .collection('newsEventClubs')
                .doc(report.reportedContentId)
                .delete();
          } catch (e) {
            print(e); // confession already deleted from another report
          }
        }else if(report.reportType=='academicRelatedQuestions'){
          try {
            await _firestore
                .collection('academicRelatedQuestions')
                .doc(report.reportedContentId)
                .delete();
          } catch (e) {
            print(e); // confession already deleted from another report
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> disapproveReport(Report report) async {
    try {
      final QuerySnapshot document = await _firestore
          .collection('reports')
          .where('id', isEqualTo: report.id)
          .get();

      if (document.docs.isNotEmpty) {
        await _firestore
            .collection('reports')
            .doc(document.docs.first.id)
            .delete();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<Report>> getCommentReports() async {
    final List<Report> commentReports = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('reports')
        .where('reportType', isEqualTo: 'comments')
        .get();
    querySnapshot.docs.forEach((doc) {
      commentReports.add(Report.fromJson(doc.data()));
      commentReports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
    return commentReports;
  }

  Future<List<Report>> getConfessionReports() async {
    final List<Report> confessionReports = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('reports')
        .where('reportType', isEqualTo: 'confessions')
        .get();
    querySnapshot.docs.forEach((doc) {
      confessionReports.add(Report.fromJson(doc.data()));
      confessionReports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
    return confessionReports;
  }
  Future<List<Report>> getPostReports() async {
    final List<Report> postReports = [];
    // i want to get all the reports of type post wehre report type equals to lost and found or news event club or academic related questions
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('reports')
        .where('reportType', whereIn: ['lostAndFound', 'newsEventClubs','academicRelatedQuestions'])
        .get();
    querySnapshot.docs.forEach((doc) {
      postReports.add(Report.fromJson(doc.data()));
      postReports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
    return postReports;
  }
}
