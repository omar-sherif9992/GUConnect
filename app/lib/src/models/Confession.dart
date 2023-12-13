import 'package:GUConnect/src/models/Post.dart';

/// Represents a confession made by a user.
class Confession extends Post {
  late bool isAnonymous;

  /// Constructs a Confession object with the given parameters.
  Confession({
    required this.isAnonymous,
    required super.content,
    required super.sender,
    required super.createdAt,
    required super.image,
  });

  Confession.fromJson(super.json)
      : isAnonymous = json['isAnonymous'],
        super.fromJson();

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
