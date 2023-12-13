import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/models/NewsEventClub.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/screens/common/clubsAndEvents.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final instance = FakeFirebaseFirestore();
  test("create a club post", () async {
    final NewsEventClubProvider newsEventClubProvider =
        NewsEventClubProvider(instance);
    final CustomUser user = CustomUser(
      fullName: 'a b c',
      userName: 'abc',
      email: 'a@guc.edu.eg',
      password: 'abcdef1',
    );
    user.token = 'x';
    // await newsEventClubProvider.approvePost();
    // expect(await confessionProvider.getConfessions(), isNotEmpty);
  });
}
