import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/models/Post.dart';

/// Represents a lost and found item.
class LostAndFound extends Post {
  late String location;
  late String contact;
  late bool isFound;
  late String approvalStatus = 'pending';

  /// Constructs a [LostAndFound] object with the given [content], [image], [location], and [contact].
  LostAndFound({
    required this.location,
    required this.contact,
    required this.isFound,
    required super.content,
    required super.createdAt,
    required super.image,
    required super.sender,
  });

  LostAndFound.fromJson(Map<String, dynamic> json)
      : super(
          content: json['content'],
          sender: CustomUser.fromJson(json['sender']),
          createdAt: DateTime.parse(json['createdAt']),
          image: json['image'],
        ) {
    id = json['id'];
    approvalStatus = json['approvalStatus'];
    location = json['location'];
    contact = json['contact'];
    isFound = json['isFound'];
  }

  /// Converts the [LostAndFound] object to a JSON [Map].
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['id'] = id;
    data['location'] = location;
    data['contact'] = contact;
    data['isFound'] = isFound;
    data['approvalStatus'] = approvalStatus;
    return data;
  }

  void uploadImage() {}

  @override
  String toString() {
    return '${super.toString()}, location: $location, contact: $contact, isFound: $isFound';
  }
}
