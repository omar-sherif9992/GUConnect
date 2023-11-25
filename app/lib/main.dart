import 'package:GUConnect/routes.dart';
import 'package:GUConnect/src/screens/Home.dart';
import 'package:GUConnect/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  await initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GUConnect',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      routes: CustomRoutes.routes,
    );
  }
}

Future initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
/*   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); */
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
