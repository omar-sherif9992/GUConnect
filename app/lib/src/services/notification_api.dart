import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

class FirebaseNotification {
  static String? _token;

  static String? get token => _token;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future initializeLocalNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logoicon');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) async {
      if (payload != null) {
        if (kDebugMode) {
          print('notification payload: $payload');
        }

        // { 'message' :  }
      }
    });
  }

  void initNotification() async {
    await initFirebaseMessaging();
    await initializeLocalNotification();
  }

  Future<void> initFirebaseMessaging() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
    }
    String? token = await messaging.getToken();
    _token = token;
    if (kDebugMode) {
      print('Registration Token=$token');
    }

    final _messageStreamController = BehaviorSubject<RemoteMessage>();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }
      if (message.notification != null) {
        _flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.notification!.title,
          message.notification!.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/logoicon',
            ),
          ),
          payload: message.data.toString(),
        );
        _messageStreamController.sink.add(message);
      }
    });
  }

  static Future<void> testHealth() async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('checkHealth');
    final results = await callable();
    if (kDebugMode) print(results.data);
  }

  static Future<void> sendNotification(
      String? token, String title, String body) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendNotification');
    final results = await callable(<String, dynamic>{
      'token': token,
      'title': title,
      'body': body,
    });
    if (kDebugMode) print(results.data);
  }

    static Future<bool> sendTagNotification(String taggedUserName,
        String taggedUserToken, String confessionId, String taggerName) async {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('sendTagNotification');
      final results = await callable(<String, dynamic>{
        'taggedUserName': taggedUserName,
        'taggedUserToken': taggedUserToken,
        'confessionId': confessionId,
        'taggerName': taggerName,
      });
      if (kDebugMode) print(results.data);
      return results.data.success;
    }

  static Future<Bool> sendLikeNotification(
      String postOwnerName,
      String postOwnerToken,
      String postId,
      String postType,
      String likerName) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendLikeNotification');
    // post type could be [confession, event post, announcement, ...]
    final results = await callable(<String, dynamic>{
      'postOwner': {
        'name': postOwnerName,
        'token': postOwnerToken,
      },
      'postId': postId,
      'type': postType,
      'likerName': likerName,
    });
    if (kDebugMode) print(results.data);
    return results.data.success;
  }

  static Future<bool> sendPostApprovalNotification(
      String postOwnerName,
      String postOwnerToken,
      String postId,
      String postType,
      String approverName) async {
    final HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallable('sendPostApprovalNotification');
    //    post type could be [confession, event post, announcement, ...]
    final results = await callable(<String, dynamic>{
      'postOwner': {
        'name': postOwnerName,
        'token': postOwnerToken,
      },
      'postId': postId,
    });
    if (kDebugMode) print(results.data);
    return results.data.success;
  }

  static Future<bool> sendBroadcastNotificationNewAnnouncement(
      String postId, String postOwnerName) async {
    final HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallable('sendBroadcastNotificationNewAnnouncement');

    final results = await callable(<String, dynamic>{
      'postOwnerName': postOwnerName,
      'postId': postId,
    });
    if (kDebugMode) print(results.data);
    return results.data.success;
  }
}
