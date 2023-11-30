import 'package:GUConnect/firebase_options.dart';
import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/providers/user_provider.dart';
import 'package:GUConnect/src/providers/AcademicQuestionProvider.dart';
import 'package:GUConnect/src/providers/ImportantPhoneNumberProvider.dart';
import 'package:GUConnect/src/providers/LostAndFoundProvider.dart';
import 'package:GUConnect/src/providers/NewsEventClubProvider.dart';
import 'package:GUConnect/src/providers/OfficeLocationProvider.dart';
import 'package:GUConnect/themes/themes.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeApp();

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
          create: (context) => LostAndFoundProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NewsEventClubProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OfficeLocationProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'GUConnect',
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
        themeMode: ThemeMode.system,
        locale: DevicePreview.locale(context),
        useInheritedMediaQuery: true,
        builder: DevicePreview.appBuilder,
        initialRoute: '/',
        routes: CustomRoutes.routes,
      ),
    );
  }
}

Future initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Allow only portrait mode
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //tz.initializeTimeZones();
  // FirebaseMessaging.instance.getInitialMessage();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await dotenv.load(fileName: ".env");
  // ex:
/*       String apiKey = dotenv.env['API_KEY']!;
    String baseUrl = dotenv.env['BASE_URL']!;
     */

// Plugin must be initialized before using
/*   await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      ); */
}
