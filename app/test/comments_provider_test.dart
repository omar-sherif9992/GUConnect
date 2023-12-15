import 'package:GUConnect/src/models/AcademicQuestion.dart';
import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/models/LostAndFound.dart';
import 'package:GUConnect/src/models/NewsEventClub.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/AcademicQuestionProvider.dart';
import 'package:GUConnect/src/providers/CommentProvider.dart';
import 'package:GUConnect/src/providers/ConfessionProvider.dart';
import 'package:GUConnect/src/providers/LostAndFoundProvider.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final instance = FakeFirebaseFirestore();
  final CommentProvider commentProvider = CommentProvider(instance);
  final AcademicQuestionProvider aqProvider =
      AcademicQuestionProvider(instance);
  final ConfessionProvider confessionProvider = ConfessionProvider(instance);
  final LostAndFoundProvider lfProvider = LostAndFoundProvider(instance);
  final NewsEventClubProvider necProvider = NewsEventClubProvider(instance);
  test("comment and delete all post types", () async {
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
    await confessionProvider.addConfession(c);
    await necProvider.postContent(n);
    await aqProvider.askQuestion(aq);
    await lfProvider.postItem(lf);
    Comment comment = Comment(
        content: "content",
        commenter: user,
        createdAt: DateTime.now(),
        postType: 0);
    Comment comment1 = Comment(
        content: "content",
        commenter: user,
        createdAt: DateTime.now(),
        postType: 1);
    Comment comment2 = Comment(
        content: "content",
        commenter: user,
        createdAt: DateTime.now(),
        postType: 2);
    Comment comment3 = Comment(
        content: "content",
        commenter: user,
        createdAt: DateTime.now(),
        postType: 3);
    await commentProvider.addComment(comment, n.id);
    await commentProvider.addComment(comment1, lf.id);
    await commentProvider.addComment(comment2, aq.id);
    await commentProvider.addComment(comment3, c.id);
    LostAndFound res = (await lfProvider.getItems())[0];
    AcademicQuestion res1 = (await aqProvider.getQuestions())[0];
    Confession res2 = (await confessionProvider.getConfessions())[0];
    NewsEventClub res3 = (await necProvider.getPosts())[0];
    print("res");
    print(res);
    print("res1");
    print(res1);
    print("res2");
    print(res2);
    print("res3");
    print(res3);
    expect(res.likes.length, 0);
    expect(res1.likes.length, 0);
    expect(res2.likes.length, 0);
    expect(res3.likes.length, 0);
    await commentProvider.removeComment(comment, n.id);
    await commentProvider.removeComment(comment1, lf.id);
    await commentProvider.removeComment(comment2, aq.id);
    await commentProvider.removeComment(comment3, c.id);
    res = (await lfProvider.getItems())[0];
    res1 = (await aqProvider.getQuestions())[0];
    res2 = (await confessionProvider.getConfessions())[0];
    res3 = (await necProvider.getPosts())[0];
    expect(res.likes.length, 0);
    expect(res1.likes.length, 0);
    expect(res2.likes.length, 0);
    expect(res3.likes.length, 0);
  });
}
