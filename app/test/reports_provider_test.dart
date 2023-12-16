import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/models/Reports.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/ReportsProvider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final instance = FakeFirebaseFirestore();
  test("report a confession and a comment and delete them", () async {
    final ReportsProvider p = ReportsProvider(instance);
    final CustomUser user = CustomUser(
      fullName: 'a b c',
      userName: 'abc',
      email: 'a@guc.edu.eg',
      password: 'abcdef1',
    );
    Confession c = Confession(
      isAnonymous: false,
      content: 'confession',
      sender: user,
      createdAt: DateTime.now(),
    );

    Report r = Report(
        reportedContentId: c.id,
        reportedUser: c.sender,
        reportedContent: c.content,
        reportType: "confession",
        createdAt: DateTime.now(), reason: 'Other');
    Comment c2 = Comment(
        content: "comment",
        commenter: user,
        createdAt: DateTime.now(),
        postType: 0);
    expect(await p.getCommentReports(), isEmpty);
    expect(await p.getConfessionReports(), isEmpty);
    await p.reportContent(r);
    expect(await p.getConfessionReports(), isNotEmpty);

    Report r2 = Report(
        reportedContentId: c2.id,
        reportedUser: c2.commenter,
        reportedContent: c2.content,
        reportType: "comment",
        createdAt: DateTime.now(), reason: 'Harrasment');
    await p.reportContent(r2);
    expect(await p.getCommentReports(), isNotEmpty);

    await p.approveReport(r);
    expect(await p.getConfessionReports(), isEmpty);
    await p.approveReport(r2);
    expect(await p.getCommentReports(), isEmpty);

    await p.reportContent(r);
    await p.reportContent(r2);
    await p.disapproveReport(r);
    expect(await p.getConfessionReports(), isEmpty);
    await p.disapproveReport(r2);
    expect(await p.getCommentReports(), isEmpty);
  });
}
