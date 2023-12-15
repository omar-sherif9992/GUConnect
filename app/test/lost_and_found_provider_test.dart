import 'package:GUConnect/src/models/Confession.dart';
import 'package:GUConnect/src/models/LostAndFound.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/ConfessionProvider.dart';
import 'package:GUConnect/src/providers/LostAndFoundProvider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final instance = FakeFirebaseFirestore();
  test(
      "post , upload image , and delete a lost and found item of mine and not mine",
      () async {
    final LostAndFoundProvider provider = LostAndFoundProvider(instance);
    final CustomUser user = CustomUser(
      fullName: 'a b c',
      userName: 'abc',
      email: 'a@guc.edu.eg',
      password: 'abcdef1',
    );
    LostAndFound item = LostAndFound(
        contact: "Hussein Yasser",
        content: "item lost",
        createdAt: DateTime.now(),
        image: "url",
        sender: user, comments: [], likes: {});
    await provider.postItem(item);
    expect(await provider.getMyItems(user.email), isNotEmpty);
    expect(await provider.getItems(), isNotEmpty);
    await provider.uploadImage(item.id, "new image");
    LostAndFound newItem = await provider.getItemById(item.id);
    expect(newItem, isNotNull);
    expect(newItem.image, "new image");
    await provider.deleteItem(newItem.id);
    expect(await provider.getMyItems(user.email), isEmpty);
    expect(await provider.getItems(), isEmpty);
    user.email = "b@guc.edu.eg";
    await provider.postItem(item);
    expect(await provider.getMyItems("a@guc.edu.eg"), isEmpty);
    expect(await provider.getItems(), isNotEmpty);
  });
}
