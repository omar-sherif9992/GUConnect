import 'package:GUConnect/src/providers/UserProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GUConnect/src/models/Usability.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsabilityProvider extends NavigatorObserver  with ChangeNotifier  {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
   String? currentScreenName;
   DateTime? screenEnterTime;
    DateTime? screenExitTime;
    UsabilityProvider(FirebaseFirestore firestore, FirebaseAuth auth)  // Modify this line
      : _firestore = firestore,
        _auth = auth;
   Future<void> logScreenTime(Usability usability, ScreenTime screenTime) async {
    try {
      // Check if the document exists
      var querySnapshot = await _firestore
          .collection('usability')
          .where('user_email', isEqualTo: usability.user_email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If the document doesn't exist, create a new one
        await _firestore.collection('usability').add({
          'user_email': usability.user_email,
          'user_type': usability.user_type,
          'screenTimes': [screenTime.toJson()],
        });
      } else {
        // If the document exists, update the events list
        await querySnapshot.docs.first.reference.update({
          'screenTimes': FieldValue.arrayUnion([screenTime.toJson()])
        });
      }
    } catch (e) {
      print('Error logging event: $e');
    }
  }

@override
void didPush(Route route, Route? previousRoute) {
  super.didPush(route, previousRoute);

  // Log screen time for the previous screen if it exists
  if (previousRoute != null) {
    try {
      screenExitTime = DateTime.now();
      logScreenTime(
        Usability(user_email: _auth.currentUser!.email!),
        ScreenTime(
          screenName: currentScreenName!,
          startTime: screenEnterTime!,
          endTime: screenExitTime!,
        ));
    } catch (e) {
      print(e);
    }
  }
  screenEnterTime = DateTime.now();
  currentScreenName = route.settings.name;
}

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // When a screen is popped
    try{
    screenExitTime = DateTime.now();
    logScreenTime(
      Usability(user_email: _auth.currentUser!.email!),
      ScreenTime(
        screenName: currentScreenName!,
        startTime: screenEnterTime!,
        endTime: screenExitTime!,
      ));
        screenEnterTime = DateTime.now();
        currentScreenName = previousRoute?.settings.name;
      }
    catch(e){
      print(e);
    }
    }
  Future<void> logEvent(Usability usability, UserEvent event) async {
    try {
      // Check if the document exists
      var querySnapshot = await _firestore
          .collection('usability')
          .where('user_email', isEqualTo: usability.user_email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If the document doesn't exist, create a new one
        await _firestore.collection('usability').add({
          'user_email': usability.user_email,
          'user_type': usability.user_type,
          'events': [event.toJson()],
        });
      } else {
        // If the document exists, update the events list
        await querySnapshot.docs.first.reference.update({
          'events': FieldValue.arrayUnion([event.toJson()])
        });
      }
    } catch (e) {
      print('Error logging event: $e');
    }
  }

    
}
