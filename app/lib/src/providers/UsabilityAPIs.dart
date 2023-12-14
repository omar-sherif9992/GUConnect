import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GUConnect/src/models/Usability.dart';

class UsabilityAPI {
  final FirebaseFirestore _firestore;
  UsabilityAPI(FirebaseFirestore firestore) : _firestore = firestore;

    //

  Future<void> logEvent(Usability usability, UserEvent event) async {
    //     try {
    //   await _firestore
    //       .collection('usability')
    //       .where('user_email', isEqualTo: usability.user_email)
    //       .get()
    //       .then((value) {
    //     value.docs.forEach((element) {
    //       element.reference.update({
    //         'events': FieldValue.arrayUnion([event.toJson()])
    //       });
    //     });
    //   });

    // } catch (e) {
    //   print('Error logging event: $e');
    // }
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
      // If the document exists, update the events list with either incrementing value of old event or adding a new event
      var existingEvents = querySnapshot.docs.first['events'] ?? [];
      var updatedEvents = List<Map<String, dynamic>>.from(existingEvents);

      // Check if an event with the same eventName exists
      var existingEventIndex = updatedEvents.indexWhere((e) => e['eventName'] == event.eventName);

      if (existingEventIndex != -1) {
        // If it exists, increment the value
        updatedEvents[existingEventIndex]['value'] += event.value;
      } else {
        // If it doesn't exist, add the new event
        updatedEvents.add(event.toJson());
      }

      await querySnapshot.docs.first.reference.update({'events': updatedEvents});
    }
  } catch (e) {
    print('Error logging event: $e');
  }
  }
}
