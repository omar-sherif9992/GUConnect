import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/NewsEventClub.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/widgets/bottom_bar.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:GUConnect/src/widgets/post.dart';
import 'package:GUConnect/src/dummy_data/posts.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ClubsAndEvents extends StatefulWidget{

  const ClubsAndEvents({super.key});

  @override
  State<ClubsAndEvents> createState() => _ClubsAndEventsState();
}

class _ClubsAndEventsState extends State<ClubsAndEvents> {
  

  final CustomUser posterPerson = CustomUser(email: 'hussein.ebrahim@student.guc.edu.eg', password: 'Don Ciristiane Ronaldo', userType: UserType.student,
    image: 'https://images.mubicdn.net/images/cast_member/25100/cache-2388-1688754259/image-w856.jpg', userName: 'HusseinYasser');

  late NewsEventClub post = NewsEventClub(content: "IEEE is helding the new mega event, the MEGAMIND. Don't miss it out, we are waiting for you all next wednesday, registerations is open through this link ..... .", 
  poster: posterPerson, image: 'https://www.guc-asic.com/upload/images/ieee.png', createdAt: DateTime.now());

  late NewsEventClubProvider clubPostProvider;

  List<NewsEventClub> posts2 = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    clubPostProvider = Provider.of<NewsEventClubProvider>(context, listen: false);


    fetchPosts(clubPostProvider).then((value)=>{
        setState((){
          _isLoading = false;
        })
      }
    );
    
  }

  Future fetchPosts(NewsEventClubProvider provider) async{
    provider.getPosts().then((value) => {
      setState((){
        posts2 = value;
        posts2.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      })
    });
    
  }

  Future<void> _refresh() async {
    fetchPosts(clubPostProvider);
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(context)
  {
    
    final IconButton addPost = IconButton(
      onPressed: (){
        Navigator.of(context).pushNamed(CustomRoutes.addClubPost);
      },
      icon: Icon(Icons.add_box_outlined,
        color: Theme.of(context).colorScheme.onBackground,
        size: 24),
      );
    
    

    return Scaffold(
      drawer: const MainDrawer(),
      appBar:  CustomAppBar(
        title: '',
        actions: [
          addPost
        ],
      ),

      body: _isLoading? const Loader(): Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                itemCount: posts2.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(height: 20,),
                      PostW(
                        caption: posts2[index].content,
                        imgUrl: posts2[index].image,
                        username: posts2[index].poster.userName ?? '',
                        userImage: posts2[index].poster.image ?? '',
                        likes: 500,
                        createdAt: posts2[index].createdAt,
                        comments: posts[0].comments,
                      ),
                    ],
                  );
                  }
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}