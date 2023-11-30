class Post {
  final String text;
  final String? imageUrl;
  final int likes;
  final int comments;

  Post({
    required this.text,
    required this.likes,
    required this.comments,
    this.imageUrl,
  });
}

final List<Post> posts = [
  Post(
    text: 'This is a beautiful sunset!',
    imageUrl:
        'https://t4.ftcdn.net/jpg/01/43/42/83/360_F_143428338_gcxw3Jcd0tJpkvvb53pfEztwtU9sxsgT.jpg',
    likes: 42,
    comments: 10,
  ),
  Post(
    text: 'Exploring new places!',
    imageUrl:
        'https://t4.ftcdn.net/jpg/01/43/42/83/360_F_143428338_gcxw3Jcd0tJpkvvb53pfEztwtU9sxsgT.jpg',
    likes: 30,
    comments: 5,
  ),
  Post(
    text: 'third post dasdasda',
    likes: 30,
    comments: 5,
  ),
  Post(
    text: 'third post dasdasda',
    likes: 30,
    comments: 5,
  ),
  Post(
    text: 'third post dasdasda',
    likes: 30,
    comments: 5,
  ),
  Post(
    text: 'third post dasdasda',
    likes: 30,
    comments: 5,
  ),
  Post(
    text: 'third post dasdasda',
    likes: 30,
    comments: 5,
  ),
  // Add more posts as needed
];
