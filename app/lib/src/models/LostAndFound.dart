class LostAndFound {
  late String content;
  late String image;
  late String location;
  late String contact;

  LostAndFound(
      {required this.content,
      required this.image,
      required this.location,
      required this.contact});

  LostAndFound.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    image = json['image'];
    location = json['location'];
    contact = json['contact'];
  }

  Map<String, Object> toJson() {
    final Map<String, Object> data = <String, Object>{};
    data['content'] = content;
    data['image'] = image;
    data['location'] = location;
    data['contact'] = contact;
    return data;
  }
}
