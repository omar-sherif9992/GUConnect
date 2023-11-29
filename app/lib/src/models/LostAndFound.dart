import 'package:GUConnect/src/models/User.dart';

/// Represents a lost and found item.
class LostAndFound {
  late String content;
  late String image;
  late String location;
  late String contact;
  late DateTime createdAt;
  late bool isFound;
  late User user;

  /// Constructs a [LostAndFound] object with the given [content], [image], [location], and [contact].
  LostAndFound({
    required this.content,
    required this.image,
    required this.location,
    required this.contact,
    required this.createdAt,
    required this.isFound,
    required this.user,
  });

  /// Constructs a [LostAndFound] object from a JSON [Map].
  LostAndFound.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    image = json['image'];
    location = json['location'];
    contact = json['contact'];
    createdAt = DateTime.parse(json['createdAt']);
    isFound = json['isFound'];
    user = User.fromJson(json['user']);
  }

  /// Converts the [LostAndFound] object to a JSON [Map].
  Map<String, Object> toJson() {
    final Map<String, Object> data = <String, Object>{};
    data['content'] = content;
    data['image'] = image;
    data['location'] = location;
    data['contact'] = contact;
    data['createdAt'] = createdAt.toString();
    data['isFound'] = isFound;
    data['user'] = user.toJson();
    return data;
  }

  /// Uploads the image associated with the lost and found item.
  void uploadImage() {
    // TODO: implement uploadImage
  }

  @override
  String toString() {
    return 'content: $content, image: $image, location: $location, contact: $contact, createdAt: $createdAt, isFound: $isFound, user: $user';
  }
}
