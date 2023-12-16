import 'package:GUConnect/firebase_options.dart';
import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/providers/CommentProvider.dart';
import 'package:GUConnect/src/providers/ConfessionProvider.dart';
import 'package:GUConnect/src/providers/CourseProvider.dart';
import 'package:GUConnect/src/providers/ImportantEmailProvider.dart';
import 'package:GUConnect/src/providers/RatingProvider.dart';
import 'package:GUConnect/src/providers/ReportsProvider.dart';
import 'package:GUConnect/src/providers/LikesProvider.dart';
import 'package:GUConnect/src/providers/StaffProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/providers/AcademicQuestionProvider.dart';
import 'package:GUConnect/src/providers/ImportantPhoneNumberProvider.dart';
import 'package:GUConnect/src/providers/LostAndFoundProvider.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/providers/OfficeLocationProvider.dart';
import 'package:GUConnect/src/services/notification_api.dart';
import 'package:GUConnect/themes/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeApp();

  FirebaseNotification().initNotification();

  runApp(DevicePreview(
    enabled: true,
    builder: (BuildContext context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              UserProvider(FirebaseAuth.instance, FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              AcademicQuestionProvider(FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => CourseProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ImportantPhoneNumberProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StaffProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ImportantEmailProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LostAndFoundProvider(FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              NewsEventClubProvider(FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => OfficeLocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CommentProvider(FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => ReportsProvider(FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => CommentProvider(FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => ConfessionProvider(FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => LikesProvider(FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider(create: (context) => RatingProvider())
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'GUConnect',
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
        themeMode: ThemeMode.system,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        initialRoute: CustomRoutes.profile,
        routes: CustomRoutes.routes,
      ),
    );
  }
}

Future initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // tz.initializeTimeZones();
  // FirebaseMessaging.instance.getInitialMessage();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await dotenv.load(fileName: ".env");
}
