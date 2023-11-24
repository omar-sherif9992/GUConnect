import 'package:GUConnect/src/models/User.dart';

class Confession {
  late String content;
  late User sender;
  late bool Anonymous;
  late DateTime createdAt;
  Confession(
      {required this.content,
      required this.sender,
      required this.Anonymous,
      required this.createdAt});

  Confession.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    sender = User.fromJson(json['sender']);
    Anonymous = json['Anonymous'];
    createdAt = DateTime.parse(json['createdAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['sender'] = sender.toJson();
    data['Anonymous'] = Anonymous;
    data['createdAt'] = createdAt.toString();
    return data;
  }
}
