import 'dart:io';

import 'package:GUConnect/src/models/Staff.dart';
import 'package:GUConnect/src/utils/uploadImageToStorage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class StaffProvider extends ChangeNotifier {
  final staffsRef =
      FirebaseFirestore.instance.collection('staffs').withConverter<Staff>(
            fromFirestore: (snapshot, _) => Staff.fromJson(snapshot.data()!),
            toFirestore: (staff, _) => staff.toJson(),
          );

  Future<List<Staff>> searchStaff(String name) async {
    final List<Staff> staffs = [];
    final QuerySnapshot<Staff> querySnapshot =
        await staffsRef.where('name', isEqualTo: name).get();

    querySnapshot.docs.forEach((doc) {
      staffs.add(doc.data());
    });
    return staffs;
  }

  Future<List<Staff>> getProffessors() async {
    final List<Staff> profs = [];
    final QuerySnapshot<Staff> querySnapshot = await staffsRef
        .where(
          'staffType',
          isEqualTo: 'professor',
        )
        .get();

    querySnapshot.docs.forEach((doc) {
      profs.add(doc.data());
    });
    return profs;
  }

  Future<List<Staff>> getTas() async {
    final List<Staff> tas = [];
    final QuerySnapshot<Staff> querySnapshot = await staffsRef
        .where(
          'staffType',
          isEqualTo: 'ta',
        )
        .get();

    querySnapshot.docs.forEach((doc) {
      print(doc.data());
      tas.add(doc.data());
    });
    return tas;
  }

  Future<List<Staff>> getStaffs() async {
    final List<Staff> staffs = [];
    final QuerySnapshot<Staff> querySnapshot = await staffsRef.get();
    querySnapshot.docs.forEach((doc) {
      staffs.add(doc.data());
    });
    return staffs;
  }

  Future<void> setStaff(Staff staff, File? profileImageFile) async {
    try {
      if (profileImageFile != null) {
        final String? imageUrl = await uploadImageToStorage(
            profileImageFile, 'staff_images', staff.email);
        if (imageUrl != null) staff.image = imageUrl;
      }
      await staffsRef.doc(staff.email).set(staff);
      notifyListeners();
    } catch (e) {
      print("Error setting staff");
      print(e);
    }
  }

  Future<void> deleteStaff(Staff staff) async {
    try {
      await staffsRef.doc(staff.email).delete();
      notifyListeners();
    } catch (e) {
      print("Error deleting staff");
      print(e);
    }
  }
}
