import 'package:GUConnect/src/models/AcademicQuestion.dart';
import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/models/LostAndFound.dart';
import 'package:GUConnect/src/models/NewsEventClub.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/CommentProvider.dart';
import 'package:GUConnect/src/providers/ConfessionProvider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final instance = FakeFirebaseFirestore();

  test("comment ,edit and delete on all post types", () async {
    final CommentProvider confessionProvider = CommentProvider(instance);
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
    NewsEventClub n = NewsEventClub(
        reason: "reason",
        content: "content",
        sender: user,
        createdAt: DateTime.now());
    AcademicQuestion aq = AcademicQuestion(
        content: "content", sender: user, createdAt: DateTime.now());
    LostAndFound lf = LostAndFound(
        contact: "contact",
        content: "content",
        createdAt: DateTime.now(),
        image: "some image",
        sender: user);
  });
}
