import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/AcademicQuestion.dart';
import 'package:GUConnect/src/models/NewsEventClub.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/AcademicQuestionProvider.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/providers/UsabilityProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/widgets/bottom_bar.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:GUConnect/src/widgets/post.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class AcademicRelatedQuestions extends StatefulWidget {
  const AcademicRelatedQuestions({super.key});

  @override
  State<AcademicRelatedQuestions> createState() => _AcademicRelatedQuestionsState();
}

class _AcademicRelatedQuestionsState extends State<AcademicRelatedQuestions> {
  final CustomUser posterPerson = CustomUser(
      email: 'hussein.ebrahim@student.guc.edu.eg',
      password: 'Don Ciristiane Ronaldo',
      image:
          'https://images.mubicdn.net/images/cast_member/25100/cache-2388-1688754259/image-w856.jpg',
      userName: 'HusseinYasser',
      fullName: 'omar');

  late AcademicQuestionProvider academicProvider;
  late UserProvider userProvider;
  late UsabilityProvider usabilityProvider;

  List<AcademicQuestion> posts = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    academicProvider =
        Provider.of<AcademicQuestionProvider>(context, listen: false);
      usabilityProvider=Provider.of<UsabilityProvider>(context,listen: false);
      userProvider=Provider.of<UserProvider>(context,listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // When it comes back to view
    _isLoading = true;
    fetchPosts(academicProvider).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future fetchPosts(AcademicQuestionProvider provider) async {
    provider.getQuestions().then((value) => {
          setState(() {
            posts = value;
            posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          })
        });
  }

  Future<void> _refresh() async {
    fetchPosts(academicProvider);
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(context) {
    final IconButton addPost = IconButton(
      onPressed: () {
        usabilityProvider.logEvent(userProvider.user!.email,'Open_Add_Academic_Related_Question_Screen');
        Navigator.of(context).pushNamed(CustomRoutes.addAcademicRelatedQuestions);
      },
      icon: Icon(Icons.add_box_outlined,
          color: Theme.of(context).colorScheme.onBackground, size: 24),
    );

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: CustomAppBar(
        title: 'Academic-Related Questions',
        actions: [addPost],
      ),
      body: _isLoading
          ? const Loader()
          : posts.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refresh,
                        child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            usabilityProvider.logEvent(userProvider.user!.email , 'Scroll_Up_Academic_Related_Question');
          } else if (notification.direction == ScrollDirection.reverse) {
            usabilityProvider.logEvent(userProvider.user!.email , 'Scroll_Down_Academic_Related_Question');
          }
          return false; // Return false to allow the notification to continue to be dispatched.
        },
        child: ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  PostW(
                                    post: posts[index],
                                    postType: 2,
                                    refresh: _refresh,
                                  ),
                                ],
                              );
                            }),
                      ),
                    ))
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      'Looks like no exams these days.?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                          ),
                    ),
                  ),
                ),
      bottomNavigationBar: const BottomBar(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
