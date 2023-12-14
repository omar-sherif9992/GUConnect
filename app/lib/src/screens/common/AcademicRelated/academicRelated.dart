import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/models/AcademicQuestion.dart';
import 'package:GUConnect/src/models/NewsEventClub.dart';
import 'package:GUConnect/src/models/User.dart';
import 'package:GUConnect/src/providers/AcademicQuestionProvider.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/widgets/bottom_bar.dart';
import 'package:GUConnect/src/widgets/loader.dart';
import 'package:GUConnect/src/widgets/post.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
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

  List<AcademicQuestion> posts = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    academicProvider =
        Provider.of<AcademicQuestionProvider>(context, listen: false);
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
                        child: ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  PostW(
                                    postId: posts[index].id,
                                    content: posts[index].content,
                                    image: posts[index].image,
                                    user:
                                        posts[index].sender,
                                    likes: posts[index].likes,
                                    createdAt: posts[index].createdAt,
                                    comments: posts[index].comments,
                                    postType: 2,
                                  ),
                                ],
                              );
                            }),
                      ),
                    )
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
