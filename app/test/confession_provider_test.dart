import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/ConfessionProvider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final instance = FakeFirebaseFirestore();

  test("create a confession", () async {
    final ConfessionProvider confessionProvider = ConfessionProvider(instance);
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
        image: 'x');
    await confessionProvider.addConfession(c);
    expect(await confessionProvider.getConfessions(), isNotEmpty);

    await confessionProvider.deleteConfession(c.id);
    expect(await confessionProvider.getConfessions(), isEmpty);
  });
}
