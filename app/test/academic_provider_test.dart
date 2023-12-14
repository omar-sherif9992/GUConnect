import 'package:GUConnect/src/models/AcademicQuestion.dart';
import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/AcademicQuestionProvider.dart';
import 'package:GUConnect/src/providers/ConfessionProvider.dart';
import 'package:GUConnect/src/screens/common/AcademicRelated/academicRelated.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final instance = FakeFirebaseFirestore();
  test("create a post and make sure it is saved as mine and delete it",
      () async {
    final AcademicQuestionProvider provider =
        AcademicQuestionProvider(instance);

    final CustomUser user = CustomUser(
      fullName: 'a b c',
      userName: 'abc',
      email: 'a@guc.edu.eg',
      password: 'abcdef1',
    );
    AcademicQuestion q = AcademicQuestion(
      content: 'academic question',
      sender: user,
      createdAt: DateTime.now(),
    );

    await provider.askQuestion(q);
    expect(await provider.getQuestions(), isNotEmpty);
    List<AcademicQuestion> myQuestions =
        await provider.getMyQuestions('a@guc.edu.eg');
    expect(myQuestions, isNotEmpty);
    await provider.deleteQuestion(q.id);
    List<AcademicQuestion> l = await provider.getQuestions();
    expect(l, isEmpty);
  });
}
