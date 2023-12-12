import 'package:GUConnect/firebase_options.dart';
import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/providers/CommentProvider.dart';
import 'package:GUConnect/src/providers/ConfessionProvider.dart';
import 'package:GUConnect/src/providers/ImportantEmailProvider.dart';
import 'package:GUConnect/src/providers/StaffProvider.dart';
import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:GUConnect/src/providers/AcademicQuestionProvider.dart';
import 'package:GUConnect/src/providers/ImportantPhoneNumberProvider.dart';
import 'package:GUConnect/src/providers/LostAndFoundProvider.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/providers/OfficeLocationProvider.dart';
import 'package:GUConnect/src/services/notification_api.dart';
import 'package:GUConnect/themes/themes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeApp();

  FirebaseNotification().initFirebaseMessaging();

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
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AcademicQuestionProvider(),
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
          create: (context) => LostAndFoundProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NewsEventClubProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OfficeLocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CommentProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConfessionProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'GUConnect',
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
        themeMode: ThemeMode.system,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        initialRoute: CustomRoutes.staff,
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

  await dotenv.load(fileName: ".env");
}
