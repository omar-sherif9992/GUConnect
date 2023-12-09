import 'package:GUConnect/src/models/OfficeAndLocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class OfficeLocationProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<OfficeAndLocation>> searchLocation(String locationName) async {
    final List<OfficeAndLocation> locations = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('officeAndLocation')
        .where('name', isEqualTo: locationName)
        .get();
    querySnapshot.docs.forEach((doc) {
      locations.add(OfficeAndLocation.fromJson(doc.data()));
    });
    return locations;
  }

  Future<List<OfficeAndLocation>> getLocations() async {
    final List<OfficeAndLocation> locations = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firestore.collection('officeAndLocation').get();
    querySnapshot.docs.forEach((doc) {
      locations.add(OfficeAndLocation.fromJson(doc.data()));
    });
    return locations;
  }

  Future<List<OfficeAndLocation>> getOffices() async {
    final List<OfficeAndLocation> locations = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('officeAndLocation')
          .where('isOffice', isEqualTo: true)
          .get();
      querySnapshot.docs.forEach((doc) {
        locations.add(OfficeAndLocation.fromJson(doc.data()));
      });
    } catch (e) {
      print(e);
    }
    return locations;
  }

  Future<List<OfficeAndLocation>> getOutlets() async {
    final List<OfficeAndLocation> locations = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('officeAndLocation')
          .where('isOffice', isEqualTo: false)
          .get();
      querySnapshot.docs.forEach((doc) {
        locations.add(OfficeAndLocation.fromJson(doc.data()));
      });
    } catch (e) {
      print(e);
    }
    return locations;
  }
}
