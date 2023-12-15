import 'package:GUConnect/src/models/NewsEventClub.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final instance = FakeFirebaseFirestore();
  test("create a post and make sure it is saved as mine and delete it",
      () async {
    final NewsEventClubProvider provider = NewsEventClubProvider(instance);

    final CustomUser user = CustomUser(
      fullName: 'a b c',
      userName: 'abc',
      email: 'a@guc.edu.eg',
      password: 'abcdef1',
    );
    NewsEventClub q = NewsEventClub(
        content: 'academic question',
        sender: user,
        createdAt: DateTime.now(),
        reason: 'IEEE club bla bla', comments: [], likes: {});
    await provider.postContent(q);
    expect(await provider.getPosts(), isNotEmpty);
    await provider.requestApproval(q.id);
    expect(await provider.getRequestedApprovalPosts(), isNotEmpty);
    await provider.approvePost(q);
    expect(await provider.getRequestedApprovalPosts(), isEmpty);
    expect(await provider.getApprovedPosts(), isNotEmpty);
    await provider.requestApproval(q.id);
    await provider.disapprovePost(q);
    expect(await provider.getRequestedApprovalPosts(), isEmpty);
    expect(await provider.getPosts(), isNotEmpty);
    expect(await provider.getApprovedPosts(), isEmpty);
    expect(await provider.getMyPosts(user.email), isNotEmpty);
    expect(await provider.getMyPosts("b@guc.edu.eg"), isEmpty);
  });
}
