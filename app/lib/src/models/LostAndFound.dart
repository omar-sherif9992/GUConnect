import 'package:GUConnect/src/models/User.dart';

/// Represents a lost and found item.
class LostAndFound {
  late String? id;
  late String content;
  late String image;
  late String location;
  late String contact;
  late DateTime createdAt;
  late bool isFound;
  late String approvalStatus = 'pending';

  late CustomUser user;

  /// Constructs a [LostAndFound] object with the given [content], [image], [location], and [contact].
  LostAndFound({
    required this.content,
    required this.image,
    required this.location,
    required this.contact,
    required this.createdAt,
    required this.isFound,
    required this.user,
  })
  {
    id = user.email + createdAt.toString();
  }

  /// Constructs a [LostAndFound] object from a JSON [Map].
  LostAndFound.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    image = json['image'];
    location = json['location'];
    contact = json['contact'];
    createdAt = DateTime.parse(json['createdAt']);
    isFound = json['isFound'];
    user = CustomUser.fromJson(json['user']);
    approvalStatus = json['approvalStatus'];
  }

  /// Converts the [LostAndFound] object to a JSON [Map].
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, Object>{};
    data['id'] = id;
    data['content'] = content;
    data['image'] = image;
    data['location'] = location;
    data['contact'] = contact;
    data['createdAt'] = createdAt.toString();
    data['isFound'] = isFound;
    data['user'] = user.toJson();
    data['approvalStatus'] = approvalStatus;
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
