class Post {
  final String text;
  final String imageUrl;
  final int likes;
  final List<Comment> comments;

  Post(
      {required this.text,
      required this.imageUrl,
      required this.likes,
      required this.comments});

}

class Comment{
  final String content;
  final String userName;
  final String userImgUrl;
  final DateTime createdAt;

  Comment(
    {
      required this.content,
      required this.userName,
      required this.userImgUrl,
      required this.createdAt
    }
  );
}

final List<Comment> comments = [
  Comment(content: 'This event will be LIT, Must attend!!', userName: 'MaxPayne', userImgUrl: 'https://upload.wikimedia.org/wikipedia/en/thumb/7/71/MaxPayneMP3.jpg/235px-MaxPayneMP3.jpg', createdAt: DateTime.now()),
  Comment(content: 'it must have been in another day because this one will not be that good and i have another arrangments what a miss', userName: 'MaxPayne', userImgUrl: 'https://upload.wikimedia.org/wikipedia/en/thumb/7/71/MaxPayneMP3.jpg/235px-MaxPayneMP3.jpg', createdAt: DateTime.now()),
  Comment(content: 'Max Payne 3 is the best game ever, and the Game of mini project 2 was the best remake of max payne 3 MUST PLAY!!! <3', userName: 'MaxPayne', userImgUrl: 'https://upload.wikimedia.org/wikipedia/en/thumb/7/71/MaxPayneMP3.jpg/235px-MaxPayneMP3.jpg', createdAt: DateTime.now()),
];

final List<Post> posts = [
  Post(
    text: 'This is a beautiful sunset!',
    imageUrl: 'https://t4.ftcdn.net/jpg/06/14/46/77/360_F_614467744_7eLjYhKWJIvnu8fk8MTp9VXFYpB15J3p.jpg',
    likes: 42,
    comments: comments,
  ),
  Post(
    text: 'Exploring new places!',
    imageUrl: 'https://t4.ftcdn.net/jpg/06/14/46/77/360_F_614467744_7eLjYhKWJIvnu8fk8MTp9VXFYpB15J3p.jpg',
    likes: 30,
    comments: comments,
  ),
  Post(
    text: 'This is a beautiful sunset!',
    imageUrl: 'https://t4.ftcdn.net/jpg/06/14/46/77/360_F_614467744_7eLjYhKWJIvnu8fk8MTp9VXFYpB15J3p.jpg',
    likes: 42,
    comments: comments,
  ),
  Post(
    text: 'Exploring new places!',
    imageUrl: 'https://t4.ftcdn.net/jpg/06/14/46/77/360_F_614467744_7eLjYhKWJIvnu8fk8MTp9VXFYpB15J3p.jpg',
    likes: 30,
    comments: comments,
  ),
  Post(
    text: 'This is a beautiful sunset!',
    imageUrl: 'https://t4.ftcdn.net/jpg/06/14/46/77/360_F_614467744_7eLjYhKWJIvnu8fk8MTp9VXFYpB15J3p.jpg',
    likes: 42,
    comments: comments,
  ),
  Post(
    text: 'Exploring new places!',
    imageUrl: 'https://t4.ftcdn.net/jpg/06/14/46/77/360_F_614467744_7eLjYhKWJIvnu8fk8MTp9VXFYpB15J3p.jpg',
    likes: 30,
    comments: comments,
  ),
  // Add more posts as needed
];
