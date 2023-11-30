import 'package:GUConnect/src/dummy_data/posts.dart';
import 'package:flutter/material.dart';
import 'package:GUConnect/src/widgets/post_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     IconButton(
          //       icon: Icon(Icons.arrow_back),
          //       onPressed: () {},
          //     ),
          //     SizedBox(width: 16), // Add some spacing between buttons
          //     IconButton(
          //       icon: Icon(Icons.more_vert),
          //       onPressed: () {},
          //     ),
          //   ],
          // ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 110.0,
                          height: 110.0,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white, // White border color
                              width: 3.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.network(
                              'https://statusneo.com/wp-content/uploads/2023/02/MicrosoftTeams-image551ad57e01403f080a9df51975ac40b6efba82553c323a742b42b1c71c1e45f1.jpg',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Anas Khan",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Text(
                                "EMS Prof",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.grey,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: Color.fromARGB(255, 242, 200, 147),
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'C7 203',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: const Color.fromARGB(
                                          255, 242, 200, 147),
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      '20 Posts',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: const Color.fromARGB(
                                          255, 242, 200, 147),
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Rating : 4.7',
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ])
                      ],
                    ),
                    Text("this is my bio , lorem ipsum gg"),
                  ],
                )
              ],
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     ClickableIcon(Icons.grid_on, 'Posts', () {}),
          //     ClickableIcon(Icons.message, 'Confessions', () {}),
          //   ],
          // ),
          // Divider(
          //   color: Colors.grey,
          //   thickness: 1.0,
          //   height: 0.0,
          // ),
          // Row(
          //   children: [
          //     Column(
          //       children: List.generate(posts.length, (index) {
          //         return Post_Widget(posts[index]);
          //       }),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}

class ClickableIcon extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final VoidCallback onTap;

  ClickableIcon(this.icon, this.labelText, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            size: 50.0,
            color: Colors.blue,
          ),
          SizedBox(height: 8.0),
          Text(
            labelText,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
