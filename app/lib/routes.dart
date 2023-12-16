import 'package:GUConnect/src/screens/admin/pending_reports.dart';
import 'package:GUConnect/src/screens/admin/pendings_screen.dart';
import 'package:GUConnect/src/screens/admin/search_course.dart';
import 'package:GUConnect/src/screens/admin/set_important_contacts_screen.dart';
import 'package:GUConnect/src/screens/common/AcademicRelated/academicRelated.dart';
import 'package:GUConnect/src/screens/common/AcademicRelated/addAcademicQuestion.dart';
import 'package:GUConnect/src/screens/common/L&F/addLostAndFoundPost.dart';
import 'package:GUConnect/src/screens/common/L&F/lostAndFound.dart';
import 'package:GUConnect/src/screens/admin/set_staff_screen.dart';
import 'package:GUConnect/src/screens/common/confessions.dart';
import 'package:GUConnect/src/screens/common/newsEvents/addPostClubs.dart';
import 'package:GUConnect/src/screens/admin/search_staff.dart';
import 'package:GUConnect/src/screens/common/newsEvents/clubsAndEvents.dart';
import 'package:GUConnect/src/screens/authentication/login.dart';
import 'package:GUConnect/src/screens/authentication/register.dart';
import 'package:GUConnect/src/screens/course/course_profile.dart';
import 'package:GUConnect/src/screens/staff/profile.dart';
import 'package:GUConnect/src/screens/user/search.dart';
import 'package:GUConnect/src/screens/common/splash.dart';
import 'package:GUConnect/src/screens/common/important_contacts.dart';
import 'package:GUConnect/src/screens/user/profile.dart';
import 'package:GUConnect/src/screens/user/profile_edit.dart';
import 'package:GUConnect/src/screens/user/settings.dart';
import 'package:flutter/material.dart';
import 'package:GUConnect/src/screens/common/officesAndOutlets.dart';

class CustomRoutes {
  // USER ROUTES
  static const String home = '/';
  // static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String profile = '/profile';
  static const String profileEdit = '/profile-edit';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String help = '/help';
  static const String privacy = '/privacy';
  static const String terms = '/terms';
  static const String notifications = '/notifications';
  static const String search = '/search';
  static const String searchResults = '/search-results';
  static const String news = '/news';
  static const String newsDetail = '/news-detail';
  static const String confessions = '/confessions';
  static const String confessionsDetail = '/confessions-detail';
  static const String lostAndFound = '/lost-and-found';
  static const String lostAndFoundDetail = '/lost-and-found-detail';
  static const String report = '/report';
  static const String impPhoneNumber = '/important-phone-numbers';
  static const String officesAndOutlets = '/offices-and-outlets';
  static const String clubsAndEvents = '/club-posts-and-events';
  static const String addClubPost = '/club-and-events-addPost';
  static const String addLostAndFound = '/lost-and-found-addPost';
  static const String academicRelatedQuestions = '/academic-related-questions';
  static const String addAcademicRelatedQuestions =
      '/add-academic-related-questions';

  // STAFF ROUTES
  static const String staff = '/staff/profile';

  // ADMIN ROUTES
  static const String adminNotifications = '/admin/notifications';
  static const String adminPendings = '/admin/pendings';
  static const String adminConfessionsDetail = '/admin/confessions-detail';
  static const String adminAcademicQuestions = '/admin/academic-questions';
  static const String adminAcademicQuestionsDetail =
      '/admin/academic-questions-detail';
  static const String adminLostAndFoundDetail = '/admin/lost-and-found-detail';
  static const String adminUsers = '/admin/users';
  static const String adminUsersDetail = '/admin/users-detail';
  static const String adminStaff = '/admin/staff';
  static const String adminCourse = '/admin/courses';
  static const String adminReports = '/admin/reports';
  static const String adminAddStaff = '/admin/add-staff';
  static const String addImportantContacts = '/admin/add-important-contacts';

  // Course Routes
  static const String course = '/course/detail';

  static Map<String, WidgetBuilder> get routes {
    return {
      home: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      profile: (context) => const ProfileScreen(),
      search: (context) => const SearchScreen(),
      profileEdit: (context) => const ProfileEditScreen(),
      settings: (context) => const SettingsScreen(),
      impPhoneNumber: (context) => const ImportantContactsScreen(),
      officesAndOutlets: (context) => const OfficesAndOutlets(),
      confessions: (context) => const Confessions(),
      adminPendings: (context) => const PendingsScreen(),
      clubsAndEvents: (context) => const ClubsAndEvents(),
      addClubPost: (context) => const AddPost(),
      adminStaff: (context) => const SearchStaffScreen(),
      lostAndFound: (context) => const LostAndFoundW(),
      addLostAndFound: (context) => const AddLostAndFoundPost(),
      academicRelatedQuestions: (context) => const AcademicRelatedQuestions(),
      addAcademicRelatedQuestions: (context) => const AddAcademicPost(),
      addImportantContacts: (context) => const SetImportantContactsScreen(),
      staff: (context) => const StuffProfile(),
      adminAddStaff: (context) => const SetStaffScreen(),
      adminReports: (context) => const PendingReportsScreen(),
      adminCourse: (context) => const SearchCourseScreen(),
      course: (context) => const CourseProfile(),
    };
  }
}
