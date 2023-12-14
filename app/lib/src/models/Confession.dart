import 'package:GUConnect/src/models/Post.dart';
import 'package:GUConnect/src/models/User.dart';

/// Represents a confession made by a user.
class Confession extends Post {
  late bool isAnonymous;

  /// Constructs a Confession object with the given parameters.
  Confession({
    required this.isAnonymous,
    required super.content,
    required super.sender,
    required super.createdAt,
    super.image = '',
  });

  factory Confession.fromJson(Map<String, dynamic> json) {
    return Confession(
      content: json['content'] ?? '',
      sender: CustomUser.fromJson(json['sender'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      isAnonymous:
          json['isAnonymous'] ?? false, // Provide a default value if needed
      image: json['image'] ?? '',
    )..id = json['id'] ?? ''; // Include id with null check
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['isAnonymous'] = bool.parse(isAnonymous.toString());
    return data;
  }

  @override
  String toString() {
    return '${super.toString()}, isAnonymous: $isAnonymous';
  }
}
