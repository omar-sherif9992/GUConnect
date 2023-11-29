import 'package:GUConnect/src/models/User.dart';

/// Represents a confession made by a user.
class Confession {
  late String content;
  late User sender;
  late bool isAnonymous;
  late DateTime createdAt;
  

  /// Constructs a Confession object with the given parameters.
  Confession({
    required this.content,
    required this.sender,
    required this.isAnonymous,
    required this.createdAt,
  });

  /// Constructs a Confession object from a JSON map.
  Confession.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    sender = User.fromJson(json['sender']);
    isAnonymous = json['isAnonymous'];
    createdAt = DateTime.parse(json['createdAt']);
  }

  /// Converts the Confession object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['sender'] = sender.toJson();
    data['isAnonymous'] = isAnonymous;
    data['createdAt'] = createdAt.toString();
    return data;
  }

  @override
  String toString() {
    return 'content: $content, sender: $sender, isAnonymous: $isAnonymous, createdAt: $createdAt';
  }
}
