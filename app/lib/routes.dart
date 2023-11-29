import 'package:GUConnect/src/screens/Home.dart';
import 'package:GUConnect/src/screens/authentication/login.dart';
import 'package:GUConnect/src/screens/authentication/register.dart';
import 'package:GUConnect/src/screens/splash.dart';
import 'package:GUConnect/src/screens/user/profile.dart';
import 'package:GUConnect/src/screens/user/profile_edit.dart';
import 'package:GUConnect/src/screens/user/settings.dart';
import 'package:flutter/material.dart';

class CustomRoutes {
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


  static Map<String, WidgetBuilder> get routes {
    return {
      home: (context) => const Splash(),
      // splash: (context) => const Splash(),
      login: (context) => const Login(),
      register: (context) => const Register(),
      profile: (context) => const Profile(),
      profileEdit: (context) => const ProfileEdit(),
      settings: (context) => const Settings(),
    };
  }



}