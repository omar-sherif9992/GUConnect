class Post {
  final String text;
  final String imageUrl;
  final int likes;
  final int comments;

  Post(
      {required this.text,
      required this.imageUrl,
      required this.likes,
      required this.comments});
}

final List<Post> posts = [
  Post(
    text: 'This is a beautiful sunset!',
    imageUrl: 'https://example.com/sunset.jpg',
    likes: 42,
    comments: 10,
  ),
  Post(
    text: 'Exploring new places!',
    imageUrl: 'https://example.com/travel.jpg',
    likes: 30,
    comments: 5,
  ),
  // Add more posts as needed
];
