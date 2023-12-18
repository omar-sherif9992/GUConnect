import 'package:GUConnect/src/models/Comment.dart';
import 'package:GUConnect/src/models/Post.dart';
import 'package:GUConnect/src/models/User.dart';

/// Represents a confession made by a user.
class Confession extends Post {
  late bool isAnonymous;

  late List<CustomUser>? mentionedPeople;
  late List<Comment> comments;
  late Set<String> likes;

  /// Constructs a Confession object with the given parameters.
  Confession({
    required this.isAnonymous,
    required super.content,
    required super.sender,
    required super.createdAt,
    this.mentionedPeople,
    required this.comments,
    required this.likes, 
  });

  factory Confession.fromJson(Map<String, dynamic> json) {
  return Confession(
    content: json['content'] ?? '',
    sender: CustomUser.fromJson(json['sender'] ?? {}),
    createdAt: DateTime.parse(json['createdAt'] ?? ''),
    isAnonymous: json['isAnonymous'] ?? false,
    mentionedPeople: ((json['mentionedPeople'] as List<dynamic>)
        .map((e) => CustomUser.fromJson(e as Map<String, dynamic>))).toList(),
    comments: ((json['comments'] as List<dynamic>)
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))).toList(),
    likes: Set<String>.from(json['likes']),
  )..id = json['id'] ?? '';
}

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['isAnonymous'] = bool.parse(isAnonymous.toString());
    data['mentionedPeople'] = mentionedPeople!.map((comment) => comment.toJson()).toList();
    data['comments'] = comments.map((c) => c.toJson()).toList();
    data['likes'] = likes;
    return data;
  }

  @override
  String toString() {
    return '${super.toString()}, isAnonymous: $isAnonymous';
  }
}
