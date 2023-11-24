/// Represents a lost and found item.
class LostAndFound {
  late String content;
  late String image;
  late String location;
  late String contact;

  /// Constructs a [LostAndFound] object with the given [content], [image], [location], and [contact].
  LostAndFound({
    required this.content,
    required this.image,
    required this.location,
    required this.contact,
  });

  /// Constructs a [LostAndFound] object from a JSON [Map].
  LostAndFound.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    image = json['image'];
    location = json['location'];
    contact = json['contact'];
  }

  /// Converts the [LostAndFound] object to a JSON [Map].
  Map<String, Object> toJson() {
    final Map<String, Object> data = <String, Object>{};
    data['content'] = content;
    data['image'] = image;
    data['location'] = location;
    data['contact'] = contact;
    return data;
  }

  /// Uploads the image associated with the lost and found item.
  void uploadImage() {
    // TODO: implement uploadImage
  }

  @override
  String toString() {
    return 'content: $content, image: $image, location: $location, contact: $contact';
  }
}
